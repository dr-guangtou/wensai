---
title: "MemFactory: Unified Inference & Training Framework for Agent Memory"
authors:
  - Anonymous
source: arXiv:2603.29493v1
date_published: 2026-03-31
date_read: 2026-04-04
type: paper_summary
category: ai
venue: Preprint (AI Agents, RL)
tags:
  - memory-augmented-agents
  - grpo
  - reinforcement-learning
  - agent-memory
  - llm-framework
---

# MemFactory & GRPO: Memory Agents Meet RL

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | MemFactory: Unified Inference & Training Framework for Agent Memory |
| **arXiv ID** | 2603.29493v1 |
| **Type** | Framework + Methods |

---

## Part 1: What is MemFactory?

### The Problem

AI agents need **memory** to function over long periods. But building memory systems is hard:
- How do you extract useful information from conversations?
- How do you update memories when facts change?
- How do you retrieve the right memories at the right time?

Current approaches are **fragmented** — each research project has its own custom implementation, making it hard to compare or combine ideas.

### The Solution: MemFactory

> **MemFactory** is a unified, modular framework for building and training memory-augmented AI agents — like "LLaMA-Factory but for agent memory."

It breaks memory into **plug-and-play components** that you can mix and match:

```
┌─────────────────────────────────────────────────────────────┐
│                    MemFactory Architecture                  │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   EXTRACT    │    │    UPDATE    │    │   RETRIEVE   │
│  (extract    │    │  (add/delete │    │  (find       │
│   memories)  │    │   /modify)   │    │   relevant)  │
└──────────────┘    └──────────────┘    └──────────────┘
        │                  │                   │
        └──────────────────┼───────────────────┘
                           ▼
              ┌─────────────────────────┐
              │      AGENT LAYER        │
              │  (assembles modules     │
              │   into policies)        │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │    ENVIRONMENT LAYER    │
              │  (data + rewards)       │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │     TRAINER LAYER       │
              │  (GRPO optimization)    │
              └─────────────────────────┘
```

### The Four Layers

| Layer | What It Does |
|-------|--------------|
| **Module Layer** | Atomic operations: Extract, Update, Retrieve |
| **Agent Layer** | Combines modules into complete memory policies |
| **Environment Layer** | Provides data and computes rewards |
| **Trainer Layer** | Optimizes policies using GRPO |

### Supported Paradigms (Out-of-the-Box)

| Paradigm | Memory Strategy |
|----------|-----------------|
| **Memory-R1** | Explicit CRUD operations (add/update/delete) |
| **MemAgent** | Recurrent state compression |
| **RMM** | Retrieval refinement with reranking |

---

## Part 2: What is GRPO?

### The Problem with Traditional RL (PPO)

**PPO (Proximal Policy Optimization)** is the standard RL algorithm for training LLMs. But it has a problem:

> PPO requires a **separate "critic" model** to estimate values — doubling memory requirements.

```
PPO Setup:
┌─────────────────┐    ┌─────────────────┐
│  Policy Model   │ +  │  Critic Model   │  ← 2× memory!
│  (the LLM)      │    │  (value network)│
└─────────────────┘    └─────────────────┘
```

For memory agents with long contexts, this is **prohibitively expensive**.

### The GRPO Solution

**Group Relative Policy Optimization (GRPO)** eliminates the critic entirely.

**Key insight:** Instead of a separate model estimating "how good" an action is, compare responses **to each other**.

```
GRPO Setup:
┌─────────────────────────────────────────────────┐
│  For each input, sample G different responses   │
│                                                 │
│  Input → Response 1 → Reward r₁                │
│        → Response 2 → Reward r₂                │
│        → Response 3 → Reward r₃                │
│        → ...                                    │
│        → Response G → Reward r_G               │
│                                                 │
│  Compare rewards within the group               │
│  → No critic needed!                           │
└─────────────────────────────────────────────────┘
```

### The GRPO Formula

For response *i* with reward *rᵢ*, the **advantage** is:

$$\hat{A}_i = \frac{r_i - \text{mean}(\{r_1, \ldots, r_G\})}{\text{std}(\{r_1, \ldots, r_G\})}$$

**In plain English:**
1. Generate G different responses to the same input
2. Score each response (e.g., did it solve the task?)
3. Normalize scores: above average = positive advantage, below average = negative advantage
4. Update the model to increase probability of high-advantage responses

### Visual Example

```
Input: "What is the capital of France?"

Response 1: "Paris"           → Reward: 1.0  → Advantage: +0.82  ✓ (push up)
Response 2: "France"          → Reward: 0.0  → Advantage: -1.23  ✗ (push down)
Response 3: "The capital is"  → Reward: 0.0  → Advantage: -1.23  ✗ (push down)
Response 4: "Paris, France"   → Reward: 1.0  → Advantage: +0.82  ✓ (push up)

Mean reward = 0.5, Std = 0.41
```

Responses better than the group average get reinforced. Worse ones get suppressed.

### Why GRPO Works for Memory Agents

| Aspect | Why It Matters |
|--------|----------------|
| **No critic** | Cuts memory in half — critical for long contexts |
| **Group comparison** | Works with sparse rewards (exact match, task success) |
| **Sample efficient** | Multiple samples from same input = more signal |

### GRPO vs. PPO

| Feature | PPO | GRPO |
|---------|-----|------|
| **Value model** | Required | Not needed |
| **Memory usage** | 2× policy size | 1× policy size |
| **Reward type** | Works best with dense rewards | Works with sparse rewards |
| **Baseline** | Learned critic | Group mean |
| **Complexity** | Higher | Lower |

---

## Part 3: How MemFactory Uses GRPO for Memory

### The Training Loop

```
1. SAMPLE: Environment provides a task (e.g., "answer questions using memory")

2. ROLLOUT: Agent generates G different memory strategies:
   - Strategy 1: Retrieve all memories, then answer
   - Strategy 2: Retrieve only recent memories
   - Strategy 3: Don't retrieve, answer directly
   - ...

3. REWARD: Environment evaluates each strategy:
   - Did the answer match the ground truth?
   - Was the format correct?
   - Did retrieval help?

4. GRPO UPDATE: Compute advantages, update policy to favor good strategies

5. REPEAT: Train until convergence
```

### Results

| Model | Test Set | Base Score | MemFactory Score | Improvement |
|-------|----------|------------|------------------|-------------|
| Qwen3-1.7B | eval_50 | 57.5 | 67.5 | +17.4% |
| Qwen3-1.7B | eval_100 | 52.5 | 63.0 | +20.0% |
| Qwen3-4B | eval_50 | 73.0 | 78.0 | +6.8% |
| Qwen3-4B | OOD | 45.0 | 48.0 | +6.7% |

**Key finding:** GRPO successfully trains memory policies that generalize to out-of-distribution tasks.

---

## Summary: The Two Key Concepts

### 1. MemFactory

> A **Lego-like framework** for building memory-augmented agents. Breaks memory into atomic operations (Extract, Update, Retrieve) that can be mixed, matched, and optimized.

### 2. GRPO (Group Relative Policy Optimization)

> An RL algorithm that **eliminates the critic model** by comparing responses within groups. Perfect for memory agents with limited compute and sparse rewards.

```
GRPO in one line:
"Sample multiple responses, compare rewards within the group,
reinforce above-average responses."
```

---

## Citation

```bibtex
@article{memfactory2026,
  title={MemFactory: Unified Inference \& Training Framework for Agent Memory},
  journal={arXiv preprint arXiv:2603.29493},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insights to remember:**

1. **MemFactory = LLaMA-Factory for memory agents**
   - Modular, plug-and-play components
   - Standardizes the fragmented memory-RL ecosystem

2. **GRPO = PPO without the critic**
   - Cuts memory requirements in half
   - Works by comparing responses within groups
   - Perfect for sparse rewards (task success/failure)

3. **Memory agents need RL**
   - Heuristic rules don't scale
   - RL lets agents learn *when* and *what* to remember

**Connections to my work:**
- Research assistants could benefit from learned memory policies
- Long-context analysis tasks need efficient memory management
- GRPO's efficiency makes it practical for my hardware constraints

**The formula to remember:**
$$\hat{A}_i = \frac{r_i - \text{mean}(r_1, \ldots, r_G)}{\text{std}(r_1, \ldots, r_G)}$$

"Your advantage is how much better you are than the group average, normalized by group variance."
