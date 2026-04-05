---
title: "Active Inference & Markov Decision Processes"
date: 2026-03-25
topic: "Computational Neuroscience & Decision Theory"
category: "Theoretical Methods"
tags: ["active-inference", "mdp", "free-energy", "bayesian-inference", "decision-making"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Active Inference & Markov Decision Processes

**Research Date:** 2026-03-25  
**Sources:** pymdp (arXiv:2201.03904), Friston et al.

---

## 1. Markov Decision Processes (MDP)

### Definition

An MDP is a mathematical framework for sequential decision-making defined by:
- **States (S):** Possible configurations of the world
- **Actions (A):** Available choices
- **Transitions T(s'|s,a):** Probability of reaching state s' from state s after action a
- **Rewards R(s,a,s'):** Immediate reward for transitions
- **Discount (γ):** Future reward weighting

### Goal

Find a policy π(a|s) that maximizes expected cumulative reward:
```
maximize E[Σ γ^t × R(s_t, a_t, s_{t+1})]
```

### Limitations

| Limitation | Description |
|------------|-------------|
| **Reward hypothesis** | Assumes all goals are scalar rewards |
| **Exploration problem** | No intrinsic motivation; must engineer exploration |
| **Uncertainty** | Doesn't model uncertainty in beliefs |
| **Credit assignment** | Hard to attribute outcomes to actions |

---

## 2. Active Inference

### Core Idea

Active inference replaces reward maximization with **free energy minimization**. Instead of "maximize reward," the agent "minimizes surprise."

### The Free Energy Principle

**Perception:** Update beliefs to match observations
**Action:** Seek observations that match beliefs (predictions)

**Mathematical formulation:**
```
Free Energy F = Complexity - Accuracy
             = D_KL[q(s|o) || p(s)] - E_q[log p(o|s)]
```

### How It Differs from MDP

| Aspect | MDP/RL | Active Inference |
|--------|--------|------------------|
| **Objective** | Maximize reward | Minimize free energy |
| **Exploration** | Engineered (ε-greedy) | Intrinsic (uncertainty minimization) |
| **Rewards** | Scalar external signal | Encoded as prior preferences |
| **Uncertainty** | Often ignored | Central to framework |

### Expected Free Energy (G)

For policy selection, minimize expected free energy:
```
G(π) = Epistemic Value + Pragmatic Value
     = Information Gain + Goal Satisfaction
```

This naturally balances:
- **Exploration:** Seek informative observations
- **Exploitation:** Seek preferred observations

---

## 3. pymdp Library

**GitHub:** https://github.com/infer-actively/pymdp  
**Paper:** arXiv:2201.03904

### Core Components

| Component | Symbol | Description |
|-----------|--------|-------------|
| **A matrix** | p(o\|s) | Observation model |
| **B matrix** | p(s'\|s,a) | Transition model |
| **C vector** | p(o) | Prior preferences (goals) |
| **D vector** | p(s₀) | Initial state prior |

### Basic Usage

```python
from pymdp import Agent

agent = Agent(A=A, B=B, C=C, D=D)

# Perception: update beliefs
qs = agent.infer_states([observation])

# Action: select action
action = agent.sample_action()
```

---

## 4. Astrophysical Applications

### Where Active Inference Might Help

| Application | Why Active Inference? |
|-------------|----------------------|
| **Adaptive telescope scheduling** | Balance information gain with observation goals |
| **Autonomous spacecraft** | Intrinsic exploration + mission objectives |
| **Transient detection** | Minimize uncertainty about transient type |
| **Survey optimization** | Explore efficiently with prior knowledge |

### Potential Use Cases

#### 1. Adaptive Telescope Scheduling
- States: Sky conditions, target visibility
- Observations: Seeing, weather data
- Preferences: High-priority observations
- Agent balances: Exploring conditions + exploiting good seeing

#### 2. Transient Follow-up Decisions
- States: Transient type, light curve stage
- Observations: Photometry, spectra
- Preferences: Catch real transients early
- Agent minimizes uncertainty about classification

#### 3. MUST Survey Strategy
- States: Fiber availability, sky brightness
- Observations: Image quality, previous measurements
- Preferences: Complete survey, high S/N
- Agent explores uncertain regions while meeting targets

### Limitations for Astrophysics

| Challenge | Why Difficult |
|-----------|---------------|
| **Continuous states** | pymdp handles discrete states only |
| **Large state spaces** | Exponential complexity |
| **Complex physics** | Hard to specify generative model |
| **Rare events** | Active inference assumes stationary statistics |

---

## 5. Summary

### When to Use Active Inference

✅ **Good for:**
- Problems requiring exploration-exploitation balance
- When uncertainty quantification is important
- When rewards are hard to define
- Multi-objective optimization

❌ **Not ideal for:**
- Continuous state/action spaces (discrete only)
- Very large state spaces
- When rewards are well-defined and single-objective
- Real-time requirements with complex models

### For Astrophysics

**Most promising:** Autonomous systems where exploration and multiple objectives matter (telescope scheduling, spacecraft operations)

**Less promising:** Traditional data analysis where MDP/RL or standard optimization suffices

---

## 6. Resources

- **pymdp:** https://github.com/infer-actively/pymdp
- **Paper:** Heins et al. (2022), arXiv:2201.03904
- **Tutorials:** https://github.com/infer-actively/pymdp/tree/master/examples

---

*Report compiled by Yuzhe | Date: 2026-03-25*
