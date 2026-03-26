---
title: "Even GPT-5.2 Can't Count to Five: Zero-Error Horizons for Trustworthy LLMs"
authors:
  - Ryoma Sato
source: arXiv:2601.15714v1
date_published: 2026-01-22
date_read: 2026-03-25
type: paper_summary
category: ai
venue: Preprint (AI Safety, Evaluation)
tags:
  - zero-error-horizon
  - llm-evaluation
  - ai-safety
  - trustworthiness
  - capability-holes
---

# Zero-Error Horizon: Can We Trust LLMs?

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Even GPT-5.2 Can't Count to Five: The Case for Zero-Error Horizons in Trustworthy LLMs |
| **arXiv ID** | 2601.15714v1 |
| **Author** | Ryoma Sato |
| **Type** | Concept + Analysis |

---

## The Shocking Observation

**GPT-5.2 is remarkably capable.** It can:
- Write complex fluid dynamics simulation code
- Analyze scientific papers
- Generate sophisticated legal arguments

**But GPT-5.2 also fails on incredibly simple problems:**

| Task | Example | GPT-5.2's Answer | Correct Answer |
|------|---------|-----------------|----------------|
| **Parity** | How many 1s in "11000"? | Odd (1) | Even (2) |
| **Balanced parentheses** | Is "((((())))))" balanced? | Yes | No |
| **Multiplication** | 127 × 82 = ? | Wrong | 10,414 |

**Try it yourself!** These are reproducible failures, not random flukes.

---

## The Core Concept: Zero-Error Horizon (ZEH)

### The Simple Definition

> **Zero-Error Horizon (ZEH)** = The largest problem size where a model gets EVERYTHING right.

**Example for multiplication:**
- GPT-5.2 correctly answers all multiplications where both numbers ≤ 126
- But makes an error on 127 × 82
- **ZEH = 126**

**Example for parity:**
- GPT-5.2 correctly computes parity for strings up to 4 characters
- But fails on "11000" (5 characters)
- **ZEH = 4**

### Why ZEH Matters

| Accuracy | ZEH |
|----------|-----|
| "99.8% of problems correct" | "Guaranteed correct up to size N" |
| Might miss rare failures | No failures possible below ZEH |
| Scale is chosen by evaluator | Scale is determined by the model |
| Doesn't tell you WHERE it fails | Gives you the exact boundary |

---

## Visual: Accuracy vs. ZEH

```
Accuracy approach:
┌────────────────────────────────────────────────┐
│ Test on random sample → 99.8% accurate         │
│ But WHERE are the 0.2% errors? Unknown.        │
│ Could be on 1+1, could be on 99×99.            │
└────────────────────────────────────────────────┘

ZEH approach:
┌────────────────────────────────────────────────┐
│  1×1 ✓    2×2 ✓    3×3 ✓    ...  126×127 ✓    │
│                                                │
│  ═══════════════════════════════════►         │
│                                                │
│  SAFE ZONE (ZEH = 126)                         │
│                                                │
│  127×82 ✗  ← First error found!                │
└────────────────────────────────────────────────┘
```

---

## GPT-5.2's ZEH Values

| Task | ZEH | Failure Example |
|------|-----|-----------------|
| **Parity** | 4 | "11000" → wrong parity |
| **Balanced parentheses** | 10 | "((((())))))" → says balanced |
| **Multiplication** | 126 | 127 × 82 → wrong answer |
| **Graph coloring** | ~5 | 6-node graphs → wrong chromatic number |

**The surprise:** GPT-5.2 can write fluid dynamics code but can't count to five reliably!

---

## Why This Is Different from "Hallucinations"

| Hallucinations | ZEH Failures |
|----------------|--------------|
| Complex, edge-case scenarios | Simple, basic tasks |
| Out-of-distribution inputs | Common, in-distribution inputs |
| "The model made something up" | "The model made a careless mistake" |
| Expected at frontier | Surprising on basics |

**The key insight:** These aren't "hallucinations" — they're more like **careless mistakes** a student might make despite knowing the material.

---

## What ZEH Reveals About LLMs

### Finding 1: Memorization vs. Algorithms

**Small models:** Rely on memorization
- Errors are random "holes"
- ZEH stays low even if accuracy is high
- Correlation with training data frequency

**Large models:** Use algorithmic reasoning
- Errors become "structured" (like human arithmetic mistakes)
- ZEH grows with model size
- Errors concentrate on "hard" instances (many carries)

### Finding 2: Structured Errors

When large models fail, their errors look "reasonable":

| Model | Error on 34 × 29 = 986 | Type |
|-------|----------------------|------|
| 0.5B | Answers "2" | Doesn't understand task |
| 1.5B | Answers "42" (confused with 2×21) | Confusion |
| 32B | Answers "1006" (off by 20) | Carry mistake |

**The 32B error looks like a human arithmetic mistake!** This suggests it's actually computing, not just guessing.

### Finding 3: Emergence of Algorithmic Capability

ZEH helps detect when models transition from:
- **Memorizing answers** → **Understanding algorithms**

Evidence:
- Small models: High correlation with training data frequency
- Large models: Low correlation, errors concentrate on "hard" problems (carries)

---

## Why ZEH Is Useful

### 1. Safety Guarantees

| Question | Accuracy | ZEH |
|----------|----------|-----|
| "Can I trust this for multiplication?" | "99.8% accurate" | "Safe up to 126×126" |
| "What should I worry about?" | "Don't know" | "Don't exceed 127 in calculations" |

### 2. Warning Signals

Even if multiplication isn't the main task:
- Complex reasoning may involve intermediate calculations
- If those calculations exceed ZEH, errors propagate
- LLMs exhibit "self-delusion" — errors corrupt subsequent reasoning

### 3. Concrete Evidence (ZEH Limiters)

ZEH always comes with a **concrete failure example**:

> "GPT-5.2's ZEH is at most 126 because it fails on 127 × 82."

You can verify this yourself. This is:
- Mathematically rigorous
- Scientifically reproducible
- Communicatively convincing

### 4. No Scale Arbitrariness

**Accuracy problem:** You choose the test range (e.g., "up to 99×99")
- Researcher could cherry-pick range to make method look good
- "99.8% on 99×99" might hide errors on 2×3

**ZEH solution:** The model determines the boundary, not the evaluator
- No human preconceptions about "reasonable" range
- Objective, comparable across studies

### 5. Never Obsoletes

| Fixed benchmarks (GLUE, MMLU, etc.) | ZEH |
|--------------------------------------|-----|
| Eventually saturate | Always meaningful |
| Become useless for SOTA models | Continues measuring progress |
| Need new benchmarks | Just grows with model capability |

---

## Practical Guidelines from ZEH

### For Qwen2.5 Models

| Model | Multiplication ZEH | Trust Level |
|-------|-------------------|-------------|
| 0.5B | ~0 | Don't trust at all |
| 1.5B | ~20 | Single digits only |
| 3B | ~20 | Single digits only |
| 7B | ~22 | Up to ~20 |
| 14B | ~27 | Up to ~25 |
| 32B | ~33 | Up to ~30 |
| 72B | ~42 | Up to ~40 |

### For Safety-Critical Applications

1. **Measure ZEH with multiple prompts** — use the lowest value
2. **Add safety margin** — don't operate right at the boundary
3. **Watch for intermediate calculations** — complex reasoning may exceed ZEH
4. **Use external tools** — calculators, formal verifiers for critical steps

---

## The Deeper Lesson

> **High average performance ≠ Reliability**

LLMs can be:
- Brilliant at complex tasks
- Incompetent at simple ones

This is a **fundamental issue** for safety-critical domains:
- Healthcare: Might diagnose correctly but miscalculate dosage
- Finance: Might analyze markets correctly but make arithmetic errors
- Engineering: Might design systems correctly but fail on basic checks

**The lesson:** Don't assume LLMs are reliable just because they seem smart.

---

## Summary: The Three Key Ideas

### 1. The Observation
> Even the most advanced LLMs (GPT-5.2) fail on incredibly simple problems — counting, parentheses, basic multiplication.

### 2. The Metric
> **Zero-Error Horizon (ZEH)** = Largest problem size where the model gets EVERYTHING right. It's the boundary between "guaranteed safe" and "might fail."

### 3. The Implication
> ZEH provides safety guarantees that accuracy cannot. For safety-critical domains, know your model's ZEH before trusting it.

---

## Citation

```bibtex
@article{sato2026zeh,
  title={Even GPT-5.2 Can't Count to Five: The Case for Zero-Error Horizons in Trustworthy LLMs},
  author={Sato, Ryoma},
  journal={arXiv preprint arXiv:2601.15714},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> High average accuracy doesn't mean reliability. ZEH measures the "guaranteed safe" boundary — problems the model can solve with certainty. Even GPT-5.2 has ZEH = 4 for parity and ZEH = 126 for multiplication.

**What surprised me:**
- GPT-5.2 can write fluid dynamics code but fails on 5-character parity
- These aren't hallucinations — they're more like careless mistakes
- ZEH limiters provide concrete, verifiable evidence
- The transition from memorization → algorithms is visible through error patterns

**Connections to my work:**
1. **Data analysis pipelines:** Intermediate calculations in complex analyses could exceed ZEH
2. **Telescope operations:** Don't trust LLMs for critical calculations without verification
3. **Scientific computing:** Use external tools for arithmetic in LLM-assisted coding

**Questions to explore:**
- [ ] What's the ZEH for astronomical calculations?
- [ ] How does ZEH vary across different types of reasoning?
- [ ] Could ZEH be used to decide when to call external tools?
- [ ] What's the ZEH for code generation vs. natural language?

**Practical takeaway:** Before using LLMs in any domain where mistakes matter, measure the ZEH for the building-block operations involved. Complex reasoning is only as reliable as its weakest link.
