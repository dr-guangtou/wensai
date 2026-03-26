---
title: "Neural Thickets: Diverse Task Experts Are Dense Around Pretrained Weights"
authors:
  - Anonymous authors
affiliations:
  - MIT and other institutions
source: arXiv:2603.12228v1
date_published: 2026-03-17
date_read: 2026-03-14
type: paper_summary
category: ai
venue: Preprint (Deep Learning, Optimization)
tags:
  - neural-thickets
  - random-search
  - post-training
  - ensembling
  - llm-optimization
  - weight-perturbation
---

# Neural Thickets: Random Guessing Works for Large LLMs

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Neural Thickets: Diverse Task Experts Are Dense Around Pretrained Weights |
| **arXiv ID** | 2603.12228v1 |
| **Code** | github.com/sunrainyg/RandOpt |
| **Project page** | thickets.mit.edu |
| **Type** | Discovery + Methods |

---

## The Shocking Claim

> **Adding random Gaussian noise to pretrained LLM weights — one step, no gradients, no learning rate — then ensembling the results, can match or beat GRPO/PPO on reasoning tasks.**

This seems impossible. Random guessing as a learning algorithm?

---

## The Core Concept: Neural Thickets

### The Two Regimes

**Small models: "Needle in a Haystack"**

```
         Weight Space
    ┌─────────────────────────┐
    │                         │
    │      🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾 │
    │      🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾 │
    │      🌾🌾🌾📍🌾🌾🌾🌾🌾🌾 │  ← One good solution, hard to find
    │      🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾 │
    │      🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾 │
    │                         │
    └─────────────────────────┘

Random guessing almost never finds the needle.
You need gradient descent to navigate there.
```

**Large pretrained models: "Neural Thicket"**

```
         Weight Space
    ┌─────────────────────────┐
    │  🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 │
    │  🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 │
    │  🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 │  ← Good solutions everywhere!
    │  🌳🌳🌳🌳📍🌳🌳🌳🌳🌳🌳 │  ← Pretrained weights in the middle
    │  🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 │
    │  🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 │
    └─────────────────────────┘

Random perturbations land on good solutions frequently.
Each tree is a different "specialist."
```

### What the Paper Discovers

| Finding | What It Means |
|---------|---------------|
| **Solution density increases with scale** | Larger models have more good solutions nearby |
| **Solutions are specialists, not generalists** | Each perturbation excels at different tasks |
| **Diversity also scales** | Larger models have more diverse specialists |
| **Random guessing works** | No gradients needed for large pretrained models |

---

## The Two Key Measurements

### 1. Solution Density (How Many Good Solutions?)

**Definition:** What fraction of random perturbations improve performance?

$$\delta(m) = \mathbb{P}_{\epsilon \sim \mathcal{N}(0, \sigma^2 I)}[s(\theta + \epsilon) \geq s(\theta) + m]$$

**In plain English:** "If I add random noise to the weights, what's the chance I get a model that's at least m% better?"

**Key finding:**

| Model Size | Density of +5% Improvers |
|------------|-------------------------|
| 0.5B | ~0.1% |
| 3B | ~1% |
| 7B | ~3% |
| 32B | ~8% |

**The scaling law:** Solution density increases monotonically with model size.

### 2. Spectral Discordance (How Diverse Are They?)

**The question:** Are the perturbations "generalists" (good at everything) or "specialists" (good at specific things)?

**Method:** Correlate performance across tasks. If seeds that are good at math are also good at chemistry → generalists. If they're uncorrelated → specialists.

**Key finding:**

| Model Size | Spectral Discordance (0=generalist, 1=specialist) |
|------------|--------------------------------------------------|
| 0.5B | ~0.3 |
| 3B | ~0.5 |
| 7B | ~0.6 |
| 32B | ~0.7 |

**The pattern:** Larger models → more specialization.

---

## Visualizing the Thicket

The paper shows "accuracy landscapes" — 2D projections of the weight space:

```
Small Model (0.5B):              Large Model (32B):
┌─────────────────┐             ┌─────────────────┐
│ 🔵🔵🔵🔵🔵🔵🔵🔵 │             │ 🔴🔴🔴🔴🔴🔴🔴🔴 │
│ 🔵🔵🔵🔵🔵🔵🔵🔵 │             │ 🔴🔴🔴🔴🔴🔴🔴🔴 │
│ 🔵🔵📍🔵🔵🔵🔵🔵 │             │ 🔴🔴🔴📍🔴🔴🔴🔴 │
│ 🔵🔵🔵🔵🔵🔵🔵🔵 │             │ 🔴🔴🔴🔴🔴🔴🔴🔴 │
│ 🔵🔵🔵🔵🔵🔵🔵🔵 │             │ 🔴🔴🔴🔴🔴🔴🔴🔴 │
└─────────────────┘             └─────────────────┘
  Mostly cold (low accuracy)      Mostly warm (high accuracy)
  One narrow peak                 Many peaks everywhere
```

**Blue = worse than base, White = same, Red = better**

---

## The RandOpt Algorithm

### How It Works (It's Absurdly Simple)

```
Algorithm: RandOpt

1. SAMPLE: Generate N random weight perturbations
   θ_i = θ + σ * ε_i    where ε_i ~ N(0, I)

2. EVALUATE: Test each on a small validation set
   v_i = evaluate(θ_i, D_train)

3. SELECT: Keep the top K performers
   I_top = top-K indices by v_i

4. ENSEMBLE: For new inputs, vote among top K
   ŷ = majority_vote({f_{θ_i}(x) for i in I_top})
```

**That's it.** No gradients. No learning rate. No sequential updates. Just:
1. Add noise
2. Check which noises helped
3. Ensemble the winners

### Why Ensembling is Crucial

| K (ensemble size) | Performance |
|-------------------|-------------|
| 1 | Modest improvement |
| 10 | Better |
| 50 | Competitive with PPO/GRPO |

**The insight:** Since perturbations are specialists, you need multiple perspectives to cover all aspects of the task.

---

## Results: RandOpt vs. The Heavy Hitters

### Comparison Setup

All methods given **equal training FLOPs**:
- RandOpt: N=5000 samples, K=50 ensemble
- PPO/GRPO: Hundreds of gradient steps
- Evolution Strategies (ES): Iterative population search

### Key Results

| Model | Task | Base | PPO | GRPO | ES | RandOpt |
|-------|------|------|-----|------|-----|---------|
| Qwen-2.5-7B | Countdown | 52% | 65% | 68% | 70% | **72%** |
| Qwen-2.5-7B | GSM8K | 78% | 82% | 84% | 85% | **86%** |
| OLMo3-7B | Math | 41% | 55% | 58% | 60% | **62%** |
| Qwen-VL-3B | GQA | 57% | — | — | — | **69%** |

**Takeaway:** RandOpt matches or exceeds methods that require complex gradient-based optimization.

### The Wall-Clock Advantage

| Method | Training Time | Sequential Steps |
|--------|---------------|------------------|
| PPO/GRPO | O(T) steps | Hundreds of updates |
| ES | O(T) iterations | Iterative refinement |
| **RandOpt** | **O(1)** | **Zero sequential steps** |

**Example:** On a 200 GH200 cluster, RandOpt trains OLMo-3-7B on Countdown in **3.2 minutes**.

---

## The Minimal Example: Why Do Thickets Form?

The paper creates a toy model to understand the phenomenon:

### The Experiment

1. **Pretrain** a model on a mixture of 1D signal types: sinusoidal, linear, harmonic, sigmoidal, sawtooth, square waves
2. **Perturb** the weights with random noise
3. **Test** on a held-out linear signal

### Three Regimes

| Pretraining | Result | Why |
|-------------|--------|-----|
| **None** (random init) | Needle-in-haystack | No structure learned, solutions far away |
| **Mixed signals** | **Thicket** | Learned many patterns, perturbations explore them |
| **Linear only** | Plateau | Already optimal on linear, nothing to gain |

**The insight:** Thickets emerge when pretraining covers **diverse patterns**. The pretrained weights become a "hub" with paths to many specialist solutions.

---

## What This Means

### 1. For Training Philosophy

**Old view:** Post-training is about "searching" for the right parameters
- Requires careful optimization
- Easy to get stuck in local minima
- Needs sophisticated algorithms

**New view:** Post-training is about "finding and combining" nearby specialists
- Search is easy (random sampling works)
- Challenge is selecting and ensembling
- Simple algorithms suffice

### 2. For Model Scaling

**Implication:** As models get larger, they don't just get better — they get **easier to improve**.

The thicket regime means:
- More good solutions nearby
- More diverse capabilities
- Simpler optimization suffices

### 3. For Practical Deployment

| Traditional RL (PPO/GRPO) | RandOpt |
|---------------------------|---------|
| Sequential updates | Fully parallel |
| Hyperparameter-sensitive | Fewer knobs |
| Complex infrastructure | Simple sampling |
| O(T) wall-clock time | O(1) wall-clock time |

**Trade-off:** RandOpt requires K× inference cost (ensembling)

---

## The Three Regimes of Post-Training

```
Model Size / Pretraining Quality
         │
         │
    Large│          ┌─────────────────────────────┐
         │          │      THICKET REGIME         │
         │          │                             │
         │          │  • Dense good solutions     │
         │          │  • Diverse specialists      │
         │          │  • Random guessing works    │
         │          │  • Ensembling is powerful   │
         │          └─────────────────────────────┘
         │
  Medium │          ┌─────────────────────────────┐
         │          │    TRANSITION ZONE          │
         │          │                             │
         │          │  • Some nearby solutions    │
         │          │  • Structured search helps  │
         │          └─────────────────────────────┘
         │
   Small │          ┌─────────────────────────────┐
         │          │   NEEDLE IN HAYSTACK        │
         │          │                             │
         │          │  • Rare good solutions      │
         │          │  • Gradient descent needed  │
         │          │  • Random guessing fails    │
         │          └─────────────────────────────┘
         │
         └──────────────────────────────────────────
```

---

## Open Questions

| Question | Status |
|----------|--------|
| Why do thickets form? | Partially explained by diverse pretraining |
| Does this apply to all tasks? | Tested on math, code, writing, chemistry |
| Does this scale to 100B+ models? | Tested up to 32B |
| Can we reduce ensemble cost? | Distillation shows promise |
| Is this just fixing format issues? | Partial, but not fully (see paper analysis) |

---

## Summary: The Key Insights

### 1. The Discovery

> Large pretrained models are surrounded by a **"thicket" of task-specific experts** — random weight perturbations frequently land on models that improve specific tasks.

### 2. The Scaling

> Both **solution density** and **diversity** scale with model size. Larger models have more good solutions nearby, and those solutions are more diverse.

### 3. The Algorithm

> **RandOpt:** Sample random perturbations, evaluate them, ensemble the top K. This matches PPO/GRPO without gradients, learning rates, or sequential optimization.

### 4. The Implication

> Post-training becomes **easy** once you have a strong pretrained representation. The challenge shifts from "how to search" to "how to select and combine."

---

## Citation

```bibtex
@article{anonymous2026thickets,
  title={Neural Thickets: Diverse Task Experts Are Dense Around Pretrained Weights},
  journal={arXiv preprint arXiv:2603.12228},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> Large pretrained models live in a "thicket" of good solutions. Random Gaussian perturbations can find diverse task experts, and ensembling them matches sophisticated RL methods. This doesn't work for small models — it's a property of scale.

**What surprised me:**
- Random guessing (no gradients!) works for 7B+ models
- The density of good solutions scales with model size
- Each perturbation is a specialist, not a generalist
- Ensembling is crucial — K=1 doesn't work well

**Physics analogy:** This reminds me of energy landscapes in statistical physics:
- Small models: Deep, narrow valleys → hard to escape
- Large models: Wide basins with many local minima → easy to find good solutions

**Questions to explore:**
- [ ] Does this apply to scientific foundation models?
- [ ] Could this simplify fine-tuning for astronomy tasks?
- [ ] What's the minimal model size for thickets to emerge?
- [ ] Is there an analogy in traditional optimization (convexity at scale)?

**The big picture:** This suggests that as AI scales, optimization becomes easier — a surprising and hopeful finding. The "hard work" of pretraining creates a landscape where improvement is trivial.
