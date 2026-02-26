---
title: "Language Model RL Optimization Methods - Summary"
date: 2026-02-26
topic: "Reinforcement Learning for LLMs"
category: "AI/ML Research"
tags: ["rl", "optimization", "llm", "ppo", "dpo", "grpo", "astronomy-applications"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Language Model RL Optimization Methods - Summary

**Research Date:** 2026-02-26  
**Investigation Topic:** RL Algorithms for Language Model Training  
**Focus Areas:** Motivation, Pros/Cons, Astronomy Applications

---

## Overview

These algorithms form the core of **Reinforcement Learning from Human Feedback (RLHF)** — the process of training language models to produce outputs that align with human preferences.

**Evolution Timeline:**
```
REINFORCE (1992) → PPO (2017) → GRPO (2024) → DPO (2023)
     │                  │              │            │
   Basic RL        Stabilized      Group-based   No reward model
   for ML          for LLMs        efficient     direct optimization
```

---

## 1. Policy Gradient / REINFORCE

### What It Is
The foundational algorithm for training policies (models that make decisions) using gradient descent on expected rewards.

### Motivation
Traditional supervised learning minimizes a fixed loss. But for sequential decision-making or generation, we need to optimize **expected future rewards** — not just match labels.

### How It Works (Conceptually)
```
1. Generate output from model
2. Get reward (how good was it?)
3. Increase probability of actions that led to high reward
4. Decrease probability of actions that led to low reward
```

### Pros
- ✅ Simple, foundational
- ✅ Works for any differentiable policy
- ✅ No need for value function

### Cons
- ❌ **High variance** — gradients are noisy
- ❌ Sample inefficient — needs many rollouts
- ❌ Unstable training

### Astronomy Application
**Model fitting with non-differentiable objectives**: If your likelihood function has non-differentiable components (e.g., detection thresholds), policy gradient can optimize it directly.

---

## 2. REINFORCE Leave-One-Out (RLOO)

### What It Is
A variance-reduced variant of REINFORCE that uses "leave one out" baseline estimation.

### Motivation
REINFORCE's high variance comes from noisy reward signals. RLOO reduces variance by using other samples as baselines.

### How It Works
```
Instead of: score = reward - baseline
Use: score = reward - mean(rewards of other samples in group)
```

### Pros
- ✅ Lower variance than vanilla REINFORCE
- ✅ No separate value function needed
- ✅ Simple to implement

### Cons
- ⚠️ Still higher variance than PPO/GRPO
- ⚠️ Requires multiple samples per prompt

### Astronomy Application
**Efficient survey optimization**: When optimizing telescope pointing strategies, use leave-one-out to reduce variance in coverage estimates.

---

## 3. Proximal Policy Optimization (PPO)

### What It Is
The most widely-used RL algorithm for LLMs (used by OpenAI, Anthropic). Prevents the policy from changing too drastically in one step.

### Motivation
REINFORCE is unstable — the policy can collapse or oscillate. PPO adds a "trust region" to keep updates small and safe.

### How It Works
```
1. Calculate probability ratio: r = new_prob / old_prob
2. If r is too far from 1 (e.g., > 1.2 or < 0.8), clip it
3. Only update within this safe range
```

### Pros
- ✅ **Stable** — won't destroy learned knowledge
- ✅ Sample efficient
- ✅ Easy to tune (fewer hyperparameters)
- ✅ Industry standard

### Cons
- ⚠️ Still needs a reward model
- ⚠️ Requires careful clipping threshold
- ⚠️ Can be conservative (slow learning)

### Astronomy Application
**Adaptive optics tuning**: Continuously adjust mirror shapes based on seeing conditions, with PPO ensuring stable convergence without catastrophic corrections.

---

## 4. Group Relative Policy Optimization (GRPO)

### What It Is
An efficient variant that compares outputs **within a group** rather than against a separate reward model. Used by DeepSeek, Qwen.

### Motivation
PPO requires training and maintaining a separate reward model. GRPO eliminates this by using group comparisons.

### How It Works
```
1. Generate K outputs for same prompt
2. Rank them (or use human preferences)
3. Optimize relative to group performance
4. No separate reward model needed
```

### Pros
- ✅ **No reward model** — simpler pipeline
- ✅ More sample efficient than PPO
- ✅ Works well with preference data
- ✅ Used successfully by DeepSeek, Qwen

### Cons
- ⚠️ Requires multiple generations per prompt
- ⚠️ Less absolute signal (only relative)
- ⚠️ Newer, less battle-tested

### Astronomy Application
**Galaxy classification refinement**: Generate multiple classification hypotheses, compare within groups using expert labels, optimize for consensus with ground truth.

---

## 5. Group Sequence Policy Optimization (GSPO)

### What It Is
An extension of GRPO that optimizes over sequences, accounting for token-level decisions.

### Motivation
GRPO treats outputs as atomic units. GSPO considers the sequential nature of generation, optimizing each step.

### Pros
- ✅ More fine-grained than GRPO
- ✅ Better credit assignment

### Cons
- ⚠️ More complex implementation
- ⚠️ Higher computational cost

### Astronomy Application
**Spectral line fitting**: Optimize parameter sequences for fitting spectral features, where each step affects subsequent decisions.

---

## 6. Clipped Importance Sampling Policy Optimization (CISPO)

### What It Is
A variant using importance sampling with clipping for off-policy learning.

### Motivation
PPO is on-policy (needs fresh samples). CISPO enables reusing old samples via importance sampling while maintaining stability.

### How It Works
```
1. Store old policy samples
2. Weight by importance ratio: p(new)/p(old)
3. Clip extreme weights to prevent instability
4. Reuse samples for efficiency
```

### Pros
- ✅ **Sample efficient** — reuse old data
- ✅ Off-policy learning
- ✅ Good for limited data scenarios

### Cons
- ⚠️ Importance weights can be unstable
- ⚠️ Requires careful clipping
- ⚠️ May accumulate bias

### Astronomy Application
**Rare transient detection**: When positive examples (real transients) are rare, reuse historical observations with importance weighting to improve detection models.

---

## 7. RLHF Objective

### What It Is
The overall training objective for RLHF: maximize reward while staying close to the original model.

### Motivation
Pure reward maximization leads to "reward hacking" — the model finds loopholes. RLHF objective adds a KL penalty to prevent drift.

### How It Works
```
Objective = Expected_Reward - β × KL_Divergence

Where:
- Expected_Reward: How much humans like the output
- KL_Divergence: How different from original model
- β: Trade-off parameter
```

### Pros
- ✅ Prevents reward hacking
- ✅ Keeps model grounded
- ✅ Controllable trade-off

### Cons
- ⚠️ Choosing β is difficult
- ⚠️ May limit capability
- ⚠️ Requires reward model

### Astronomy Application
**Catalog generation**: Generate synthetic galaxy catalogs that match observations while staying physically plausible (not drifting to unrealistic distributions).

---

## 8. Bradley-Terry Reward Model

### What It Is
A statistical model for converting pairwise preferences into scalar rewards.

### Motivation
Humans are better at saying "A is better than B" than giving absolute scores. Bradley-Terry converts comparisons to rewards.

### How It Works
```
P(A > B) = exp(reward_A) / (exp(reward_A) + exp(reward_B))

Given comparisons, solve for rewards that maximize likelihood
```

### Pros
- ✅ Works with natural human feedback
- ✅ Mathematically principled
- ✅ Standard approach in RLHF

### Cons
- ⚠️ Requires many comparisons
- ⚠️ Assumes transitivity (if A>B and B>C, then A>C)
- ⚠️ May not capture nuanced preferences

### Astronomy Application
**Expert ranking of galaxy morphologies**: Astronomers compare pairs of morphological classifications, convert to quality scores for training automated classifiers.

---

## 9. Direct Preference Optimization (DPO)

### What It Is
A breakthrough method that **eliminates the RL loop entirely** — directly optimize from preferences without a reward model.

### Motivation
RLHF is complex: train reward model → train policy with PPO → iterate. DPO skips the reward model and RL, going directly from preferences to policy.

### How It Works
```
Traditional RLHF:
Preferences → Reward Model → RL (PPO) → Policy

DPO:
Preferences → Direct Optimization → Policy
```

### Pros
- ✅ **Much simpler** — no RL loop
- ✅ No reward model needed
- ✅ Stable training
- ✅ Faster and cheaper
- ✅ Works surprisingly well

### Cons
- ⚠️ May not scale to complex reward landscapes
- ⚠️ Requires good preference data
- ⚠️ Less flexible than full RLHF

### Astronomy Application
**Spectral template matching**: Given expert preferences for which templates match observations better, directly optimize the matching model without building an intermediate reward model.

---

## Comparison Summary

| Algorithm | Reward Model? | Complexity | Stability | Sample Efficiency |
|-----------|---------------|------------|-----------|-------------------|
| **REINFORCE** | No | Low | Low | Low |
| **RLOO** | No | Low | Medium | Medium |
| **PPO** | Yes | Medium | High | Medium |
| **GRPO** | No | Medium | High | High |
| **DPO** | No | Low | High | High |
| **CISPO** | No (off-policy) | Medium | Medium | Very High |

---

## Astronomy Applications Summary

### Where These Methods Could Apply

| Problem | Recommended Method | Why |
|---------|-------------------|-----|
| **Adaptive optics control** | PPO | Stable, continuous optimization |
| **Survey strategy optimization** | GRPO | Group-based comparisons of strategies |
| **Galaxy classification** | DPO | Direct expert preference learning |
| **Rare transient detection** | CISPO | Sample-efficient, reuse rare events |
| **Spectral fitting** | GSPO | Sequential parameter optimization |
| **Catalog generation** | RLHF Objective | Balance realism with coverage |
| **Expert annotation** | Bradley-Terry | Convert comparisons to scores |

### Key Considerations for Astronomy

1. **Sample Efficiency**: Astronomical data is expensive — GRPO, DPO preferred
2. **Stability**: Don't want to break working pipelines — PPO, DPO preferred
3. **Expert Integration**: Astronomers can provide preferences — Bradley-Terry + DPO
4. **Physical Constraints**: Must stay physically plausible — RLHF objective with KL penalty

---

## Resources

### Papers
- **REINFORCE**: Williams, 1992
- **PPO**: Schulman et al., 2017
- **DPO**: Rafailov et al., 2023
- **GRPO**: DeepSeek Team, 2024

### Tutorials
- OpenAI Spinning Up: https://spinningup.openai.com/
- HuggingFace RLHF docs: https://huggingface.co/docs/trl/

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-26*
