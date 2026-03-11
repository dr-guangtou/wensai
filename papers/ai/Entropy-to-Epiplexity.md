---
title: "From Entropy to Epiplexity: Rethinking Information for Computationally Bounded Intelligence"
authors:
  - Marc Finzi
  - Shikai Qiu
  - Yiding Jiang
  - Pavel Izmailov
  - J. Zico Kolter
  - Andrew Gordon Wilson
source: "arXiv:2601.03220v1"
tags:
  - paper
  - dev/tool
  - ai/deep-learning
  - ai/llm
affiliations:
  - Carnegie Mellon University
  - New York University
date_published: 2026-01
date_read: 2026-03-04
type: paper_summary
category: ai
venue: "Preprint (Machine Learning, Information Theory)"
---
# From Entropy to Epiplexity

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | From Entropy to Epiplexity: Rethinking Information for Computationally Bounded Intelligence |
| **arXiv ID** | 2601.03220v1 |
| **Authors** | Finzi, Qiu, Jiang, Izmailov, Kolter, Wilson (CMU, NYU) |
| **Type** | Theory + Experiments |

---

## The Big Question

**Can we learn MORE from data than was "in" the data to begin with?**

Traditional information theory says **no**:
- Shannon entropy: deterministic transformations can't increase information
- Kolmogorov complexity: information is intrinsic to the object

But in practice, **yes**:
- AlphaZero learns superhuman chess from simple game rules
- Synthetic data improves model capabilities
- Mathematicians derive new knowledge from axioms

**This paper's answer:** It depends on who's "learning." A **computationally bounded observer** (like a neural network with limited compute) CAN extract more "structural information" than an unbounded observer would see.

---

## Three Paradoxes of Traditional Information Theory

The authors identify three statements that are mathematically true in traditional information theory, but contradict empirical observations:

### Paradox 1: Information Cannot Be Created

**Theory says:** Deterministic transformations can't increase information.

**Reality says:**
- Pseudorandom generators create "randomness" from a seed
- AlphaZero learns sophisticated strategies from simple rules
- Conway's Game of Life produces complex emergent patterns

**The problem:** Traditional theory assumes infinite compute. If you have infinite compute, you can simulate the Game of Life perfectly—no new information. But a finite-compute observer learns about "gliders" and "spaceships" that the rules don't explicitly encode.

### Paradox 2: Information is Order-Independent

**Theory says:** Total information doesn't depend on how you factorize it. H(X,Y) = H(Y,X).

**Reality says:**
- LLMs learn better on left-to-right text than reversed text
- Cryptography exists because some directions are harder than others
- There's an "arrow of time" in learning

**The problem:** Traditional theory ignores computational asymmetry. For bounded observers, predicting forward ≠ predicting backward.

### Paradox 3: Likelihood Modeling is Just Distribution Matching

**Theory says:** The best model is the data-generating process itself. You can't do better.

**Reality says:**
- A model trained on Game of Life learns about emergent objects (gliders, eaters)
- These objects weren't in the generating rules
- The model learned "more" than was put in

**The problem:** The data-generating process might be simple, but its consequences (emergent phenomena) are complex. Bounded observers can learn to exploit this structure.

---

## The Solution: Epiplexity

### The Key Insight

Information has **two components**:

1. **Random content (entropy):** Unpredictable, inherently random
2. **Structural content (epiplexity):** Predictable patterns that bounded observers can learn

```
┌─────────────────────────────────────────────────────────┐
│                    INFORMATION                          │
│                                                         │
│  ┌─────────────────┐    ┌─────────────────────────┐   │
│  │  RANDOM CONTENT │    │  STRUCTURAL CONTENT     │   │
│  │  (Entropy)      │    │  (Epiplexity)           │   │
│  │                 │    │                         │   │
│  │  - Unpredictable│    │  - Predictable patterns │   │
│  │  - Noise        │    │  - Learnable structure  │   │
│  │  - No reuse     │    │  - Reusable circuits    │   │
│  └─────────────────┘    └─────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### What is Epiplexity?

**Definition:** The structural information that a **computationally bounded observer** can extract from data.

**More formally:** The model description length that minimizes the total code length for the data, given computational constraints.

**Intuition:**
- **High epiplexity:** Complex patterns that require substantial model capacity to capture
- **Low epiplexity:** Either trivially predictable or truly random

### Time-Bounded Entropy vs. Epiplexity

| Measure | Captures | Example |
|---------|----------|---------|
| **Time-bounded entropy** | Randomness that bounded observers can't predict | Pseudorandom output, chaotic dynamics |
| **Epiplexity** | Structure that bounded observers can learn | Emergent patterns, reusable circuits |

**Key insight:** The SAME data can have:
- High entropy (hard to predict exactly)
- High epiplexity (lots of learnable structure)

Example: Chaotic dynamical systems → you can't predict exact trajectories (high entropy), but you can learn the invariant measure/attractor (high epiplexity).

---

## Examples: Low vs. High Epiplexity

### Low Epiplexity Data

| Type | Why Low |
|------|---------|
| **Repetitive code** | No patterns to learn |
| **Simple gradients** | Trivial structure |
| **Random API keys** | No learnable structure |
| **Pseudorandom sequences** | Structure exists but computationally hidden |
| **Shuffled image pixels** | Destroyed all structure |

### High Epiplexity Data

| Type | Why High |
|------|----------|
| **Algorithm implementations** | Complex logic, reusable patterns |
| **Natural images** | Rich structure, emergent features |
| **Language** | Grammar, semantics, reasoning patterns |
| **Chess games** | Strategic patterns, reusable concepts |
| **Cellular automata evolution** | Emergent objects (gliders, eaters) |

---

## How to Measure Epiplexity

### Simple Heuristic: Area Under the Loss Curve

```
Loss
  │
  │ ╲
  │  ╲
  │   ╲___
  │      ─────  ← Final loss (entropy)
  │
  └─────────────── Training steps
        ↑
   This area ≈ Epiplexity
```

**Intuition:** How much "learning" happened before convergence?

- **Large area:** Model had to learn a lot → high epiplexity
- **Small area:** Model converged quickly → low epiplexity

### More Rigorous: Two Approaches

| Approach | Method | Pros | Cons |
|----------|--------|------|------|
| **Prequential coding** | Train online, accumulate log-likelihood | Simple, practical | Biased by student capacity |
| **Requential coding** | Compare to fixed teacher model | More rigorous | Requires teacher selection |

---

## Resolving the Paradoxes with Epiplexity

### Paradox 1: Creating Information

**Old view:** Deterministic transformations can't create information.

**New view:** They CAN create **time-bounded entropy** and **epiplexity**.

**Examples:**
- Cellular automata: Simple rules → emergent gliders (high epiplexity)
- AlphaZero: Simple rules → complex strategies (high epiplexity)
- Pseudorandom generators: Simple seed → unpredictable output (high time-bounded entropy, low epiplexity)

### Paradox 2: Order Matters

**Old view:** Information is order-independent.

**New view:** For bounded observers, order matters because:
- Forward prediction ≠ backward prediction (computationally)
- Some factorizations are easier to learn

**Example:** LLMs learn left-to-right better than right-to-left because the "natural" factorization matches linguistic structure.

### Paradox 3: More Than Distribution Matching

**Old view:** Best model = data generating process.

**New view:** Bounded observers can learn structure that's "implicit" in the generating process:
- **Induction:** Learn general rules from specific examples
- **Emergence:** Discover macro-level patterns from micro-level rules

**Example:** Game of Life generates simple bit patterns, but models learn about "gliders," "spaceships," "eaters"—concepts not in the rules.

---

## Practical Applications

### 1. Data Selection for Pretraining

**Problem:** What data should we train on?

**Epiplexity-based answer:** Select data with HIGH epiplexity.

**Why:** High epiplexity data induces more structural information in the model, which can be reused for downstream tasks.

**Evidence:** Chess pretraining data ranked by epiplexity correlates with OOD generalization:

| Data Type | Epiplexity | OOD Performance |
|-----------|------------|-----------------|
| Opening sequences | Low | Poor |
| Full games | Medium | Good |
| Puzzle positions | High | Best |

### 2. Understanding Transfer Learning

**Why does pretraining help?**

Not because we memorize the training distribution—but because we learn **reusable structures** (circuits, features, patterns).

**High epiplexity data** → more reusable structures → better transfer.

### 3. Synthetic Data Design

**Principle:** Synthetic data should have HIGH epiplexity.

**How:**
- Simulate complex dynamics (cellular automata, physics)
- Use computational processes that produce emergent structure
- Avoid simple patterns that are either trivial or random

### 4. Measuring Data Quality

**Epiplexity as a quality metric:**

| Data Source | Epiplexity | Interpretation |
|-------------|------------|----------------|
| OpenWebText | High | Rich linguistic structure |
| CIFAR-5M | Medium | Visual patterns but limited |
| Random data | Near-zero | No learnable structure |

---

## Key Experimental Results

### Experiment 1: Cellular Automata

Trained transformers on Elementary Cellular Automata (ECA) rules:

| Rule | Behavior | Epiplexity | Learning |
|------|----------|------------|----------|
| Rule 0 | All zeros | Very low | Trivial |
| Rule 30 | Chaotic | Low (high entropy) | Can't predict |
| Rule 110 | Complex | High | Emergent patterns learned |

### Experiment 2: Chess

Pretrained on different chess data, tested on OOD puzzles:

| Pretrain Data | Epiplexity | Puzzle Accuracy |
|---------------|------------|-----------------|
| Random moves | Low | 15% |
| Opening sequences | Low | 25% |
| Full games | Medium | 45% |
| Mixed puzzles | High | 60% |

**Correlation:** Higher epiplexity → better OOD generalization

### Experiment 3: Language vs. Images

Compared epiplexity of text vs. image data:

| Data Type | Epiplexity Estimate | Transfer Breadth |
|-----------|--------------------|--------------------|
| Text (OpenWebText) | Higher | Transfers broadly |
| Images (CIFAR) | Lower | Transfers narrowly |

**Insight:** Text has richer structural patterns that transfer more broadly.

---

## Implications for AI Development

### 1. Data-Centric AI

**Shift in focus:**
- Old: Given data, optimize model
- New: Select/optimize data for maximum epiplexity

**Practical impact:** Data curation becomes as important as model architecture.

### 2. Understanding Emergence

**What is emergence?**
- Macro-level patterns arising from micro-level rules
- For bounded observers, these are "real" and learnable
- Epiplexity quantifies how much emergent structure exists

### 3. Synthetic Data Generation

**Principle:** Generate data with computational processes that produce high epiplexity:
- Simulations (physics, games, dynamics)
- Programs that produce complex outputs
- Processes with emergent structure

### 4. When to Stop Pretraining

**Not just when loss converges**—but when epiplexity extraction plateaus.

---

## Summary: The Three Key Ideas

### 1. Information Depends on the Observer

Same data has different information content for:
- Unbounded observer (infinite compute) → Kolmogorov complexity
- Bounded observer (limited compute) → Time-bounded entropy + epiplexity

### 2. Structure vs. Randomness

Information splits into:
- **Time-bounded entropy:** Randomness you can't predict
- **Epiplexity:** Structure you can learn and reuse

### 3. Computation Can Create Learnable Structure

Deterministic processes can:
- Create apparent randomness (pseudorandom generators)
- Create learnable structure (emergence, induction)
- Both are "real" for bounded observers

---

## Comparison Table: Information Measures

| Measure | Observer | What It Captures | Use Case |
|---------|----------|------------------|----------|
| Shannon entropy | Distribution-level | Average surprise | Communication |
| Kolmogorov complexity | Unbounded | Shortest program | Theory |
| Time-bounded entropy | Bounded (time T) | Predictable randomness | Cryptography |
| **Epiplexity** | Bounded (time T) | Learnable structure | Data selection |

---

## Citation

```bibtex
@article{finzi2026epiplexity,
  title={From Entropy to Epiplexity: Rethinking Information for Computationally Bounded Intelligence},
  author={Finzi, Marc and Qiu, Shikai and Jiang, Yiding and Izmailov, Pavel and Kolter, J. Zico and Wilson, Andrew Gordon},
  journal={arXiv preprint arXiv:2601.03220},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> Information depends on the observer. For computationally bounded observers (like neural networks), data has two components: random content (unpredictable) and structural content (learnable). Epiplexity measures the learnable structure that can be extracted and reused.

**What surprised me:**
- Deterministic processes CAN create "new" information for bounded observers
- The same data can have high entropy AND high epiplexity (chaotic systems)
- Order matters for bounded observers (explains why curriculum learning works)

**Connections to my work:**
1. **Astronomical data:** Does astronomical data have high epiplexity? Probably yes—complex physical processes produce learnable structure
2. **Data selection:** When building training sets for MUST analysis, prefer data with high structural content
3. **Simulation data:** Synthetic galaxy surveys might have high epiplexity if they capture emergent physical phenomena

**Questions to explore:**
- [ ] How would I measure epiplexity of astronomical survey data?
- [ ] Can epiplexity guide which observations to prioritize?
- [ ] Does simulation data have higher epiplexity than observational data?

**Practical applications:**
- Data curation for training astronomical foundation models
- Understanding why certain pretraining helps downstream tasks
- Designing synthetic data for training
