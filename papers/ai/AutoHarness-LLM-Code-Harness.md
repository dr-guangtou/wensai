---
title: "AutoHarness: Improving LLM Agents by Automatically Synthesizing a Code Harness"
authors:
  - Xinghua Lou
  - Miguel Lázaro-Gredilla
  - Antoine Dedieu
  - et al.
affiliations:
  - Google DeepMind
source: arXiv:2603.03329v1
date_published: 2026-03-05
date_read: 2026-03-13
type: paper_summary
category: ai
venue: Preprint (AI Agents, Code Synthesis)
tags:
  - llm-agents
  - code-harness
  - game-playing
  - code-synthesis
  - test-time-compute
---

# AutoHarness: LLMs Writing Their Own Guardrails

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | AutoHarness: improving LLM agents by automatically synthesizing a code harness |
| **arXiv ID** | 2603.03329v1 |
| **Authors** | Lou, Lázaro-Gredilla, Dedieu et al. (Google DeepMind) |
| **Type** | Methods + Experiments |

---

## First: What is a "Harness"?

This is the key concept you asked about, so let's start here.

### The Simple Definition

> **A harness is the "glue" or "plumbing" that connects an LLM to the outside world.**

When you use an LLM as an **agent** (not just a chatbot), you need something that:
1. Takes the LLM's output
2. Checks if it's valid
3. Executes it in the environment
4. Feeds the result back to the LLM

**That "something" is the harness.**

### A Concrete Example: Chess

**Without a harness:**
```
LLM → "I move my knight to... um... e5?" → Game engine
                                            ↓
                                      ERROR: Illegal move!
                                            ↓
                                      Game over, you lose.
```

**With a harness:**
```
LLM → "I move to e5"
        ↓
    ┌─────────────────────────────────┐
    │         HARNESS                 │
    │                                 │
    │  1. Is "e5" a legal move?       │
    │     → Check game rules          │
    │                                 │
    │  2. If NO: Reject, ask LLM again│
    │     If YES: Execute in game     │
    │                                 │
    └─────────────────────────────────┘
        ↓
    Valid move → Game engine → Continue game
```

### Why "Harness"?

The term comes from software testing, where a **test harness** is code that:
- Sets up the environment
- Runs the code being tested
- Captures outputs
- Reports results

In LLM agents, the harness plays the same role: it **wraps around** the LLM and manages its interaction with the world.

### Types of Harnesses

| Type | What It Does | Example |
|------|--------------|---------|
| **Validator** | Checks if LLM output is valid | "Is this a legal chess move?" |
| **Filter** | Rejects bad outputs, asks for new ones | "Try again, that's not allowed" |
| **Translator** | Converts LLM output to environment format | "Convert 'move knight' to 'e2e4'" |
| **Policy** | Replaces LLM entirely with code | `if board.empty(x): return x` |

### The Problem This Paper Addresses

**The standard approach:** Humans manually write harnesses.

**Why that's bad:**
- Labor-intensive (new harness for every game/task)
- Brittle (breaks when game rules change)
- Requires programming expertise

**This paper's solution:** Have the LLM **write its own harness** automatically.

---

## The Core Problem: LLMs Make Illegal Moves

### The Motivating Statistic

> In the recent Kaggle GameArena chess competition, **78% of Gemini-2.5-Flash losses were due to illegal moves** — not strategic blunders.

The LLM "knows" chess rules in some sense, but still outputs invalid moves because:
- It doesn't have perfect internal state tracking
- It can't reliably verify its own outputs
- It's trained on text, not strict rule-following

### The Disconnect

LLMs are good at:
- Understanding game rules (from training data)
- Strategic reasoning (in a fuzzy sense)

LLMs are bad at:
- Following strict rules exactly
- Validating their own outputs
- Maintaining perfect state

**The harness bridges this gap.**

---

## AutoHarness: The Solution

### The Key Insight

> If LLMs are good at writing code, why not have them write the harness?

Instead of a human writing code to validate chess moves, have the LLM write that code.

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTOHARNESS PIPELINE                     │
└─────────────────────────────────────────────────────────────┘

1. INITIAL CODE
   LLM generates initial harness code:
   ```
   def is_legal_action(observation, action):
       # Initial guess - let's see if it works
       return True  # Accept everything
   ```

2. TEST IN ENVIRONMENT
   Run the harness + LLM in actual games
   ↓
   Harness accepts an illegal move → Game crashes

3. GET FEEDBACK
   Environment says: "Error: Move e2e5 is not legal in this position"

4. REFINE CODE
   LLM updates harness:
   ```
   def is_legal_action(observation, action):
       # Check if piece exists at start square
       # Check if destination is valid
       # Check if move follows piece rules
       ...
   ```

5. REPEAT
   Keep testing and refining until 100% legal moves

```

### The Search Process

The paper uses **tree search with Thompson sampling** to explore different harness implementations:

```
                    ┌─────────────┐
                    │ Version 1   │ → 45% legal
                    └─────────────┘
                          │
          ┌───────────────┼───────────────┐
          ↓               ↓               ↓
    ┌──────────┐   ┌──────────┐   ┌──────────┐
    │Version 2a│   │Version 2b│   │Version 2c│
    │  67%     │   │  52%     │   │  78%     │
    └──────────┘   └──────────┘   └──────────┘
          │
    ┌─────┴─────┐
    ↓           ↓
┌────────┐ ┌────────┐
│Ver 3a  │ │Ver 3b  │
│  89%   │ │  82%   │
└────────┘ └────────┘
    │
    ↓
┌────────┐
│Ver 4   │
│ 100%   │ ← SUCCESS!
└────────┘
```

**Key point:** The search balances exploring new approaches vs. refining promising ones.

---

## Three Types of Harnesses

### 1. Harness-as-Action-Filter

```
┌─────────────────────────────────────────────────────────┐
│  HARNESS (Action Filter)                                │
│                                                         │
│  def propose_action(observation):                       │
│      # Code generates list of CANDIDATE legal moves     │
│      return ["e2e4", "d2d4", "g1f3", ...]              │
│                                                         │
│  → LLM picks from candidates ←                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Role:** Code proposes valid options, LLM chooses among them.

### 2. Harness-as-Action-Verifier

```
┌─────────────────────────────────────────────────────────┐
│  HARNESS (Action Verifier)                              │
│                                                         │
│  while True:                                            │
│      action = LLM.propose(observation)                  │
│      if is_legal_action(action):                        │
│          return action  # Accept                        │
│      else:                                              │
│          observation += "That was illegal, try again"   │
│          # Ask LLM again with feedback                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Role:** LLM proposes, code validates. Invalid → try again.

### 3. Harness-as-Policy (Extreme Case)

```
┌─────────────────────────────────────────────────────────┐
│  HARNESS (Full Policy)                                  │
│                                                         │
│  def choose_action(observation):                        │
│      # Pure code - NO LLM CALLS AT RUNTIME              │
│      if can_win_immediately():                          │
│          return winning_move()                          │
│      elif opponent_can_win():                           │
│          return blocking_move()                         │
│      else:                                              │
│          return heuristic_best_move()                   │
│                                                         │
│  → No LLM needed at decision time ←                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Role:** Code replaces LLM entirely. Zero inference cost at runtime.

---

## Results

### Harness-as-Action-Verifier

**Task:** 145 games from TextArena (Chess, Checkers, Blackjack, Sudoku, etc.)

**Training:**
- Average: 14.5 iterations to reach 100% legal moves
- 19/32 games learned in <10 iterations
- Hardest games: GermanWhist (43), Chess (64), Othello (62)

**Outcome:** 100% legal move accuracy on ALL 145 games

### Playing Performance

**2-player games (Gemini-2.5-Flash + Harness vs. Gemini-2.5-Pro):**

| Metric | Result |
|--------|--------|
| Games won by Flash+Harness | 9/16 |
| Win rate | 56.3% |
| Pro win rate | 38.2% |

**1-player games (average reward):**

| Agent | Average Reward |
|-------|----------------|
| Gemini-2.5-Flash | 0.673 |
| Gemini-2.5-Pro | 0.707 |
| **Flash + Harness** | **0.745** |

**Key finding:** A smaller model with a good harness beats a larger model without one.

### Harness-as-Policy (Extreme)

**Task:** 16 one-player games

**Training:** Up to 256 iterations, heuristic includes game reward

| Agent | Average Reward | Test Cost |
|-------|----------------|-----------|
| GPT-5.2 | 0.635 | ~$640 |
| Gemini-2.5-Pro | 0.707 | Moderate |
| GPT-5.2-High | 0.844 | Very high |
| **Harness-as-Policy** | **0.870** | **~$0** |

**Key finding:** Pure code (no LLM at runtime) achieves best performance at zero inference cost.

---

## Why This Matters

### 1. Cost Efficiency

| Approach | Cost |
|----------|------|
| Use GPT-5.2-High for every move | ~$640 for eval |
| Use Gemini-Flash + auto-harness | Small one-time training cost |
| Use Harness-as-Policy | **$0 at inference** |

### 2. Smaller Models Can Beat Larger Ones

> Gemini-2.5-Flash + AutoHarness beats Gemini-2.5-Pro

The harness compensates for the smaller model's weaknesses.

### 3. Automatic → Scalable

- No human harness writing required
- Works on any game with defined rules
- Adapts to new environments automatically

### 4. Code is Verifiable

LLM outputs are fuzzy and hard to validate. Code can be:
- Tested exhaustively
- Verified against rules
- Debugged when it fails

---

## The "Harness" Concept in Other Contexts

You'll see this term in many AI agent papers. Here's a quick reference:

| Context | What "Harness" Means |
|---------|---------------------|
| **Game playing** | Code that validates moves |
| **Code execution** | Sandbox that runs LLM-generated code safely |
| **Web browsing** | Code that handles HTTP requests, parses responses |
| **Tool use** | Code that translates LLM outputs to tool inputs |
| **Robotics** | Code that converts LLM commands to motor controls |

**General pattern:**
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│    LLM ←──────→ HARNESS ←──────→ ENVIRONMENT            │
│                  (glue)                                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Summary: The Two Key Ideas

### 1. What is a Harness?

> The **harness** is the code that wraps around an LLM to:
> - Validate its outputs
> - Translate between formats
> - Handle retries on failure
> - Manage interaction with the environment

**Analogy:** If the LLM is the "brain" making decisions, the harness is the "nervous system" connecting the brain to the body (environment).

### 2. AutoHarness Contribution

> Instead of humans writing harnesses, **have the LLM write its own harness** through iterative trial-and-error with environment feedback.

**Result:** Smaller model + auto-harness beats larger model with no harness.

---

## Citation

```bibtex
@article{lou2026autoharness,
  title={AutoHarness: improving LLM agents by automatically synthesizing a code harness},
  author={Lou, Xinghua and L{\'a}zaro-Gredilla, Miguel and Dedieu, Antoine and others},
  journal={arXiv preprint arXiv:2603.03329},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key concept to remember:**
> A **harness** is the "glue code" that connects an LLM to an environment. It validates outputs, handles failures, and manages the interaction loop. Good harnesses can make smaller models outperform larger ones.

**What surprised me:**
- 78% of chess losses were from illegal moves (not bad strategy!)
- Smaller model + auto-harness beats larger model
- Pure code policy (no LLM at runtime) achieved best results

**Connections to my work:**
1. **Research workflows:** A harness could validate that analysis code follows best practices
2. **Data pipelines:** Harness could verify data transformations are valid
3. **Telescope operations:** Harness could validate commands before execution

**The big picture:**
- LLMs are "creative but unreliable"
- Harnesses are "dumb but reliable"
- Together: creative + reliable = powerful

**Questions to explore:**
- [ ] Could auto-harness work for scientific computing tasks?
- [ ] What would a "harness for data analysis" look like?
- [ ] Could this approach generate valid code for astronomical calculations?
