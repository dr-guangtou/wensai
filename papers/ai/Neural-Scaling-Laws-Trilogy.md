---
title: "Neural Scaling Laws Trilogy: Representation, Transformation, and Training"
authors:
  - Yizhou Liu
source: Blog post draft (liuyz0.github.io/blog/2026/NSLT/)
tags:
  - paper
  - ai/llm
  - ai/deep-learning
affiliations:
  - MIT
date_published: 2026
date_read: 2026-03-01
type: paper_summary
category: ai
venue: Blog post (based on 3 academic papers)
---
# Neural Scaling Laws Trilogy

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Neural Scaling Laws Trilogy: Representation, Transformation, and Training |
| **Author** | Yizhou Liu (MIT) |
| **Type** | Blog post / Theory synthesis |
| **Based on** | Three academic papers by the author |
| **PDF** | Available at liuyz0.github.io |

---

## What Are "Scaling Laws"? (Start Here if You're New)

### The Basic Observation

In 2020, OpenAI discovered something remarkable: **bigger AI models perform better in a predictable way.**

If you plot model performance (measured as "loss"—lower is better) against model size on a log-log plot, you get a **straight line**.

```
Loss
  │
  │ \
  │  \
  │   \    ← This is a "power law"
  │    \
  │     \
  │      \
  └─────────── Model Size (log scale)
```

**A power law** means: if you double the model size, the loss decreases by a predictable factor. Mathematically:

$$\text{Loss} \propto \frac{1}{N^{\alpha}}$$

where $N$ is model size and $\alpha$ is some exponent (about 0.34 in practice).

### Why This Matters

1. **Predictability:** You can predict how good a model will be before training it—just extrapolate the line
2. **GPT-4 used this:** They trained small models, fit the curve, and predicted GPT-4's performance before training it
3. **It's why LLMs are "large":** The laws say "bigger = better," so companies keep scaling up

### The Mystery

The power law behavior is **empirical**—it's observed in data, but we don't know **why** it happens.

- Why power laws specifically?
- Why exponent ~0.34 for model size?
- Why exponent ~0.28 for dataset size?
- Will it continue forever or break down?

**This blog post tries to answer these questions from first principles.**

---

## The Analogy: Pyramids vs. Rockets

The author uses a beautiful analogy:

> Ancient Egyptians could build taller and taller pyramids by understanding basic geometry (volume vs. height). But **scaling up pyramids cannot reach the moon.**

> To reach the moon, you need to understand **gravity**—the fundamental principle. Then you can build something completely different: rockets.

**The point:** Understanding WHY scaling laws work might let us build something fundamentally better than just "bigger models."

---

## The Chinchilla Scaling Laws

Before the author's theory, we had the **Chinchilla laws** (2022), which say:

$$L = \frac{c_N}{N^{\alpha_N}} + \frac{c_D}{D^{\alpha_D}} + L_0$$

Where:
- $N$ = number of parameters (model size)
- $D$ = dataset size (number of training tokens)
- $L_0$ = irreducible loss (can't go below this)
- $\alpha_N \approx 0.34$, $\alpha_D \approx 0.28$ (measured exponents)

**This formula works empirically, but doesn't explain WHY these exponents exist.**

---

## The Author's Theory: Three Sources of Loss

The author proposes that loss comes from **three independent sources**, each with its own power law:

### 1. Representation Loss (Width)

**The problem:** LLMs need to represent many "features" (concepts, ideas, relationships), but have limited width (embedding dimension).

**What happens:** Features get **superimposed**—the model packs more features than dimensions, like trying to fit 1000 people in a 100-seat room.

**The consequence:** Features "interfere" with each other geometrically, causing errors.

**The scaling:** Loss from representation ~ $\frac{1}{m}$ where $m$ = width

**Analogy:** Like trying to broadcast many radio stations on limited frequencies—there's interference.

### 2. Transformation Loss (Depth)

**The problem:** LLMs need to transform representations through multiple layers to compute things.

**What the author found:** Analyzing actual LLMs, layers don't work "compositionally" (layer 1 does A, layer 2 does B, etc.). Instead, **each layer makes small incremental updates**, and they "average out" errors together.

**The scaling:** Loss from transformation ~ $\frac{1}{\ell}$ where $\ell$ = depth (number of layers)

**Analogy:** Like a committee voting—more members means the average opinion is more stable (central limit theorem).

### 3. Training Loss (Time/Data)

**The problem:** Training is imperfect—we can't train forever.

**The key insight:** The power law comes from **softmax + cross-entropy** (the output layer of LLMs), NOT from the data distribution.

When predicting the next token:
- The model outputs a probability distribution over ~50,000 possible tokens
- But only a few tokens are actually likely (low entropy distribution)
- To output confident predictions, the model needs **large logits** (big numbers)
- Large logits → gradients become very small → learning slows down as a **power law**

**The scaling:** Loss from training ~ $\frac{1}{\tau^{1/3}}$ where $\tau$ = training time (≈ dataset size for single-pass training)

**Connection to physics:** This is like "universality" in statistical physics—certain systems converge to power-law behavior regardless of details.

---

## The Complete Formula

Putting it all together:

$$L = \frac{c_m}{m} + \frac{c_\ell}{\ell} + \frac{c_\tau}{\tau^{1/3}} + L_0$$

Where:
- $m$ = width (embedding dimension)
- $\ell$ = depth (number of layers)
- $\tau$ = training time (≈ dataset size)
- $L_0$ = irreducible loss

### How This Relates to Chinchilla

Model size $N \approx 12 m^2 \ell$ (standard Transformer parameter count)

At optimal shape (balancing width and depth), we get:

$$L = \frac{c_N}{N^{1/3}} + \frac{c_D}{D^{1/3}} + L_0$$

**This explains why $\alpha_N \approx 0.34$ and $\alpha_D \approx 0.28$—they're both close to 1/3!**

### At Compute-Optimal Frontier

Compute $C \approx 6 N D$ (total training cost)

Optimal strategy: balance $N$ and $D$ equally, so $N \propto D$

This gives:

$$L = \frac{c_C}{C^{1/6}} + L_0$$

---

## Comparison Table: Linear Models vs. LLMs

| Aspect | Linear Models (MSE) | LLMs (Softmax + Cross-Entropy) |
|--------|---------------------|-------------------------------|
| **Power law source** | Data distribution | Architecture (softmax) |
| **Features** | Learn N features with N parameters | Superposition: more features than parameters |
| **Convergence** | Exponential per feature | Power law overall |
| **Analogy** | Basket holding solid bricks | Bottle compressing gases |

**Key insight:** For linear models, power laws come from the DATA (power-law distribution of feature importance). For LLMs, power laws come from the ARCHITECTURE (softmax + low-entropy outputs).

---

## Experimental Validation

The author fitted their formula to Chinchilla data:

| Exponent | Predicted | Fitted | Chinchilla Measured |
|----------|-----------|--------|---------------------|
| $\alpha_m$ (width) | 1 | 0.98 ± 0.08 | — |
| $\alpha_\ell$ (depth) | 1 | 1.2 ± 0.3 | — |
| $\alpha_D$ (dataset) | 1/3 | 0.30 ± 0.01 | 0.28 |
| $\alpha_N$ (parameters) | 1/3 | — | 0.34 |

**The predictions match well!**

---

## Key Implications

### 1. We're NOT Running Out of Data

**Common worry:** "We'll run out of internet text to train on!"

**Author's view:** The scaling is with TRAINING STEPS, not unique data. As long as you can estimate gradients well (need quality and diversity, not just volume), you can keep training on the same data.

**What matters:**
- Data quality
- Data diversity
- Number of training steps

**Not what matters:**
- Total amount of unique data (beyond a certain threshold)

### 2. Shape DOES Matter (But Only Near the Edges)

Previous studies said "shape doesn't matter"—width vs. depth trade-off has minor impact.

**Author's clarification:** Near the optimal shape ($m/\ell \approx 70$), the loss is robust. But extreme shapes hurt. The theory clarifies WHEN shape matters.

### 3. The Bottleneck is Architecture, Not Data

Power laws come from:
- Superposition (representation) → fundamental
- Ensemble averaging (transformation) → inefficient but robust
- Softmax universality (training) → fundamental for current architecture

**Future improvements should focus on architecture, not just more data.**

---

## Future Predictions: How to Beat Current Scaling

The author proposes two architectural improvements:

### Improvement 1: Compositional Layers

Current: Layers average errors → loss ~ $1/\ell$

Better: Layers compose functions → loss could decrease exponentially with depth

**How:** Early exit, where early layers handle easy cases, later layers handle hard cases.

**If achieved:** Loss ~ $C^{-1/5}$ instead of $C^{-1/6}$

### Improvement 2: Less Brute-Force Search

Current: Softmax over 50,000 tokens → needs large logits → power-law convergence

Better: First identify relevant cluster of tokens, then predict within that cluster → higher entropy → faster convergence

**If achieved:** Loss ~ $C^{-1/3}$ instead of $C^{-1/6}$

### Most Optimistic Scenario

If BOTH improvements work:

$$L = \frac{c_C}{C^{1/2}} + L_0$$

**This would be a "cubic speedup"**—for the same compute, 3× better performance.

---

## What Loss Does and Doesn't Tell Us

### Loss IS Important

- Low loss is necessary for good performance
- Captures how well the model can "recite" human text
- Predictable scaling enables planning

### Loss ISN'T Everything

- Same loss can mean different abilities
- Wider models → better at knowledge-intensive tasks
- Deeper models → better at reasoning-intensive tasks
- Different data distributions → same loss, different downstream performance

### When to Stop Pretraining

Stop when:
- You care about specific downstream tasks
- Model has learned the abilities you need
- NOT when loss reaches some arbitrary threshold

---

## Summary: The Three Power Laws

| Source | What | Scaling | Why |
|--------|------|---------|-----|
| **Representation** | Superposition of features | $1/m$ (width) | Geometric interference |
| **Transformation** | Layer averaging | $1/\ell$ (depth) | Central limit theorem |
| **Training** | Softmax + cross-entropy | $1/\tau^{1/3}$ (time) | Universality in dynamics |

**Combined:** Loss ~ $N^{-1/3}$ for model size, $D^{-1/3}$ for data, $C^{-1/6}$ for compute.

---

## Why This Matters for You (Even if You're Not Building LLMs)

### 1. Understanding the AI Hype

The "bigger is better" narrative comes from scaling laws. This theory explains what's actually happening under the hood.

### 2. Predicting AI Progress

If scaling laws hold, we can predict future AI capabilities. If they break down or improve, that changes everything.

### 3. Efficiency vs. Scale

Current approach: throw more compute at the problem
Future approach (per this theory): better architecture

### 4. Data Strategy

Not about collecting more data—about collecting BETTER data and training LONGER.

---

## Citation

```bibtex
@article{liu2026neural,
  title={Neural Scaling Laws Trilogy: Representation, Transformation, and Training},
  author={Liu, Yizhou},
  journal={Blog post},
  year={2026},
  url={https://liuyz0.github.io/blog/2026/NSLT/}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> Neural scaling laws come from THREE sources: representation (width ~ 1/m), transformation (depth ~ 1/ℓ), and training (time ~ 1/τ^{1/3}). The 1/3 exponents in Chinchilla emerge naturally from combining these with standard Transformer architecture.

**What surprised me:**
- Power laws come from ARCHITECTURE (softmax), not data distribution
- We're not running out of data—what matters is quality and training steps
- Current layer use is "inefficient" (ensemble averaging)—room for improvement

**Connections to my work:**
1. **Power laws in astronomy:** Galaxy luminosity functions, mass functions—all power laws. Interesting to see similar mathematical structure in AI.
2. **Optimization:** The universality concept (from statistical physics) appearing in AI is fascinating.
3. **Data vs. compute trade-offs:** Similar to telescope time vs. survey area optimization.

**Questions to explore:**
- [ ] Could these scaling law insights apply to scientific foundation models?
- [ ] Is there a "compute-optimal" frontier for astronomical data analysis?
- [ ] What would "compositional layers" look like for scientific reasoning?

**Further reading:**
- Original Chinchilla paper (Hoffmann et al., 2022)
- Elhage et al. on superposition
- Universality in statistical physics
