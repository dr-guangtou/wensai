---
title: Agentic Code Reasoning
authors:
  - Shubham Ugare
  - et al.
source: "arXiv:2603.01896v1"
tags:
  - paper
  - ai/llm
  - ai/agent
  - dev/tool
date_published: 2026-03
date_read: 2026-03-04
type: paper_summary
category: ai
venue: "Preprint (Software Engineering, LLM Agents)"
---
# Agentic Code Reasoning

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Agentic Code Reasoning |
| **arXiv ID** | 2603.01896v1 |
| **Authors** | Shubham Ugare et al. |
| **Institution** | Multiple |
| **Type** | Methods + Experiments |

---

## The Big Question

**Can LLM agents understand code semantics WITHOUT executing it?**

This matters because:
- Running tests is expensive (sandbox setup, dependencies, time)
- Some environments can't be executed (security, legacy systems)
- You want quick feedback in RL training pipelines

---

## The Core Contribution: Semi-Formal Reasoning

### The Problem with Current Approaches

| Approach | Problem |
|----------|---------|
| **Unstructured reasoning** | Agent can make claims without evidence → guesses, skips cases |
| **Fully formal verification** | Requires translating code to Lean/Coq → impractical for real repositories |

### The Solution: Semi-Formal Reasoning

**Key idea:** Force the agent to fill in a **structured template** that acts as a "certificate" — the agent must state premises, trace execution paths, and derive formal conclusions.

**This is NOT formal verification** — it's still natural language. But the structure prevents the agent from:
- Skipping edge cases
- Making unsupported claims
- Guessing function behavior instead of tracing

---

## The Motivating Example (Django Bug)

**Task:** Are these two patches equivalent?

```python
# Patch 1
def y(self):
    return format(self.data.year, "04d")[-2:]

# Patch 2  
def y(self):
    return '%02d' % (self.data.year % 100)
```

### Standard Reasoning (WRONG)

> "Both patches produce identical output: `format(476, '04d')[-2:] = '76'` and `'%02d' % 76 = '76'`"

**Why it failed:** Assumed `format()` is Python's built-in.

### Semi-Formal Reasoning (CORRECT)

The structured template forces the agent to trace:

> "... grep -n 'def format' dateformat.py → line 340: module-level `format()` shadows Python builtin. This function expects a datetime, not int. `format(476, '04d')` raises `AttributeError`. ..."

**Key difference:** Semi-formal forced the agent to actually look up the function definition rather than assume.

---

## The Semi-Formal Template

For patch equivalence, the template looks like:

```
DEFINITIONS:
D1: Two patches are EQUIVALENT MODULO TESTS iff
    the test suite produces identical pass/fail
    outcomes for both patches.

PREMISES (state what each patch does):
P1: Patch 1 modifies [file(s)] by [change]
P2: Patch 2 modifies [file(s)] by [change]
P3: The FAIL_TO_PASS tests check [behavior]

ANALYSIS OF TEST BEHAVIOR:
For each test:
  Claim: With Patch 1, test [name] will [PASS/FAIL]
         because [execution trace]
  Claim: With Patch 2, test [name] will [PASS/FAIL]
         because [execution trace]
  Comparison: [SAME/DIFFERENT] outcome

COUNTEREXAMPLE (if NOT EQUIVALENT):
  Test [name] produces different outcomes because
  [specific code trace evidence]

FORMAL CONCLUSION:
By D1, since test outcomes are [IDENTICAL/DIFFERENT],
patches are [EQUIVALENT/NOT EQUIVALENT].
```

**The key:** Every bracketed field must be filled with evidence gathered from the codebase.

---

## Three Tasks Evaluated

### Task 1: Patch Equivalence

**Question:** Given two patches addressing the same bug, do they produce the same test outcomes?

**Ground truth:** Actually running the tests.

**Results (Curated challenging examples):**

| Method | Accuracy |
|--------|----------|
| Standard reasoning | 78% |
| **Semi-formal reasoning** | **88%** |

**Results (Real-world agent patches with test specs):**

| Method | Accuracy |
|--------|----------|
| difflib similarity (threshold 0.4) | 73% |
| Single LLM call | 80% |
| Single LLM + file context | 87% |
| Standard agentic | 86% |
| **Semi-formal agentic (Opus-4.5)** | **93%** |

**Why it matters:** 93% accuracy means you can use this as an **execution-free reward signal** for RL training pipelines — no sandbox needed.

### Task 2: Fault Localization (Defects4J)

**Question:** Given a failing test, find the buggy lines.

**Ground truth:** Known bug locations in the dataset.

**Results (100 bugs):**

| Method | Top-5 Accuracy |
|--------|---------------|
| Standard agentic | 58% |
| **Semi-formal agentic** | **63%** (+5pp) |

**Error modes identified:**
1. Indirection bugs (bug in class not directly called)
2. Multi-file bugs (need to find all locations)
3. Domain-specific bugs (e.g., numerical analysis)
4. Too many fix regions (>5)

### Task 3: Code Question Answering (RubberDuckBench)

**Question:** Answer nuanced questions about code behavior.

**Ground truth:** Expert-written rubrics, graded by LLMs.

**Results:**

| Method | Accuracy (Opus-4.5) |
|--------|--------------------|
| Single-shot | 76% |
| Standard agentic | 78% |
| **Semi-formal agentic** | **87%** |

---

## Why Does Semi-Formal Help?

### 1. Prevents Skipping Cases

Standard reasoning: "I think these patches are equivalent."

Semi-formal: "I must list EVERY test and trace its behavior."

### 2. Forces Evidence Gathering

Standard reasoning: "This function probably does X."

Semi-formal: "I must trace the function call and show the actual code."

### 3. Encourages Interprocedural Reasoning

Tracing program paths requires following function calls → deeper analysis.

---

## Agentic vs. Single-Shot

| Aspect | Single-Shot | Agentic |
|--------|-------------|---------|
| **Context** | Static snapshot | Can explore codebase |
| **Tools** | None | Bash tools (grep, read files) |
| **Steps** | 1 | Up to 100 |
| **Code execution** | No | No (static analysis only) |
| **Accuracy** | Lower | Higher |

**Key insight:** Many verification tasks require exploring code beyond the immediate patch. Single-shot can't do this.

---

## Practical Applications

### 1. RL Training Pipelines

**Problem:** Training code agents requires running tests as reward signal → expensive sandbox execution.

**Solution:** Use semi-formal verification as **execution-free reward** — 93% accurate.

### 2. Code Review

**Problem:** Human review is slow and expensive.

**Solution:** Semi-formal agent can verify if two implementations are equivalent.

### 3. Static Analysis Alternative

**Problem:** Traditional static analysis tools are language-specific and hard to extend.

**Solution:** Prompt LLM agents with task-specific reasoning templates — generalizes across languages.

---

## The Three Primary Failure Modes

Even with semi-formal reasoning, some errors remain:

| Failure Mode | Description | Example |
|--------------|-------------|---------|
| **Incomplete tracing** | Assumes function behavior without tracing | Misses a shadowed definition |
| **Third-party libraries** | Guesses from function names when source unavailable | Misunderstands a library call |
| **Dismissing subtle differences** | Identifies difference but concludes irrelevant | Doesn't realize edge case matters |

---

## Key Insights

### 1. Structure > Smarts

The same model (Opus-4.5) goes from 78% to 88% accuracy just from adding structure to the reasoning template.

### 2. Agentic Exploration Matters

Single-shot reasoning is limited — you need to explore the codebase to understand dependencies.

### 3. Semi-Formal is Practical

Unlike formal verification (Lean/Coq), semi-formal reasoning works on arbitrary repository code without translation.

### 4. Near-Production Ready

93% accuracy on patch equivalence is approaching what you'd need for production RL pipelines.

---

## Comparison Table: Approaches to Code Verification

| Approach | Execution? | Formal? | Scalable? | Accuracy |
|----------|------------|---------|-----------|----------|
| Run tests | Yes | N/A | Expensive | 100% |
| Formal verification | No | Yes | Limited | 100%* |
| LLM unstructured | No | No | Yes | 78% |
| **LLM semi-formal** | No | Semi | Yes | **88-93%** |

*When it works at all

---

## What This Means for You

### For Your AI Workflow

**1. Better Code Review**
- When reviewing AI-generated code, ask for structured reasoning
- Template: "List your premises, trace execution, state conclusion"

**2. Verification Without Execution**
- Can verify if two implementations are equivalent without running tests
- Useful when execution environment is unavailable/expensive

**3. Debugging Assistance**
- Semi-formal structure helps AI debug more systematically
- Forces tracing rather than guessing

### For Your Research

**1. Scientific Code Verification**
- Are two analysis pipelines equivalent?
- Did my optimization change the output?

**2. Data Processing Pipelines**
- Are two data reduction scripts equivalent?
- Did my refactor introduce bugs?

**3. Documentation Generation**
- Semi-formal reasoning naturally produces detailed explanations
- Could generate "proof certificates" for analysis steps

---

## Summary

| Aspect | Standard Reasoning | Semi-Formal Reasoning |
|--------|-------------------|----------------------|
| **Structure** | Free-form | Template-based |
| **Evidence** | Optional | Required |
| **Tracing** | Often skipped | Forced |
| **Accuracy** | 78% | 88-93% |
| **Cost** | Lower | ~2.8× more steps |

**The key insight:** Structure forces thoroughness. The same model performs significantly better when forced to fill in a structured template with explicit evidence.

---

## Citation

```bibtex
@article{ugare2026agentic,
  title={Agentic Code Reasoning},
  author={Ugare, Shubham and others},
  journal={arXiv preprint arXiv:2603.01896},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> Structured reasoning templates dramatically improve LLM code analysis accuracy (78% → 88-93%) by forcing the agent to gather explicit evidence rather than guess. This works on arbitrary codebases without formal verification overhead.

**What surprised me:**
- The same model gains 10+ percentage points just from structured prompting
- 93% accuracy approaches what's needed for production RL pipelines
- Agentic exploration is essential — single-shot doesn't work for complex verification

**Connections to my work:**
1. **Code review:** Could use semi-formal templates when reviewing student code
2. **Pipeline verification:** Verify that refactored analysis scripts are equivalent
3. **Documentation:** Semi-formal reasoning could generate detailed analysis documentation

**Questions to explore:**
- [ ] Could semi-formal templates help verify scientific analysis pipelines?
- [ ] What would a semi-formal template for astronomy data analysis look like?
- [ ] Could this approach verify that MUST data reduction steps are correct?

**Practical takeaway:** When asking AI to analyze or verify code, provide a structured template that requires explicit evidence rather than allowing free-form reasoning.
