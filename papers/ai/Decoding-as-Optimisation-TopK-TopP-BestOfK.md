---
title: "Decoding as Optimisation: From Top-K to Top-P to Best-of-K"
authors:
  - Xiaotong Ji
  - Rasul Tutunov
  - Matthieu Zimmer
  - Haitham Bou-Ammar
affiliations:
  - Huawei Noah's Ark Lab
  - UCL AI Centre
source: arXiv:2602.18292v1
date_published: 2026-02-13
date_read: 2026-02-24
type: paper_summary
category: ai
venue: Preprint (Machine Learning, NLP)
tags:
  - llm-decoding
  - optimization
  - sampling
  - top-k
  - top-p
  - nucleus-sampling
  - convex-optimization
---

# Decoding as Optimisation on the Probability Simplex

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Decoding as Optimisation on the Probability Simplex: From Top-K to Top-P (Nucleus) to Best-of-K Samplers |
| **arXiv ID** | 2602.18292v1 |
| **Published** | February 13, 2026 |
| **Authors** | Xiaotong Ji, Rasul Tutunov, Matthieu Zimmer, Haitham Bou-Ammar (Huawei Noah's Ark Lab, UCL) |
| **Venue** | Preprint (cs.LG, cs.CL) |

---

## The Big Idea (In Simple Terms)

**The problem:** LLM decoding is usually taught as a "cookbook of tricks"—Top-K, temperature, Top-P, greedy, beam search. Each feels like a separate heuristic you pick based on trial-and-error.

**The insight:** These aren't random tricks. They're all solutions to the **same optimization problem**, just with different mathematical "flavors":
- Different **regularizers** (what you penalize)
- Different **constraints** (what you forbid)

**The master formula:**
> At each token, we optimize: **maximize model score** — **regularization penalty**, subject to constraints.

**Why this matters:** Once you see decoding as optimization, you can:
1. **Understand** why each method behaves the way it does
2. **Design** new decoders by choosing the right objective
3. **Debug** decoding issues by understanding the trade-offs

---

## The Five Decoding Algorithms Explained

### Quick Comparison Table

| Algorithm | What It Does | Optimizer Of | Behavior | When to Use |
|-----------|--------------|--------------|----------|-------------|
| **Greedy** | Always pick highest-score token | No regularization (λ=0) | Deterministic, no diversity | Fact-based Q&A, code completion |
| **Softmax Sampling** | Sample from softmax distribution | Negative entropy regularization | Smooth, diverse | Creative writing, exploration |
| **Top-K** | Only consider top K tokens, sample from them | Entropy + hard support constraint (only top K) | Controlled diversity | General generation, balanced quality/diversity |
| **Top-P (Nucleus)** | Consider tokens until cumulative probability ≥ P | Entropy + cumulative probability constraint | Adaptive diversity | Story generation, open-ended tasks |
| **Sparsemax** | Produce sparse distributions (many zeros) | L₂ norm regularization | Sparse, few active tokens | Structured output, classification |

---

### Detailed Explanation of Each Algorithm

#### 1. Greedy Decoding

**What it does:** Always pick the token with the highest model score.

**Example:**
```
Model scores:  {"the": 3.0, "a": 2.0, "an": 1.5}
Greedy picks:  "the" (probability 100%)
```

**In the optimization framework:**
- Regularizer weight λ = 0 (no regularization at all)
- Pure score maximization → collapses to a single token

**Behavior:**
- ✅ Deterministic, reproducible
- ✅ Fast (no sampling needed)
- ❌ No diversity (same input → same output every time)
- ❌ Can get stuck in repetitive loops

**When to use:**
- Fact-based questions ("What is the capital of France?")
- Code completion (you want the "right" answer, not alternatives)
- Translation (you want the best translation, not random variations)

**Physics analogy:** Like always taking the steepest descent path in energy minimization—fast, but you might miss better global minima.

---

#### 2. Softmax Sampling (Temperature Sampling)

**What it does:** Convert scores to probabilities using softmax, then sample.

**The formula:**
$$q(v) = \frac{e^{s(v)/\tau}}{\sum_u e^{s(u)/\tau}}$$

Where τ (tau) is **temperature**:
- τ → 0: Approaches greedy (sharp distribution)
- τ = 1: Standard softmax
- τ → ∞: Uniform distribution (completely random)

**Example (τ = 1):**
```
Model scores:      {"the": 3.0, "a": 2.0, "an": 1.5}
After softmax:     {"the": 0.67, "a": 0.24, "an": 0.09}
Sample:            67% chance of "the", 24% "a", 9% "an"
```

**In the optimization framework:**
- Regularizer: **Negative entropy** Ω(q) = -H(q)
- Why? Maximizing entropy spreads probability mass, making sampling softer

**Behavior:**
- ✅ Diverse outputs
- ✅ Controllable via temperature
- ❌ Can produce nonsensical outputs at high temperature
- ❌ No control over which tokens get probability

**When to use:**
- Creative writing (you want variation)
- Brainstorming (explore multiple ideas)
- Data augmentation (generate diverse synthetic data)

**Physics analogy:** Like thermodynamic sampling from a Boltzmann distribution—temperature controls how much you explore vs. exploit. High temperature = more thermal fluctuations = more exploration.

---

#### 3. Top-K Sampling

**What it does:** Only keep the top K tokens, zero out the rest, then sample from the renormalized distribution.

**Example (K = 2):**
```
Model scores:      {"the": 3.0, "a": 2.0, "an": 1.5, "that": 0.5}
Top-2 only:        {"the": 3.0, "a": 2.0}
After softmax:     {"the": 0.73, "a": 0.27}
Sample:            73% "the", 27% "a"
```

**In the optimization framework:**
- Regularizer: Negative entropy (like softmax)
- Constraint: **Hard support constraint** — only top K tokens allowed

**Behavior:**
- ✅ Filters out very low-probability tokens
- ✅ More controlled than pure softmax
- ❌ Fixed K doesn't adapt to the distribution shape
- ❌ If top tokens have similar scores, K might be too small

**When to use:**
- General text generation (good default for many tasks)
- When you want diversity but not chaos
- Balanced quality/diversity trade-off

**Physics analogy:** Like restricting sampling to the lowest K energy states—cuts off high-energy (unlikely) configurations.

---

#### 4. Top-P Sampling (Nucleus Sampling)

**What it does:** Keep the smallest set of tokens whose cumulative probability ≥ P, zero out the rest.

**Example (P = 0.9):**
```
After softmax:     {"the": 0.50, "a": 0.25, "an": 0.15, "that": 0.08, "this": 0.02}
Cumulative:        {"the": 0.50, "+a": 0.75, "+an": 0.90 ← stops here}
Nucleus:           {"the": 0.50, "a": 0.25, "an": 0.15} → renormalize
Sample:            55% "the", 28% "a", 17% "an"
```

**In the optimization framework:**
- Regularizer: Negative entropy
- Constraint: **Cumulative probability constraint** — keep tokens until P% covered

**Behavior:**
- ✅ Adaptive—uses more tokens when distribution is flat, fewer when peaked
- ✅ Better than Top-K for varying distribution shapes
- ❌ Still requires tuning P
- ❌ Doesn't control the absolute number of tokens

**When to use:**
- Story generation (adaptive diversity)
- Open-ended creative tasks
- When the distribution shape varies across tokens

**Physics analogy:** Like adaptive energy cutoff—keep all states within P% of the probability mass, which naturally adapts to the distribution's "spread."

---

#### 5. Sparsemax

**What it does:** Like softmax, but produces truly sparse distributions—many tokens get exactly zero probability.

**The formula:** Sparsemax is the Euclidean projection onto the probability simplex. Mathematically:
$$\text{sparsemax}(s) = \arg\min_{p \in \Delta} \|p - s\|_2^2$$

**Example:**
```
Model scores:      {"the": 3.0, "a": 2.0, "an": 1.5, "that": 0.5}
Softmax:           {"the": 0.67, "a": 0.24, "an": 0.09, "that": 0.01}
Sparsemax:         {"the": 0.75, "a": 0.25, "an": 0.00, "that": 0.00}
                   (exactly zero for low-scoring tokens)
```

**In the optimization framework:**
- Regularizer: **L₂ norm squared** Ω(q) = ‖q‖²₂
- This encourages sparsity (many zeros)

**Behavior:**
- ✅ Produces exact zeros (not just tiny probabilities)
- ✅ More interpretable—clear which tokens are "in play"
- ❌ Can be too aggressive in cutting off alternatives
- ❌ Less smooth than softmax

**When to use:**
- Structured output (e.g., classification with mutually exclusive classes)
- When you want clear-cut decisions, not soft probabilities
- Attention mechanisms in neural networks

**Physics analogy:** Like a hard phase transition—instead of smooth probability decay, tokens are either "active" or completely "frozen out."

---

## Visual Comparison

### Distribution Shape Comparison

For input scores `{"A": 3.0, "B": 2.0, "C": 1.0, "D": 0.5}`:

```
Greedy (τ→0):     ████████████████████ A:100%  others:0%

Softmax (τ=1):    ██████████████ A:67%  █████ B:24%  ███ C:9%

Top-K (K=2):      █████████████ A:73%   ██████ B:27%  others:0%

Top-P (P=0.9):    █████████████ A:66%   █████ B:28%  ███ C:6%  (stops at 90%)

Sparsemax:        ██████████████ A:75%  █████ B:25%  others:0%
```

### Key Trade-offs

| Property | Greedy | Softmax | Top-K | Top-P | Sparsemax |
|----------|--------|---------|-------|-------|-----------|
| **Determinism** | Highest | Low | Medium | Medium | Medium |
| **Diversity** | None | High | Medium | Medium-High | Medium |
| **Control** | None | Temperature | K | P | Implicit |
| **Sparsity** | Max | None | Some | Adaptive | High |
| **Adaptivity** | None | None | None | Yes | Yes |

---

## The Optimization Framework

### The "Master Problem"

All decoding algorithms solve variants of:

$$q^* = \arg\max_{q \in \Delta(\mathcal{V})} \left[ \langle q, s \rangle - \lambda \Omega(q) \right] \quad \text{subject to} \quad q \in \mathcal{C}$$

**Components:**
1. **⟨q, s⟩**: Expected model score (favor high-scoring tokens)
2. **Ω(q)**: Regularizer (control distribution shape)
3. **λ**: Trade-off between score and regularization
4. **𝒞**: Constraints (hard limits like "only top K")

### How Each Algorithm Fits

| Algorithm | Regularizer Ω(q) | Constraint 𝒞 | Trade-off λ |
|-----------|-----------------|--------------|-------------|
| Greedy | None (λ=0) | None | λ = 0 |
| Softmax | -H(q) (negative entropy) | None | λ = τ |
| Top-K | -H(q) | Support ⊆ top K | λ = τ |
| Top-P | -H(q) | Cumulative prob ≥ P | λ = τ |
| Sparsemax | ‖q‖²₂ (L₂ squared) | None | Implicit |

### The Key Insight

> **Decoding algorithms differ not by "how they sample" but by "what objective they optimize."**

- **Greedy:** Optimize score only
- **Softmax:** Optimize score + entropy (diversity)
- **Top-K/P:** Optimize score + entropy + hard constraint
- **Sparsemax:** Optimize score + sparsity

---

## The New Contribution: Best-of-K (BoK)

### The Problem with Current Multi-Sample Approaches

When using self-consistency (generate K samples, pick the most common answer) or reranking:
- Standard sampling wastes budget on low-quality samples
- No principled way to "optimize for coverage"

### The BoK Solution

**Objective:** Maximize the probability of covering good alternatives within a K-sample budget.

**Key components:**
1. **Coverage term:** Encourage diverse high-quality samples
2. **KL anchoring:** Stay close to the model's original distribution (don't drift too far)

**Results:**
| Model | Task | Temperature | Base | Top-K | BoK | Improvement |
|-------|------|-------------|------|-------|-----|-------------|
| Qwen2.5-Math-7B | MATH500 | τ=0.9 | 53.0% | 56.2% | 71.6% | **+18.6%** |
| Qwen2.5-Math-7B | GPQA | τ=0.9 | — | — | — | **+6.06%** |
| Qwen2.5-Math-7B | HumanEval | τ=0.9 | — | — | — | **+14.64%** |

**Overhead:** Only ~1 second extra on MATH500 (16.88s vs 15.84s).

**When to use:**
- Self-consistency for math/reasoning
- Reranking multiple candidates
- Verifier selection (pick best of K samples)

---

## Implications for Astronomy and Data Science

### 1. Optimization on the Simplex: A General Pattern

The paper's framework—**optimizing over probability distributions**—is deeply relevant to astronomy:

**Examples from your domain:**
| Problem | What You're Optimizing | Analogy to Decoding |
|---------|------------------------|---------------------|
| **Photometric redshift estimation** | Probability distribution over redshift | Like predicting a distribution, not just a point estimate |
| **Galaxy classification** | Probability over galaxy types | Softmax over classes |
| **Source detection** | Probability of detection vs. noise | Threshold on probability |
| **Bayesian inference** | Posterior distribution over parameters | Full distribution, not just MAP estimate |

### 2. Regularization as a Design Principle

The paper shows that **regularization shapes the solution**. This is universal:

**In astronomy:**
- **L₂ regularization (Ridge):** Smooth parameter estimates (like Sparsemax encourages sparsity via L₂ projection)
- **L₁ regularization (Lasso):** Sparse solutions (like Sparsemax produces zeros)
- **Entropy regularization:** Diverse, uncertain predictions (like Softmax)

**Example:** When fitting galaxy SEDs, you might want:
- **Sparse solution:** Only a few stellar populations contribute → use L₁/Sparsemax-style penalty
- **Smooth solution:** Many populations contribute smoothly → use L₂/entropy-style penalty

### 3. Trade-off Between Score and Regularization

The master problem `max[score - λ × regularizer]` appears everywhere:

**Astronomy examples:**
| Application | "Score" | "Regularizer" | Trade-off λ |
|-------------|---------|---------------|-------------|
| Model fitting | Log-likelihood | Complexity penalty (BIC/AIC) | — |
| Image reconstruction | Data fidelity | Smoothness/sparsity | Regularization weight |
| Source extraction | Signal strength | Background model complexity | Detection threshold |
| Classification | Accuracy | Model complexity | Cross-validation |

### 4. Hard Constraints vs. Soft Regularization

The paper distinguishes:
- **Hard constraints (𝒞):** Must be satisfied (e.g., only top K tokens)
- **Soft regularization (λΩ):** Penalized but not forbidden

**In astronomy:**
- **Hard constraint:** Physical bounds (flux must be positive, redshift must be > 0)
- **Soft regularization:** Penalizing unphysical oscillations in reconstructed images

**Lesson:** Think carefully about what should be **impossible** vs. what should be **unlikely**.

### 5. Multi-Sample Strategies for Uncertainty Quantification

The Best-of-K strategy has direct analogies:

**In astronomy:**
- **Monte Carlo sampling:** Generate many samples, analyze distribution
- **Bootstrap resampling:** Estimate uncertainty from multiple resamples
- **Ensemble methods:** Combine multiple model predictions

**The BoK insight:** Instead of random sampling, **optimize the sampling strategy** to cover high-probability regions efficiently.

**Application:** When fitting models to galaxy data:
- Instead of random MCMC samples, could design a sampler that maximizes coverage of high-likelihood regions
- Trade off between exploration (diversity) and exploitation (high-likelihood samples)

### 6. Practical Takeaways for Your Research

**Model fitting:**
- Think about **what you're optimizing** (likelihood? posterior? something else?)
- Choose **regularization** based on desired solution properties (sparse? smooth? diverse?)
- Use **constraints** for physical requirements (positive fluxes, bounded parameters)

**Classification/prediction:**
- **Greedy:** Single best prediction (like Maximum Likelihood)
- **Softmax:** Full probability distribution (like Bayesian posterior)
- **Sparse:** Only consider top few classes (like thresholded probabilities)

**Multi-sample analysis:**
- When generating multiple fits/samples, consider **coverage**—are you exploring the parameter space efficiently?
- Use **KL divergence** to measure how far samples drift from a reference distribution

**Computational efficiency:**
- The paper shows ~1 second overhead for BoK's optimization
- In astronomy, similar trade-offs: more sophisticated sampling vs. faster runtime

### 7. Specific Connections to MUST Telescope

**Data processing pipeline:**
- At each stage, you're making **decisions** (keep/discard, classify, assign)
- These can be framed as **optimization over distributions**
- Example: Source classification → probability distribution over source types → choose based on desired properties

**Survey optimization:**
- Selecting targets for follow-up → trade-off between **scientific value** (score) and **observational constraints** (regularization)
- Finite observational budget → like the K-sample budget in BoK

---

## Summary Table: Decoding Algorithms at a Glance

| Algorithm | Intuition | Formula | Regularizer | When to Use |
|-----------|-----------|---------|-------------|-------------|
| **Greedy** | "Always pick the best" | argmax s(v) | None | Deterministic tasks |
| **Softmax** | "Weighted random choice" | $e^{s(v)/τ} / Σ$ | Negative entropy | Creative/diverse tasks |
| **Top-K** | "Pick from top K only" | Softmax on top K | Entropy + support | Balanced generation |
| **Top-P** | "Pick from top P% mass" | Softmax on nucleus | Entropy + cumulative | Adaptive diversity |
| **Sparsemax** | "Sparse probability" | Project to simplex | L₂ norm squared | Structured output |
| **BoK** | "Optimize K-sample coverage" | Mirror ascent | Coverage + KL | Multi-sample pipelines |

---

## Key Takeaways

### For Understanding LLMs
1. **Decoding = Optimization:** All methods optimize the same basic objective with different regularizers
2. **Temperature controls trade-off:** Higher τ = more regularization = more diversity
3. **Constraints shape the feasible set:** Hard limits (Top-K) vs. soft penalties (entropy)

### For Your Research
1. **Regularization is universal:** The same principles apply to model fitting, image reconstruction, classification
2. **Think in terms of trade-offs:** Score vs. complexity, diversity vs. determinism
3. **Hard vs. soft constraints:** What must be true vs. what should be unlikely
4. **Multi-sample strategies:** Optimize coverage, not just random sampling
5. **Simplex geometry:** Optimizing over probability distributions has unique structure

---

## Citation

```bibtex
@article{ji2026decoding,
  title={Decoding as Optimisation on the Probability Simplex: From Top-K to Top-P (Nucleus) to Best-of-K Samplers},
  author={Ji, Xiaotong and Tutunov, Rasul and Zimmer, Matthieu and Bou-Ammar, Haitham},
  journal={arXiv preprint arXiv:2602.18292},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> LLM decoding methods aren't random tricks—they're all solutions to the same optimization problem with different regularizers. This pattern (score + regularization + constraints) appears everywhere in science.

**Connections to my work:**
1. **SED fitting:** Likelihood + complexity penalty + physical bounds → same structure as decoding optimization
2. **Galaxy classification:** Softmax probabilities → full posterior vs. point estimate
3. **Multi-sample methods:** BoK's coverage optimization could inform MCMC/bootstrap strategies
4. **MUST survey design:** Target selection as optimization with budget constraints

**Questions to explore:**
- [ ] Could BoK-style coverage optimization improve my multi-sample analyses?
- [ ] How do my current regularization choices map to the decoding framework?
- [ ] Am I using hard constraints where soft regularization would be better (or vice versa)?

**Action items:**
- [ ] Review current fitting pipelines: what's the "score" and what's the "regularizer"?
- [ ] Consider entropy regularization for uncertainty quantification
- [ ] Think about coverage in multi-sample/benchmark cosmological analyses
