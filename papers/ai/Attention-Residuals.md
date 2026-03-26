---
title: "Attention Residuals"
authors:
  - Kimi Team (Moonshot AI)
source: arXiv:2603.15031v1
date_published: 2026-03-16
date_read: 2026-03-18
type: paper_summary
category: ai
venue: Technical Report
tags:
  - residual-connections
  - transformer-architecture
  - attention
  - llm-architecture
  - depth-wise-attention
---

# Attention Residuals: A Fundamental Architecture Change

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Attention Residuals |
| **arXiv ID** | 2603.15031v1 |
| **Authors** | Kimi Team (Moonshot AI) |
| **Code** | github.com/MoonshotAI/Attention-Residuals |
| **Type** | Technical Report (Architecture) |

---

## The Basic Problem: What's Wrong with Residual Connections?

### What Are Residual Connections?

In modern LLMs (like GPT, LLaMA), every layer adds its output to its input:

```
h_l = h_{l-1} + f_{l-1}(h_{l-1})
```

This is the "residual connection" — the layer's output is added to (residual) the input.

### The Standard Way (PreNorm)

Most modern LLMs use **PreNorm** — normalize before the transformation:

```
h_1 = embedding
h_2 = h_1 + attention(norm(h_1))
h_3 = h_2 + mlp(norm(h_2))
h_4 = h_3 + attention(norm(h_3))
...
```

If you "unroll" this, the hidden state at layer L is:

```
h_L = h_1 + f_1 + f_2 + f_3 + ... + f_{L-1}
```

Every layer's contribution is **added with equal weight (1)**.

### The Problem: Dilution

| Layer | What Happens |
|-------|--------------|
| Layer 1 output | Added once, stays in the sum |
| Layer 10 output | Added once, stays in the sum |
| Layer 50 output | Added once, stays in the sum |

**But here's the issue:** As you go deeper, the hidden state **grows in magnitude**:

```
||h_L|| ≈ O(L)  (grows linearly with depth)
```

Each layer's contribution gets **diluted** — it's just 1 out of L terms. Early layers get "buried."

**Empirical evidence:** A significant fraction of layers can be pruned (removed) with minimal performance loss. The model isn't effectively using all its layers.

---

## The Insight: Time vs. Depth Duality

### The Analogy

The authors observe a **duality** between:

| Dimension | Old Approach | Better Approach |
|-----------|--------------|-----------------|
| **Time (sequences)** | RNNs compress history into one state | Transformers use attention to access all positions |
| **Depth (layers)** | Residuals compress history into one state | **AttnRes uses attention to access all layers** |

**The key insight:** Transformers replaced RNNs because attention lets each position selectively access all previous positions. Why not do the same for layers?

---

## The Solution: Attention Residuals

### Standard Residuals

```
h_l = h_1 + f_1(h_1) + f_2(h_2) + ... + f_{l-1}(h_{l-1})
```

Every layer's output is added with **fixed weight = 1**.

### Attention Residuals

```
h_l = α_{0→l} · h_1 + α_{1→l} · f_1(h_1) + α_{2→l} · f_2(h_2) + ...
```

Each layer's output is weighted by **learned attention weights** α.

### How the Weights Are Computed

For each layer l, we compute attention over all previous layer outputs:

```
α_{i→l} = softmax(q_l · k_i)
```

Where:
- **Query (q_l):** A learned vector w_l (one per layer, d-dimensional)
- **Key (k_i):** The output of layer i (normalized)
- **Value (v_i):** The output of layer i

**This is just softmax attention, but over layers instead of tokens!**

---

## Visual Comparison

### Standard Residuals

```
Layer 1 ────────┐
Layer 2 ────────┤
Layer 3 ────────┼───► Sum with equal weights ───► Output
Layer 4 ────────┤
...             │
Layer L ────────┘
```

All contributions are equal.

### Attention Residuals

```
Layer 1 ────► ┐
Layer 2 ────► │
Layer 3 ────► ├─► Attention (learned weights) ──► Weighted sum ──► Output
Layer 4 ────► │
...          │
Layer L ────► ┘
```

Each layer can be weighted differently based on what the current layer needs.

---

## The Practical Challenge: Memory

### Full Attention Residuals

To compute attention at layer L, you need:
- All L-1 previous layer outputs
- Memory: O(L × d) per token
- Communication: O(L × d) across pipeline stages

For a 100-layer model with d=4096, this is ~1.6 MB per token. At scale with pipeline parallelism, this is expensive.

### Block Attention Residuals (The Practical Solution)

**Key idea:** Group layers into blocks, attend over block summaries instead of individual layers.

```
Block 1 (Layers 1-12)   ──► b_1 (block summary)
Block 2 (Layers 13-24)  ──► b_2 (block summary)
Block 3 (Layers 25-36)  ──► b_3 (block summary)
...
Block N (Layers ...)    ──► b_N (block summary)
```

**Within a block:** Use standard residuals (sum)
**Across blocks:** Use attention over block summaries

| Metric | Full AttnRes | Block AttnRes |
|--------|--------------|---------------|
| Memory | O(L × d) | O(N × d) |
| Attention computation | O(L²) | O(N²) |

**Empirical finding:** N ≈ 8 blocks recovers most of the benefit of full attention!

---

## Results

### Scaling Law Experiments

Block AttnRes with N=8 matches the loss of a baseline trained with **1.25× more compute**.

### 48B Model (Kimi Linear)

| Architecture | Training | Results |
|--------------|----------|---------|
| Standard residuals | 1.4T tokens | Baseline |
| AttnRes | 1.4T tokens | Better on all downstream tasks |

### Training Dynamics Analysis

| Metric | Standard Residuals | AttnRes |
|--------|-------------------|---------|
| Hidden state magnitude | Grows O(L) | **Bounded** |
| Gradient distribution | Uneven across layers | **More uniform** |
| Layer utilization | Some layers prunable | **All layers contribute** |

### Inference Overhead

| Metric | Overhead |
|--------|----------|
| Latency | < 2% increase |
| Memory | Marginal |

---

## The Deeper Insight: Linear vs. Softmax Attention

The paper shows that standard residuals are a form of **linear attention** over depth:

| Method | What It Does | Attention Type |
|--------|--------------|----------------|
| Standard residuals | Fixed weights (all = 1) | Linear attention |
| Highway Networks | Learned gates | Linear attention |
| Hyper-Connections | Multiple streams | Linear attention |
| **AttnRes** | Learned softmax weights | **Softmax attention** |

**The progression:** Same evolution that happened for sequences (RNN → Transformer) is now happening for depth.

---

## Why This Is Important

### 1. Fundamental Architecture Change

This isn't a small tweak — it's a fundamental change to how information flows through the network:

| Aspect | Before | After |
|--------|--------|-------|
| Layer aggregation | Fixed, uniform | Learned, selective |
| Early layer access | Buried in sum | Can be retrieved |
| Depth utilization | Some layers unused | All layers can contribute |

### 2. Mitigates PreNorm Problems

PreNorm (the current standard) has a fundamental tension:
- Bounded gradients ✓
- Unbounded hidden state growth ✗

AttnRes resolves this by making aggregation selective instead of cumulative.

### 3. Practical at Scale

Block AttnRes with infrastructure optimizations makes this deployable:
- Cross-stage caching eliminates redundant transfers
- Two-phase inference minimizes latency overhead
- < 2% inference overhead

### 4. Consistent Scaling

The improvement persists across model sizes — not just a small-model effect.

---

## Summary: The Three Key Concepts

### 1. The Problem
> Standard residuals treat every layer's contribution equally, causing dilution and uncontrolled hidden state growth.

### 2. The Insight
> There's a duality between time (sequences) and depth (layers). What worked for sequences (attention replacing RNNs) can work for depth too.

### 3. The Solution
> Replace fixed summation with learned attention over layer outputs. Each layer can selectively aggregate from all previous layers.

---

## Comparison Table

| Aspect | Standard Residuals | Attention Residuals |
|--------|-------------------|---------------------|
| **Aggregation** | Sum (fixed weights) | Attention (learned weights) |
| **Early layer access** | Buried in sum | Can be retrieved |
| **Hidden state growth** | O(L) unbounded | Bounded |
| **Gradient distribution** | Uneven | More uniform |
| **Layer utilization** | Some layers unused | All can contribute |
| **Memory overhead** | None | O(N × d) with blocks |
| **Inference overhead** | None | < 2% |

---

## Citation

```bibtex
@article{kimi2026attnres,
  title={Attention Residuals},
  author={Kimi Team},
  journal={arXiv preprint arXiv:2603.15031},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> Residual connections are a form of "depth-wise attention" with fixed weights. AttnRes upgrades this to learned softmax attention — the same evolution that transformed sequence modeling from RNNs to Transformers.

**What surprised me:**
- The duality between time (sequences) and depth (layers) is elegant
- 8 blocks is enough to recover most benefits
- PreNorm's hidden state growth is O(L) — I hadn't thought about this explicitly
- This is a fundamental architecture change, not a minor tweak

**Physics analogy:** This is like upgrading from a simple integrator (Euler method, fixed step size) to an adaptive integrator (variable step sizes based on local behavior). The adaptive version can be more efficient and accurate.

**Connections to my work:**
- Deep learning models for astronomy could benefit from better depth-wise information flow
- The block-wise approach is similar to hierarchical modeling in physics

**Questions to explore:**
- [ ] Would AttnRes help with very deep models for astronomical image analysis?
- [ ] How does this interact with other architectural innovations (MoE, etc.)?
- [ ] Could this idea apply to other types of deep networks (CNNs, etc.)?

**The big picture:** This could be one of those papers that changes how we build transformers, like the original attention paper or RoPE. It addresses a fundamental limitation of the current architecture.
