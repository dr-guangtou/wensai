---
title: Agentic AI - How to Train Small Deep Research Agents?
source: "https://x.com/neural_avb/status/2027425381230555354"
author:
  - "[[@neural_avb]]"
tags:
  - clippings
published: 2025-07-08
created: 2026-02-28
description:
---
This is essentially a "survival guide" for training **Deep Research agents** with Small Language Models (SLMs). This article is entirely based on a new research paper that came out earlier this week.

You can find the the paper on Arxiv: [https://arxiv.org/abs/2602.19526](https://arxiv.org/abs/2602.19526)

Basically, they did a study comparing the role of RL-trained research agents across three different dimensions: **Prompt Templates**, **Reward Functions**, and **Policy Optimization.**

All the experiments were performed on really small models in the 3B and 7B param range. Models so small, you can pretty much run them on your computer right now.

They had some pretty interesting findings, and a lot of educational takeaways! Let's get into it.

# 1\. The Problem

> So what are research agents?

![Image](https://pbs.twimg.com/media/HCLZKoHaQAA-4qb?format=jpg&name=large)

Basically, a **Research Agent** is an AI system designed to solve "knowledge-heavy" problems that can't be answered with the model's own world knowledge. Instead, it must use a set of tools to go out, interact with a knowledge base, find new information, and synthesize into a response.

A research agent needs to be:

1. Good at identifying pieces of **information it's missing**
2. Generate **search queries**
3. **Reason** through multiple (often conflicting) sources of information and
4. **Consolidate** into a response.

# 2\. The Experiment

The researchers took existing small models from the **Qwen2.5** family: **Qwen2.5-3B, and Qwen2.5-7B.** These models have basic language skills, but not enough tool-calling skills.

Using **Supervised Finetuning**, they first finetuned these base models on search trajectories from larger models. This teaches them basic tool-calling skills and how to reason through their searches. Once the SFT phase completes, we are ready for the more challenging part - **Reinforcement Learning**. During RL, we increase the likelihood of models picking trajectories that lead to successful searches (we will soon see how!)

Specifically, they explore 3 different axes on which to measure RL training:

1. **Prompt Template: Fast vs. Slow Thinking** Defining how much should LLMs think before picking an action
2. **Reward Function: F1 vs. Exact Match** This dimension explores how to "score" the model's final answer as reward.
3. **Policy Optimization: REINFORCE vs. PPO vs. GRPO** What RL algorithms to use to train these small language models?

We will soon see what their results were, but first let's unpack their environment design.

# 3\. Environment Design

RL requires the environment to be presented as a **sequential decision-making problem**. The agent operates in a multi-round loop where it interacts with a retrieval system with a bunch of tools, before aggregating the final answer.

![Image](https://pbs.twimg.com/media/HCLai2fa0AAH5Ad?format=jpg&name=large)

## 3.1 The Action Space

Agents follow a simple "think-search-rethink-answer" cycle. The environment is controlled by specific XML-style tags that trigger environment actions: (a) **<search> query </search>****:** Triggers the retrieval engine. (b) **<answer> text </answer>****:** Ends the episode and submits the final result. (c) **<think> ... </think>****:** Internal reasoning (used in the "Slow Thinking" setup mentioned next)

## 3.2 Reasoning

They experiment with how training is impacted by how the agent reasons. **Slow Thinking Template:** The model is forced to use <think> tags before every search and answer. This is the traditional way models like **DeepSeek-R1** work.

**Fast Thinking Template:** The model goes STRAIGHT to the action (searching or answering) without mandatory, long-form thinking blocks

> Note that fast thinking is NOT equivalent to no thinking. The model can still generate some monologue before outputting the <search> or <answer> tags. Fast thinking just means no EXPLICIT <think> tags, and no explicit mention of reasoning in these prompts.

![Image](https://pbs.twimg.com/media/HCLaAV5bEAAOM8u?format=jpg&name=large)

## 3.3 The Search Engine

They used a **Wikipedia snapshot from 2018.** They used this static knowledge base (instead of direct web search) to maintain reproducibility. Basically, when the agent generates a <search> tag, the system retrieves the **top-3 most relevant passages** from Wikipedia and injects them back into the model's context between <information> and </information> tags. The model reads it and performs the next step.

3\. **Episode:** For training research agents, we also need search prompts and their corresponding correct answers. Wikipedia is just the knowledge base, it does not contain what to search or how to verify answers.

They combined **NQ (Natural Questions)** and **HotpotQA** (a multi-hop reasoning dataset) datasets to generate each episode.

An episode therefore contains the below steps:

- Sample a question from the dataset
- Let the LLM use the think, search, and answer tools to browse Wikipedia to get answers
- Verify if the final answer was correct.

The final step is to give a reward to the agent based on it's answer.

![Image](https://pbs.twimg.com/media/HCLateqa4AAiBz2?format=jpg&name=large)

## 3.4 Reward

The most basic way to train an RL agent is to give it a reward only at the very end based on its final answer. They try 2 approaches:

- **EM (Exact Match):** A "hard" binary reward. If the answer is 2017, and the model says 2017, it gets 1 point. If it says "the year 2017," it gets 0. :( **Effect:** This forces the model to be very precise and concise. BUT The reward space gets sparser.
- **F1 Score:** This is a "soft" reward. It gives partial credit based on how many words in the model's answer overlap with the correct answer. **The Problem:** Model gets some rewards even if the responses are partially correct, or missing important keywords

With a higher budget, people could (should have) also use LLM as a judge methods to evaluate answers. Basically you pass the generated answer and the expected answer to an LLM, and it generates a numerical reward.

## 3.5 Training algorithm

They tested with 3 popular RL algorithms for reasoning research - REINFORCE, GRPO, and PPO. Next section has all the details about their findings. (To the surprise of nobody who has been paying attention to SLM reasoning research - REINFORCE won)

# 4\. Some Takeaways from the Paper

Remember that these conclusions were drawn with 3B and 7B models. Their goal was to train Small Research Agents - so some of these results will not translate to larger models!

![Image](https://pbs.twimg.com/media/HCLZXv2aEAARXQg?format=jpg&name=large)

4.1 **"The Less Thinking, the Better"** Surprisingly, the popular "Slow Thinking" approach (where you force the model to write out its thoughts in a <think> block before acting) actually **hurts** performance in deep research for SLMs.

![Image](https://pbs.twimg.com/media/HCLaJK9bsAAJsob?format=jpg&name=large)

- **The Problem:** In multi-round searches, "Slow Thinking" often leads to **training collapse** where the model starts generating empty thinking blocks or gets stuck in loops! Better SFT or bigger models could solve this, but it increasing training costs.
- **The Fix:** They found that **Fast Thinking**—where the model goes straight to a search action or an answer—is much more stable and achieves higher accuracy across benchmarks.

4.2 **Answer Avoidance in F1 Scoring**

Most RL training uses **Exact Match (EM)** or **F1 scores** as rewards.

> They found that optimizing for F1 led to way more unstable training then F1

Specifically they discovered that F1 objectives lead to **training collapse**. Basically, the agent learns to "cheat" by refusing to answer. It realizes that if it doesn't give an answer, it isn't "wrong," so it avoids the risk of a low F1 score.

**The Solution (F1+):** They introduced **Action Supervision**, and created a new reward function called **F1+**. Basically, they added auxilliary penalties:

- If the model refuses to answer, it gets a penalty
- If the model repeats a query exactly, it gets a penalty
- If a search returns no new information, it gets a penalty.

![Image](https://pbs.twimg.com/media/HCLZiEDa0AEX9tz?format=jpg&name=large)

F1 vs EM vs F1+

By adding penalties for "refusal" (not answering) and for "over-searching" (wasting too many search steps), they revitalized F1 rewards. This new **F1+** reward eventually outperformed simple Exact Match (EM).

4.3 **REINFORCE Beats PPO and GRPO!** (many have been saying it too!)

> Jul 8, 2025
> 
> REINFORCE is coming back in a big way

In many modern LLM projects (like DeepSeek-R1), algorithms like **GRPO** are the stars. But for Deep Research:

- **GRPO is the least stable**
- **PPO vs GRPO:** PPO outperforms GRPO on Single-Hop tasks, while GRPO exhibits superior capability on Multi-Hop benchmarks
- **REINFORCE is King:** It proved to be the most stable and achieved the highest accuracy. It also learnt the most compact policies - fewest searches on average to get to answers.

![Image](https://pbs.twimg.com/media/HCLZ1meaAAAVOe5?format=jpg&name=large)

- **Why?** Basically, REINFORCE by design just tries to make an unbiased estimator strictly based on the rollout trajectories, i.e. no critic, no advantages. It purely learns from generated rewards. This traditionally causes high variance in RL environments and longer training times, but it actually outweighs the cons of PPO and GRPO, esp for this small LM multi-step environment. PPO and GRPO introduce auxiliary mechanisms to reduce variance, with PPO utilizing a critic model and GRPO employing group averaging. To directly quote the paper:

> In multi-step, long-context reasoning, the high variance of actions within a group makes the baseline noisy, leading to training instability. .... In scenarios with sparse outcome rewards (EM), fitting an accurate value function over long trajectories is challenging. This difficulty often leads to critic bias that fails to penalize redundant searches, explaining PPO’s high and unadaptive search cost. REINFORCE, by contrast, optimizes the policy based on the direct cumulative return without relying on external baseline. By avoiding the noise from group sampling and the bias from critic estimation...

# 5\. The Recipe

By combining the three insights above - **Fast Thinking,** **F1+ Reward,** **REINFORCE**—they created a new baseline called **Search-R1++**.

Read the paper for more details and benchmarks! It also contains prompts and detailed trajectory examples!

It remains to be seen how much these results translate to larger benchmarks and larger model training in the (70B - 400B+) range!

**Follow me for more breakdown**: [@neural\_avb](https://x.com/@neural_avb)

Read this paper with an LLM assistant for free (if you on a computer): [https://paperbreakdown.com/abs/2602.19526](https://paperbreakdown.com/abs/2602.19526)

A bit of kindness goes a long way, appreciate an RT or a comment to support!💙