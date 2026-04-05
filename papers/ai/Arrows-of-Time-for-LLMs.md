---
title: "Arrows of Time for Large Language Models"
authors:
  - Anonymous
source: arXiv:2401.17505v4
date_published: 2024-01 (revised 2026)
date_read: 2026-03-30
type: paper_summary
category: ai
venue: ICML 2026
tags:
  - arrow-of-time
  - time-directionality
  - perplexity
  - autoregressive-models
---

# Arrows of Time for Large Language Models

## The Core Question

**Does it matter whether LLMs predict forward (next token) or backward (previous token)?**

From pure information theory: **No** — the total information content of a sequence is the same regardless of direction.

But empirically: **Yes** — LLMs learn better when predicting forward.

---

## The Experiment

Train identical models on the same data, but:
- **Forward (FW):** Predict next token given previous ones → `P(X_k | X_1, ..., X_{k-1})`
- **Backward (BW):** Predict previous token given next ones → `P(X_k | X_n, ..., X_{k+1})`

**The measure should be the same** — mathematically:
```
P(X_1, ..., X_n) = P(X_1) × P(X_2|X_1) × ... × P(X_n|X_1...X_{n-1})
                = P(X_n) × P(X_{n-1}|X_n) × ... × P(X_1|X_n...X_2)
```

---

## The Surprising Finding

**Forward models achieve lower perplexity than backward models** — a consistent, subtle asymmetry across:
- Different languages
- Different model sizes
- Different training times
- Different modalities

| Direction | Perplexity | Interpretation |
|-----------|------------|----------------|
| **Forward** | Lower | "Easier" to learn |
| **Backward** | Higher | "Harder" to learn |

The difference is small (~0.1-0.3 nats) but **systematic and universal**.

---

## Why Does This Happen?

### The Physics Analogy

In thermodynamics, the **arrow of time** arises because:
- Macroscopic systems have more microstates in the "future" direction
- Entropy increases over time
- Reversing the arrow requires improbable fine-tuning

### For LLMs

Language has a similar asymmetry:
- **Forward:** Many possible continuations, but some are more likely given context
- **Backward:** Requires "retrodicting" what led to the current state

**Example:** Given "The cat sat on the ___"
- Forward: Easy to predict "mat", "floor", "couch"...
- Backward: Given "mat", what came before? Harder to narrow down.

### The Theoretical Explanation

The paper proposes two mechanisms:

1. **Sparsity:** Language distributions are sparse — most tokens are highly unlikely. Forward prediction exploits this sparsity better.

2. **Computational complexity:** Some conditional probabilities are just harder to compute in one direction due to the structure of language.

---

## Visual Summary

```
FORWARD PREDICTION                    BACKWARD PREDICTION
"The cat sat on the ___"              "___ ___ ___ ___ ___ mat"
        ↓                                      ↓
  {mat, floor, couch, bed...}          {The cat sat on the,
                                        A dog slept on the,
                                        The book fell on the...}
        ↓                                      ↓
  Narrower distribution                Broader distribution
  (easier to learn)                    (harder to learn)
```

---

## Key Results

| Language | FW Perplexity | BW Perplexity | Difference |
|----------|---------------|---------------|------------|
| English | 3.21 | 3.32 | +0.11 |
| French | 3.45 | 3.58 | +0.13 |
| Code | 2.89 | 3.01 | +0.12 |

**Pattern:** Forward is consistently better, but the gap varies by language type.

---

## Implications

### 1. For Model Design
- Forward prediction is "natural" for language — not just a convention
- Bidirectional models (BERT) may lose some efficiency by mixing directions

### 2. For Understanding Language
- Language has inherent **temporal structure**
- The "arrow" isn't just physics — it's built into how we communicate

### 3. For Compression
- Optimal compression should respect the natural direction
- Forward prediction yields slightly better compression rates

---

## The Deeper Insight

> **Language isn't time-symmetric.** Just like physical systems have an arrow of time (entropy increases), language has a directionality that makes forward prediction intrinsically easier than backward prediction.

This connects to:
- **Thermodynamics:** Entropy and irreversibility
- **Causality:** Causes precede effects
- **Communication:** We speak/write in one direction for a reason

---

## Citation

```bibtex
@article{arrow2024time,
  title={Arrows of Time for Large Language Models},
  journal={arXiv preprint arXiv:2401.17505},
  year={2024}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight:**
> Language has an inherent "arrow of time" — forward prediction is systematically easier than backward prediction, even though information theory says they should be equivalent.

**Why it matters:**
- Explains why autoregressive (forward) models work so well
- Connects AI to fundamental physics concepts
- Suggests language itself has causal/temporal structure

**The physics connection:** Just as thermodynamics has an arrow of time (entropy increases), language has a directionality that makes forward prediction easier. This isn't a bug — it's a feature of how information is structured in the world.
