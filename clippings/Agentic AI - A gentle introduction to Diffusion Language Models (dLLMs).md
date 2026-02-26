---
title: "Agentic AI -A gentle introduction to Diffusion Language Models (dLLMs)"
source: "https://x.com/neural_avb/status/2026716991529316816"
author:
  - "[[@neural_avb]]"
published: 2026-02-25
created: 2026-02-26
description: "Assistant Prof. in Astronomy at Tsinghua University, Beijing. @drguangtou@masodon.onlineLove all galaxies, study the big and small ones."
tags:
  - "clippings"
---
Let me just start off by stating the obvious: Diffusion Language Models are **incredi-cool** tech. This article will explain some of the concepts that you must know. We will be mainly looking at a couple of Inception Labs ( [@\_inception\_ai](https://x.com/@_inception_ai) ) papers and the LLada family of models to motivate this discussion.

The papers I referred to while writing this article are all on Arxiv:

- LLaDA2.1: Speeding Up Text Diffusion via Token Editing ([https://arxiv.org/abs/2602.08676](https://arxiv.org/abs/2602.08676))
- d1: Scaling Reasoning in Diffusion Large Language Models via Reinforcement Learning ([https://arxiv.org/abs/2504.12216](https://arxiv.org/abs/2504.12216))
- Mercury: Ultra-Fast Language Models Based on Diffusion ([https://arxiv.org/abs/2506.17298](https://arxiv.org/abs/2506.17298))
- TiDAR: Think in Diffusion, Talk in Autoregression ([https://arxiv.org/abs/2511.08923](https://arxiv.org/abs/2511.08923))

> 22h
> 
> Whosoever cracks diffusion for text and brings it to frontier model performance will immediately upend the economy of LLMs.

Anyway, let's diffuse man.

# The Problem

**So, what's wrong with what we have currently?** Autoregressive models we have currently (ChatGPT, Claude, Gemini, etc) all generate text one token at a time, where each token is conditioned on all previously generated tokens.

This is called "causal language training" - basically, we teach a neural network to predict the next word given a prefix sentence. The neural network looks at all the past tokens and generate the next token.

We add this newly generated token into the list of prefix tokens to generate the next token. So on, we generate an entire sequence of tokens. One at a time.

There are a few problems with this:

1. To generate a sequence of N tokens, you must perform N sequential forward passes through the model. You cannot parallelize across the sequence dimension because token 100 depends on the presence of all 99 tokens before it **Synchronous for loops are slow.**
2. Causal attention means that every token can only see tokens in the past. Meaning if you have a 1000 token system prompt, the 5th token can't "see" the future tokens from token 6-1000. It just sees token 1 to 5! **Causal attention prevents modes to be super expressive.**
3. Once tokens are generated, they are set for life. Autoregressive LLMs cannot by default go back to older tokens and change it based on something they are gonna say in the past. **The past stays the past. Because generation is a time sequence of immutable tokens.**
4. On modern GPUs like the H100, this sequential constraint is bad. The model spends most of its time memory-bound**:** transferring weights and activations rather than actually computing. **If you are paying for GPU inferencing, every millisecond of idle time is hurting your wallet.**

![Image](https://pbs.twimg.com/media/HCBTN6HaMAEcfir?format=jpg&name=large)

# Diffusion in Images

Diffusion in physics describes the process where particles spread from high-concentration regions to low-concentration regions until equilibrium is reached. The classic example is how if we drop a drop of ink into water, it slowly dissolves into the whole water. This process called **forward diffusion**. Genius researchers of our era discovered that you can actually train a neural network to reverse this process with a neural network. They have already applied diffusion for generative image models.

![Image](https://pbs.twimg.com/media/HCBVtWSbQAAdTgP?format=jpg&name=large)

Diffusion image models input a noisy shitty image and gradually denoise it into actual images!

Generative image models input a fully noisy image. The trained neural network predicts "what error should we remove from this current image to get a purer image". We remove this error from the noisy image to get a slightly clearer image.

> Effectively we are iterating over revisions of the image. We are not directly predicting the perfect pixel at each location in one go. Instead we are generating a slightly clearer image, and through repeating this step multiple times, we end up with a clear image.

How can we apply the same concept of iterative noise removal to a text domain??

# Applying Diffusion on Text

Given a noisy version of text, we want to reconstruct the original clean sequence. In most Diffusion papers (like LLada) this denoising generally happens using a special \[MASK\] token.

**Example of how this works at inference time:**

**Prompt:** "Solve: 5 \* 3 = ?" Step 1 (t=1.0): "Solve: 5 \* 3 = ? \[MASK\] \[MASK\] \[MASK\] \[MASK\]" Step 2 (t=0.7): "Solve: 5 \* 3 = ? The \[MASK\] is \[MASK\]" Step 3 (t=0.3): "Solve: 5 \* 3 = ? The answer is 15" Step 4 (t=0.0): "Solve: 5 \* 3 = ? The answer is 15."

Here's one more example:

![Image](https://pbs.twimg.com/media/HCBTZZ9aMAUTf_D?format=jpg&name=large)

## Training

Mercury's training process works like this:

1. **Start with clean data**: Take a target sequence of tokens from our training corpus
2. **Add noise to the data:** We apply forward diffusion - meaning we take those clean sequence and intentionally corrupt them by replacing actual tokens with \[MASK\] Example: "Attention is all you need" -> "\[MASK\] is all \[MASK\] \[MASK\]"
3. **Time-indexed Corruption**: Each training iteration samples a random timestep which controls how much noise to add. High timestep: "\[MASK\] \[MASK\] \[MASK\] \[MASK\] \[MASK\]" Early timestep: "Attention is all \[MASK\] need"
4. **Masking Schedule**: At a given timestep, each token in the sequence has a probability a\_t​ of remaining **unmasked**. This schedule is **strictly decreasing.** As t increases, more tokens get masked
5. **Denoising Training:** We already have the noisy and denoised version! All we need is to train a transformer to input the noisy text at a higher timestep and predict the original (completely clear) text!

> **If you are familiar with BERT, it is pretty much Masked Language Modelling, with an added time dimension.**

## Inference Time

So the model is trained to **predict the original tokens** given the masked sequence. We pretty much call this module in a loop to get back clear text.

1. **Initialization**: Start with a prompt qq (e.g., "What is 2+2?") followed by all \[MASK\] tokens: "What is 2 + 2? \[MASK\] \[MASK\] \[MASK\]"
2. **Iterative Unmasking**: Run multiple denoising steps, progressively revealing tokens: **Step 1** (t close to 1): The model predicts all positions but with low confidence. Some masks are replaced with plausible tokens. **Step 2** (t decreases): Given the partially unmasked sequence, the model refines its predictions. **Step N** (t=0): The sequence is fully denoised — all masks are replaced with final tokens.
3. **Bidirectional Context**: Unlike autoregressive models (which only see left context), masked dLLMs see **both left and right** context during each step, allowing better coherence

> Nov 10, 2025
> 
> Just found the dLLM library to create Diffusion Language Models It's still early but it's insanely fun to experiment with diffusion (training, inference, eval) dLLM has the potential of becoming the main library for diffusion LLMs

This is similar to **BERT-style masked language modeling**, but with a time-varying masking schedule There is one problem.

> **How do you know a-priori how big your output sequence will be? Meaning, how many \[MASK\] tokens should you initialize with?**

Another problem

> **What if the model converts masks to incorrect tokens? Permanently updating tokens randomly like that is making me uncomfortable af.**

Yes. Let's see what recent dLLMs are actually doing.

# More Optimizations

## T2T vs M2T

We talked about **Mask-to-Token** (M2T) so far. But modern dLLMs are doing more than that. **Token-to-Token** (T2T)!

Basically, T2T is a **refinement mechanism** that edits already-generated tokens. Models are generally trained with both M2T and T2T objective.

Instead of treating every reverse diffusion steps as gospel, we can also change the token after they are generated!

At each diffusion timestep, T2T selects a subset of tokens to edit based on confidence scores of the original prediction. These are tokens that the model is most "unsure of" so maybe it's worthwhile to consider editing them. These selected positions are then **re-predicted** by the model and updated if the new prediction has higher confidence:

- The model generates new candidates for tokens at positions in ΔtΔt​
- If the new token has higher confidence than the current one, it **replaces** the old token
- Otherwise, the original token is kept

## Block Diffusion

> Mar 13, 2025
> 
> Block Diffusion Interpolating Between Autoregressive and Diffusion Language Models

Moden dLLMs uses a **block-autoregressive** structure, where generation happens in fixed-size blocks rather than token-by-token:

1. **Fixed Block Size**: The model generates a predetermined number of tokens per block (e.g., 64, 128, or 256 tokens). Each block starts as all \[MASK\] tokens and is iteratively refined through multiple diffusion steps.
2. **Block-Causal Attention**: Each new block can attend to all previously generated blocks (the "prompt block" plus earlier decoded blocks), but tokens within a block see each other during parallel refinement **(bidirectional)**.
3. **Sequential Block Generation**: After one block is finalized, the model generates the next block, and so on, until a stopping condition is met.

> The **block decoding idea** means dLLMs doesn't need to know the exact length upfront—it generates one block at a time and stops when the model signals completion (likely via EOS). It also means that the LLM is hyper focused on a single contiguous blocks while generating and does not need to create the entire universe at once.

If you know about Multi-Token Prediction, this is that but on steroids.

## Multiple Block Editing

![Image](https://pbs.twimg.com/media/HCBQI_AagAANMvC?format=jpg&name=large)

**Multiple Block Editing (MBE)** is a mechanism that allows dLLMs (LLaDA2.1) to **revisit and revise previously generated blocks** based on the content of newly decoded blocks!!!!!! This is basically T2T but with a cooler name.

This is a wayyy different from traditional autoregressive models, which can never go back and fix earlier tokens once they're generated.

Example:

1. **Forward Block Generation**: The model first generates Block 1, then Block 2, Block 3, etc., sequentially. Each block uses **block-causal attention**, meaning Block 2 can see Block 1, Block 3 can see Blocks 1-2, and so on (as explained above).
2. **Backward Revision Trigger**: After generating a new block, the model can **re-evaluate earlier blocks** in light of the new context. If the model realizes that tokens in previous blocks are inconsistent or erroneous given the newly generated content, it can **edit them** using T2T (Token-to-Token).
3. **Cross-Block Consistency**: This iterative cross-block refinement allows the model to maintain **global consistency**. For example:Block 1 might contain an early guess about a variable name in code. After generating Block 3, the model realizes the variable should be named differently.

## Think in Diffusion, Talk in Auto Regression (TiDaR)

Another very cool concept is: what if we used diffusion only for the latent representations in the transformer? And keep the current autoregressive nature while generating the actual tokens.

> Kinda of like how a human would think bidirectionally, continuously adapting and structuring (denoising) their thoughts, but when it's time to speak or write - they are inherently autoregressive. We don't know the future so we simulate it step-by-step. T y p i n g o n e c h a r a c t e r a t a t i m e

![Image](https://pbs.twimg.com/media/HCBS-BNaMAEhF8P?format=jpg&name=large)

The TiDAR paper tries this by combining causal attention with bidirectional attention in a cool way.

- **Causal Attention (Prefix):** For the existing text (prefix), the model uses standard causal masking. This allows it to maintain an **exact KV cache**, just like a normal AR model.
- **Bidirectional Attention (Decoding Block):** For the new tokens being "thought" about, the model uses bidirectional attention. This allows it to look at all the drafted tokens at once, mimicking the behavior of a diffusion model.

Then it optimizes on both the traditional NTP (Next token prediction) loss and the standard M2T (Masked to Token) diffusion loss.

I'm being loosey gooesey here on purpose, the TiDAR paper has a lot of interesting things going on.

## Scaling Diffusion with RL (diffu-GRPO)

After models are trained using SFT with the M2T (or M2T + T2T approach above) on high quality reasoning datasets, they get a basic grasp of how to reason. Like traditional autoregressive LMs, dLLMs can then be RL-ed into oblivion.

Models like d1 uses **diffu-GRPO** which is very similar to how normal GRPO works:

![Image](https://pbs.twimg.com/media/HCBQBWDboAAOEGx?format=jpg&name=large)

1. **Group Generation**: For a single question, the model generates a group of different answers simultaneously.
2. **Relative Scoring**: Each answer is evaluated by an RLVR environment. The scores are scaled relatively to calculate the "group relative advantage"
3. **Optimization**: Model is trained with Policy optimization to increase the likelihood of those responses that lead to higher advantage.

Cool think we can do with diffusion GRPO is that you can also randomly mask certain parts of the input prompt while generating the response. This acts as a data augmentation/regularization trick that makes responses more robust to the input! The d1 also does some hairy mathematics to do log-prob estimation which I won't be getting into in this article.

# What this means?

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2026712368932376576/img/t4AeLpSCMqEtlnbW.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="https://x.com/287cf3ca-ae93-4dff-85a1-782f59d51f10"></video>

![](https://pbs.twimg.com/amplify_video_thumb/2026712368932376576/img/t4AeLpSCMqEtlnbW.jpg?name=large)

- Speed **Generation is super fast coz you are generating entire blocks of text at once in parallel!**
- Bidirectional attention **Models are able to bidirectionally attend to past and future tokens!**
- Ability to edit past tokens **Generated tokens can be changed! dLLMs learn Text-to-Text as well!**
- Iteratively generate revisions of text, not tokens **Diffusion models can do Parallel Drafting over the entire generation sequence by drafting a response from a fully \[MASK\] response to a** **kinda** **working response. Then it can revise it by selectively editing parts of the response as a "denoising step"**

**Thanks for reading.**

You can study these papers on Paper Breakdown if you are on a computer... Visit: [paperbreakdown.com](https://paperbreakdown.com/) If you would like to read more like this, RT or a comment goes a long way! Don't forget to follow me too.