---
title: "Autoresearch - AI-Driven Autonomous Research Methodology"
date: 2026-03-23
topic: "AI Research Automation"
category: "Research Methods"
tags: ["autoresearch", "karpathy", "ai-agents", "automation", "hyperparameter-tuning", "astrophysics"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Autoresearch - AI-Driven Autonomous Research Methodology

**Research Date:** 2026-03-23  
**Investigation Topic:** Karpathy's Autoresearch and Astrophysical Applications  
**Focus Areas:** Methodology, Results, Astrophysics Adoption

---

## 1. What is Autoresearch?

**Autoresearch** is a methodology where **AI coding agents autonomously run research experiments** — editing code, running experiments, evaluating results, and iterating without human intervention.

**Origin:** Created by Andrej Karpathy (March 2026) as an experiment in fully autonomous AI research.

**The Core Idea:**
> Give an AI agent a real experimental setup and let it run overnight. It modifies code, runs experiments, checks if results improved, keeps or discards changes, and repeats. You wake up to a log of experiments and (hopefully) better results.

---

## 2. How Autoresearch Works

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     HUMAN RESEARCHER                         │
│  - Edits program.md (agent instructions)                    │
│  - Monitors progress                                         │
│  - Reviews final results                                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    AI CODING AGENT                           │
│  (Claude Code, Codex, Cursor, etc.)                         │
│                                                             │
│  Loop:                                                      │
│    1. Read program.md for instructions                      │
│    2. Analyze current results                               │
│    3. Hypothesize improvement                               │
│    4. Edit train.py                                         │
│    5. Run experiment (5 min)                                │
│    6. Compare val_bpb to baseline                           │
│    7. If better → keep changes, commit                      │
│       If worse → revert, try something else                 │
│    8. Repeat until stopped                                  │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                 EXPERIMENT RUNTIME                           │
│  - Fixed time budget (5 minutes)                            │
│  - Single metric: val_bpb (validation bits per byte)        │
│  - All experiments directly comparable                      │
└─────────────────────────────────────────────────────────────┘
```

### Key Files (Karpathy's Setup)

| File | Purpose | Who Edits |
|------|---------|-----------|
| `prepare.py` | Data prep, dataloader, evaluation | ❌ Read-only (fixed) |
| `train.py` | Model, optimizer, training loop | 🤖 Agent modifies this |
| `program.md` | Agent instructions | 👤 Human modifies this |

**The Human's Job:** Program the "research organization" via `program.md`

**The Agent's Job:** Run experiments by modifying `train.py`

---

## 3. Design Principles

### Principle 1: Fixed Time Budget

**All experiments run for exactly 5 minutes** (wall-clock time).

**Why this matters:**
- Experiments are directly comparable regardless of changes
- Finds optimal configuration for YOUR hardware
- No "fair comparison" debates

**Trade-off:** Results not comparable across different compute platforms.

### Principle 2: Single Metric

**Validation bits per byte (val_bpb)** — lower is better.

- Vocab-size-independent
- Architecture-independent
- Single number to optimize

### Principle 3: Single File to Modify

Agent only edits `train.py`. This:
- Keeps scope manageable
- Makes diffs reviewable
- Prevents runaway changes

### Principle 4: Self-Contained

No external dependencies beyond PyTorch. No distributed training. One GPU, one file, one metric.

---

## 4. Results from Original Autoresearch

### Karpathy's Overnight Run

| Metric | Result |
|--------|--------|
| **Duration** | Overnight (~8 hours) |
| **Experiments** | ~100 |
| **Improvement** | 11% reduction in time-to-GPT-2 |
| **Discoveries** | ~20 stacked improvements |

### SkyPilot Scaled Run (16 GPUs)

| Metric | Result |
|--------|--------|
| **Duration** | 8 hours |
| **GPUs** | 16 (13 H100s + 3 H200s) |
| **Experiments** | ~910 submitted, ~700 valid |
| **Throughput** | ~90 experiments/hour (vs ~10 sequential) |
| **Improvement** | val_bpb: 1.003 → 0.974 (2.87% better) |
| **Speedup** | 9× faster than sequential |

### Search Phases (SkyPilot)

| Phase | Experiments | Focus | Δ val_bpb |
|-------|-------------|-------|-----------|
| 1 | 0-200 | Hyperparameter sweeps | 1.003 → 0.981 (-0.022) |
| 2 | 200-420 | Architecture discovery | 0.981 → 0.977 (-0.004) |
| 3 | 420-560 | Fine-tuning wider model | 0.977 → 0.975 (-0.002) |
| 4 | 560-700 | Optimizer tuning | 0.975 → 0.974 (-0.001) |
| 5 | 700-910 | Combinatorial sweeps | < 0.0001 |

**Key insight:** Low-hanging fruit (architecture, hyperparams) picked early. Returns diminish exponentially.

---

## 5. Parallel vs Sequential Search

### Sequential (1 GPU)

```
Time →
[Exp1][wait][Exp2][wait][Exp3][wait]...
       5min       5min       5min

Strategy: Greedy hill-climbing
- Try one thing
- Check result
- Pick direction
- Repeat

Problem: Gets stuck in local optima
```

### Parallel (16 GPUs)

```
Time →
[Exp1][Exp2][Exp3]...[Exp16]  (all 5min)
       ↓
    Results
       ↓
[Exp17][Exp18]...[Exp32]  (all 5min)

Strategy: Factorial grids per wave
- Test 3×4 combinations simultaneously
- Find interaction effects
- Never get stuck on single path

Advantage: 10-13 simultaneous experiments per decision
```

### Emergent Behavior: Heterogeneous Hardware Strategy

When given access to both H100s and H200s, the agent **discovered on its own**:

1. H200s run 9% faster → more training steps → better results
2. Developed two-tier strategy:
   - **Screen** hypotheses on H100s (10+ in parallel)
   - **Validate** winners on H200s (2-3 for confirmation)

**This is human-level research strategy that emerged autonomously.**

---

## 6. Astrophysical Research Applications

### 6.1 Applicable Research Areas

| Area | Current Approach | Autoresearch Approach |
|------|------------------|----------------------|
| **Model fitting** | Manual hyperparameter tuning | Agent explores parameter space |
| **Pipeline optimization** | Trial and error | Systematic search overnight |
| **Algorithm development** | One experiment at a time | Parallel factorial experiments |
| **Feature engineering** | Human intuition | Agent tests combinations |
| **Calibration** | Iterative manual refinement | Autonomous calibration runs |

### 6.2 Specific Astrophysics Use Cases

#### Use Case 1: Photometric Redshift Optimization

**Problem:** Find optimal neural network architecture and hyperparameters for photo-z estimation.

**Autoresearch setup:**
```
train.py:
- Photo-z neural network
- Loss: |z_pred - z_true| / (1 + z_true)
- Dataset: SDSS/DES training set

program.md:
"Optimize photo-z accuracy. Try different architectures, 
learning rates, data augmentations. Keep changes that 
improve validation σ_NMAD."
```

**Expected benefit:** 
- Agent explores architecture/hyperparameter combinations overnight
- Finds optimal config without manual tuning
- ~50-100 experiments per night

#### Use Case 2: Spectral Fitting Pipeline

**Problem:** Optimize stellar population synthesis (SPS) fitting pipeline parameters.

**Autoresearch setup:**
```
train.py:
- SPS fitting code (e.g., Prospector-like)
- Metric: χ² or posterior probability
- Dataset: Galaxy spectra

program.md:
"Optimize SPS fitting parameters: priors, MCMC steps, 
regularization. Maximize posterior on validation galaxies."
```

**Expected benefit:**
- Systematic exploration of prior choices
- Finds optimal MCMC configuration
- Quantifies what parameters matter

#### Use Case 3: Source Detection Algorithm

**Problem:** Optimize source detection thresholding and deblending parameters.

**Autoresearch setup:**
```
train.py:
- Source detection code
- Metric: F1 score on labeled images
- Dataset: Simulated or hand-labeled images

program.md:
"Optimize detection thresholds, deblending parameters, 
minimum pixels. Maximize F1 while minimizing false positives."
```

**Expected benefit:**
- Automated hyperparameter search
- Adapts to specific survey characteristics
- Reproducible optimization

#### Use Case 4: Galaxy Morphology Classification

**Problem:** Find optimal CNN architecture for morphological classification.

**Autoresearch setup:**
```
train.py:
- Galaxy CNN classifier
- Metric: Classification accuracy
- Dataset: Galaxy Zoo labels

program.md:
"Explore CNN architectures, data augmentations, 
regularization techniques. Keep changes that improve 
validation accuracy. Budget: 10 min per experiment."
```

**Expected benefit:**
- Discovers effective augmentations
- Finds optimal depth/width trade-offs
- Tests regularization strategies

#### Use Case 5: Time-Series Analysis Pipeline

**Problem:** Optimize light curve analysis for variable star detection.

**Autoresearch setup:**
```
train.py:
- Period detection code (Lomb-Scargle, etc.)
- Metric: Fraction of known variables recovered
- Dataset: Labeled variable star light curves

program.md:
"Optimize frequency grid, oversampling, significance 
threshold. Maximize recovery of known variables while 
minimizing false positives."
```

#### Use Case 6: Simulation Parameter Calibration

**Problem:** Calibrate cosmological simulation parameters to match observations.

**Autoresearch setup:**
```
train.py:
- Run small simulation
- Compare summary statistics to observations
- Metric: χ² distance

program.md:
"Adjust simulation parameters to minimize distance from 
observed galaxy stellar mass function, correlation 
function. Each simulation run: 5 minutes on 1 GPU."
```

---

## 7. Adapting Autoresearch for Astrophysics

### 7.1 Key Design Choices

| Element | ML Training (Original) | Astrophysics Adaptation |
|---------|------------------------|-------------------------|
| **train.py** | Neural network training | Analysis pipeline |
| **Metric** | val_bpb | Domain-specific (accuracy, χ², etc.) |
| **Time budget** | 5 minutes | Problem-dependent (5-30 min) |
| **program.md** | ML optimization hints | Domain-specific guidance |

### 7.2 Template for Astrophysics Autoresearch

**File structure:**
```
astro-autoresearch/
├── prepare.py        # Data loading, preprocessing (fixed)
├── analyze.py        # Analysis pipeline (agent modifies)
├── program.md        # Agent instructions (you write)
├── data/             # Dataset
├── results/          # Experiment logs
└── pyproject.toml    # Dependencies
```

**program.md template:**
```markdown
# Astrophysics Autoresearch: [PROBLEM NAME]

## Goal
Optimize [METRIC] on [TASK]

## What You Can Modify
- [Parameter 1]: [range]
- [Parameter 2]: [range]
- [Algorithm choice]

## Constraints
- Must complete in [TIME] minutes
- Must not crash
- Results must be reproducible

## Evaluation
Run: uv run analyze.py
Look for: [METRIC NAME] in output
Lower/Higher is better

## Strategy
1. Start with baseline
2. Try small modifications first
3. Keep changes that improve [METRIC]
4. Commit improvements
5. Repeat

## Domain Knowledge
- [Relevant physics constraints]
- [Known good starting points]
- [Things to avoid]
```

### 7.3 Example: Photo-z Autoresearch

**prepare.py:**
```python
# Fixed: data loading, evaluation
import numpy as np
from pathlib import Path

def load_training_data():
    """Load galaxy magnitudes and redshifts."""
    # ... load from files
    return X_train, y_train

def load_validation_data():
    """Load validation set."""
    return X_val, y_val

def evaluate_predictions(z_pred, z_true):
    """Calculate photo-z metrics."""
    dz = (z_pred - z_true) / (1 + z_true)
    sigma_nmad = 1.48 * np.median(np.abs(dz - np.median(dz)))
    outlier_frac = np.sum(np.abs(dz) > 0.15) / len(dz)
    return sigma_nmad, outlier_frac
```

**analyze.py (agent modifies):**
```python
# Agent experiments with this file
import torch
import torch.nn as nn
from prepare import load_training_data, load_validation_data, evaluate_predictions

# ============ AGENT MODIFIES BELOW ============

HIDDEN_DIMS = [256, 128, 64]  # Agent can change
LEARNING_RATE = 0.001         # Agent can change
BATCH_SIZE = 256              # Agent can change
N_EPOCHS = 50                 # Agent can change

class PhotozNet(nn.Module):
    def __init__(self, input_dim, hidden_dims, output_dim=1):
        super().__init__()
        layers = []
        prev_dim = input_dim
        for h_dim in hidden_dims:
            layers.extend([
                nn.Linear(prev_dim, h_dim),
                nn.ReLU(),
                nn.BatchNorm1d(h_dim),
            ])
            prev_dim = h_dim
        layers.append(nn.Linear(prev_dim, output_dim))
        self.net = nn.Sequential(*layers)
    
    def forward(self, x):
        return self.net(x).squeeze(-1)

# ============ TRAINING LOOP (agent can modify) ============

X_train, y_train = load_training_data()
X_val, y_val = load_validation_data()

model = PhotozNet(X_train.shape[1], HIDDEN_DIMS)
optimizer = torch.optim.Adam(model.parameters(), lr=LEARNING_RATE)

# ... training code ...

z_pred = model(X_val).detach().numpy()
sigma_nmad, outlier_frac = evaluate_predictions(z_pred, y_val)

print(f"sigma_nmad: {sigma_nmad:.4f}")
print(f"outlier_frac: {outlier_frac:.4f}")
```

---

## 8. Practical Considerations

### 8.1 Infrastructure Needs

| Scale | Hardware | Experiments/Hour | Cost |
|-------|----------|------------------|------|
| **Minimal** | 1 GPU (local) | ~10 | Free |
| **Small** | 4 GPUs (cloud) | ~40 | ~$10/hr |
| **Medium** | 16 GPUs (cloud) | ~90 | ~$35/hr |
| **Large** | 64 GPUs (cluster) | ~300+ | ~$120/hr |

### 8.2 Agent Requirements

- **Coding agent:** Claude Code, Codex, Cursor, or similar
- **Can run:** Shell commands, edit files, read output
- **Budget:** ~$10-20 in API costs per overnight run

### 8.3 Time Investment

| Phase | Human Time | Description |
|-------|------------|-------------|
| **Setup** | 2-4 hours | Create prepare.py, initial analyze.py, program.md |
| **Supervision** | 30 min | Monitor first few experiments |
| **Overnight run** | 0 hours | Agent runs autonomously |
| **Review** | 1-2 hours | Analyze results, update program.md |

**Total:** ~4-6 hours human time for ~100 experiments

### 8.4 When Autoresearch Shines

✅ **Use autoresearch when:**
- Clear single metric to optimize
- Experiments are cheap/fast (minutes)
- Parameter space is large
- You have compute budget
- Problem is well-defined

❌ **Don't use when:**
- No clear metric
- Experiments take hours/days
- Need human judgment each step
- Zero compute budget
- Problem is ill-defined

---

## 9. Comparison to Traditional Approaches

| Aspect | Traditional | Autoresearch (1 GPU) | Autoresearch (16 GPUs) |
|--------|-------------|----------------------|------------------------|
| **Experiments/night** | ~5-10 | ~100 | ~700 |
| **Human time** | All day | 4-6 hours setup | 4-6 hours setup |
| **Strategy** | Intuition + trial | Greedy search | Factorial grids |
| **Reproducibility** | Manual notes | Automatic commits | Automatic commits |
| **Creativity** | High (human) | Medium (agent) | Medium (agent) |
| **Throughput** | Low | Medium | High |

---

## 10. Recommended Adoption Path for Astrophysics

### Phase 1: Pilot (1 week)

1. **Choose a simple problem:**
   - Photo-z hyperparameter tuning
   - Source detection threshold optimization
   - Simple classification task

2. **Set up minimal infrastructure:**
   - Local GPU (Mac Studio with MLX, or cloud H100)
   - Claude Code or Cursor
   - Basic program.md

3. **Run first overnight experiment**
   - Monitor progress
   - Review results

### Phase 2: Scale (1 month)

1. **Add cloud GPU access** (SkyPilot, Lambda Labs, etc.)
2. **Parallelize experiments**
3. **Develop domain-specific program.md templates**

### Phase 3: Production (Ongoing)

1. **Integrate into research workflow**
2. **Build library of autoresearch setups** for common tasks
3. **Share successful program.md templates** with collaborators

---

## 11. Resources

### Official
- **Karpathy's Autoresearch:** https://github.com/karpathy/autoresearch
- **SkyPilot Scaling Blog:** https://blog.skypilot.co/scaling-autoresearch/

### Tools
- **Claude Code:** https://code.claude.com
- **SkyPilot:** https://skypilot.co
- **Cursor:** https://cursor.com

### Community
- **Karpathy's tweets:** https://x.com/karpathy
- **GitHub Discussions:** https://github.com/karpathy/autoresearch/discussions

---

## 12. Summary

### What Autoresearch Is
- AI agents running experiments autonomously
- Edit code → run experiment → evaluate → iterate
- Human programs the "research org" via program.md

### Key Results
- Karpathy: ~100 experiments overnight, 11% improvement
- SkyPilot (16 GPUs): ~700 experiments in 8 hours, 2.87% improvement, 9× speedup

### For Astrophysics
- **Applicable to:** Model fitting, pipeline optimization, algorithm development
- **Not applicable to:** Problems requiring human judgment, very long experiments
- **Best starting point:** Photo-z, source detection, classification tasks

### Adoption Path
1. Pilot on simple problem (1 GPU, overnight)
2. Scale with cloud GPUs
3. Integrate into research workflow

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-03-23*
