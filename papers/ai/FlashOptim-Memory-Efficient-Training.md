---
title: "FlashOptim: Optimizers for Memory Efficient Training"
authors:
  - Abhay Gupta
  - Chris Renard
  - Davis Blalock
source: "arXiv:2602.23349v1"
tags:
  - paper
  - ai/deep-learning
  - dev/tool
  - ai/llm
affiliations:
  - Databricks AI Research
date_published: 2026-02
date_read: 2026-03-08
type: paper_summary
category: ai
venue: "Preprint (Deep Learning, Systems)"
---
# FlashOptim: Memory Efficient Training

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | FlashOptim: Optimizers for Memory Efficient Training |
| **arXiv ID** | 2602.23349v1 |
| **Authors** | Gupta, Renard, Blalock (Databricks AI Research) |
| **Code** | github.com/databricks/flashoptim |
| **Type** | Methods + Open source implementation |

---

## The Big Question

**Can you use this for your astronomy research?**

**Short answer:** YES, if you train neural networks. NO, if you use traditional optimization (MLE, MCMC, curve fitting).

Let me explain the distinction and when this would help you.

---

## What FlashOptim Actually Is

### The Problem It Solves

Training neural networks requires a LOT of memory per parameter:

| Tensor | Standard Precision | Bytes/Param |
|--------|-------------------|-------------|
| Master weights | FP32 | 4 |
| Forward/backward weights | FP16/BF16 | 2 |
| Gradients | FP16/BF16 | 2 |
| Optimizer momentum (Adam) | FP32 | 4 |
| Optimizer variance (Adam) | FP32 | 4 |
| **Total (AdamW)** | | **16** |

**Example:** A 7B parameter LLM needs 112GB of GPU memory just for these tensors (before activations).

### What FlashOptim Does

Reduces memory by **over 50%** with no quality loss:

| Optimizer | Standard | FlashOptim | With Gradient Release |
|-----------|----------|------------|----------------------|
| AdamW | 16 bytes | 7 bytes | 5 bytes |
| SGD | 12 bytes | 6 bytes | 4 bytes |

**Example:** Llama-3.1-8B fine-tuning drops from 175GB to 113GB peak memory.

### How It Works

**Two key techniques:**

1. **Weight Splitting:** Instead of storing full 32-bit master weights, store:
   - 16-bit weight (BF16)
   - 8-bit error correction term
   - Together: ~24 bits of effective precision

2. **Companded Quantization:** Compress optimizer states to 8-bit with simple preprocessing:
   - Momentum: Apply `x → 2x/(1+|x|)` before quantization
   - Variance: Apply square root before quantization

---

## When You CAN Use This

### ✅ Neural Network Training

FlashOptim helps when you're training ANY neural network with gradient descent:

| Application | Example | Memory Benefit |
|-------------|---------|----------------|
| **Galaxy classification** | CNN on images | Train larger models on same GPU |
| **Photometric redshift** | MLP on catalog data | Larger batch sizes |
| **Spectral analysis** | Transformer on spectra | Train deeper models |
| **Time series** | RNN/LSTM on light curves | Longer sequences |
| **Fine-tuning LLMs** | Adapting to astronomical text | Fit larger models |

**Concrete example:** If you're training a ResNet to classify galaxies from images, FlashOptim lets you use ~50% more parameters or batch size on the same GPU.

### ✅ Foundation Model Fine-tuning

If you're adapting pretrained models to astronomical tasks:
- Fine-tune larger models on your data
- Reduce checkpoint sizes by 50%+
- Run on smaller GPUs

### ✅ Deep Learning Research

For any experiment involving:
- Training from scratch
- Transfer learning
- Hyperparameter sweeps (run more experiments with same memory)

---

## When You CANNOT Use This

### ❌ Traditional Fitting/Optimization

FlashOptim is **NOT** for general optimization problems:

| Method | What It Does | FlashOptim Compatible? |
|--------|--------------|------------------------|
| **MCMC sampling** | Bayesian inference | ❌ No |
| **Maximum likelihood** | Parameter estimation | ❌ No |
| **Chi-squared minimization** | Model fitting | ❌ No |
| **Least squares** | Curve fitting | ❌ No |
| **scipy.optimize** | General optimization | ❌ No |
| **emcee, dynesty** | Sampling | ❌ No |

**Why not?** These methods don't use gradient descent with Adam/SGD optimizers. They have completely different memory patterns and update rules.

### ❌ Non-Gradient-Descent Training

Methods that don't use standard gradient descent:
- Random forests, decision trees
- k-NN classifiers
- SVMs (unless using gradient-based implementation)
- Gaussian processes (training typically uses L-BFGS, not Adam)

---

## Technical Details (For When You Need Them)

### Weight Splitting Algorithm

The key insight: The error between master weight θ and low-precision weight θ' is always bounded by the ULP (unit in last place) of θ'.

```
Compression:
  θ' = downcast(θ)           # 16-bit weight
  e = θ - θ'                 # Error term
  ρ = round(e / ULP(θ')/2 * 127)  # Scale to 8-bit integer

Decompression:
  θ ≈ θ' + ρ/127 * ULP(θ')/2
```

This gives ~24 bits of precision with only 3 bytes of storage.

### Companding Functions

**For momentum:**
```
ϕ(x) = 2x/(1+|x|)     # Compresses extreme values
ϕ⁻¹(z) = z/(2-|z|)    # Inverse
```

**For variance:**
```
ϕ(x) = √x             # Square root
ϕ⁻¹(z) = z²           # Square
```

These simple transformations reshape distributions to be more uniform, making 8-bit quantization much more accurate.

---

## Practical Usage

### Installation

```bash
pip install flashoptim
```

### Drop-In Replacement

```python
# Before (standard)
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-4)

# After (FlashOptim)
from flashoptim import FlashAdamW
optimizer = FlashAdamW(model.parameters(), lr=1e-4)

# That's it - everything else stays the same
```

### Supported Optimizers

| Standard | FlashOptim Equivalent |
|----------|----------------------|
| `torch.optim.SGD` | `FlashSGD` |
| `torch.optim.AdamW` | `FlashAdamW` |
| `lion_pytorch.Lion` | `FlashLion` |

---

## Experimental Results

### No Quality Degradation

The authors tested on standard benchmarks:

| Task | Standard | FlashOptim | Difference |
|------|----------|------------|------------|
| ResNet-50 (ImageNet) | 76.6% | 76.6% | 0.0% |
| GPT-2 pretraining (val loss) | 3.24 | 3.24 | 0.0% |
| Llama-3.1-8B fine-tuning (GSM8k) | 61.2% | 61.3% | +0.1% |

### Memory Savings

| Model | Standard | FlashOptim | Reduction |
|-------|----------|------------|-----------|
| GPT-2 (124M) | 4.1 GB | 2.4 GB | 41% |
| Llama-3.1-8B | 175 GB | 113 GB | 35% |

### No Slowdown

The compression/decompression is fused into optimizer kernels, so training speed is unchanged.

---

## Comparison: What Different "Optimizers" Mean

| Context | "Optimizer" Means | Example | FlashOptim Helps? |
|---------|------------------|---------|-------------------|
| **Deep learning** | SGD, Adam, AdamW | `torch.optim.AdamW` | ✅ YES |
| **Scientific computing** | scipy.optimize | `scipy.optimize.minimize` | ❌ NO |
| **Bayesian inference** | MCMC samplers | `emcee`, `dynesty` | ❌ NO |
| **Model fitting** | Least squares | `scipy.linalg.lstsq` | ❌ NO |
| **Simulation** | Numerical integrators | ODE solvers | ❌ NO |

**Key distinction:** FlashOptim is for **neural network training with gradient descent**, not general-purpose optimization.

---

## Potential Applications for Your Research

### Astronomy Deep Learning Tasks

If you're doing any of these, FlashOptim could help:

| Task | Model Type | Benefit |
|------|------------|---------|
| Galaxy morphology classification | CNN (ResNet, EfficientNet) | Larger models, more data |
| Photometric redshift prediction | MLP or TabNet | More features, deeper networks |
| Anomaly detection in surveys | Autoencoder | Larger latent space |
| Spectral classification | Transformer | Longer sequences |
| Light curve analysis | RNN/LSTM/Transformer | Longer time series |
| Image reconstruction | UNet | Higher resolution |

### MUST Telescope Applications

Potential uses for MUST data:

| Application | How FlashOptim Helps |
|-------------|---------------------|
| Spectral classification pipeline | Train deeper models on spectra |
| Galaxy survey analysis | Process more galaxies per batch |
| Data quality assessment | Larger models for anomaly detection |
| Simulation emulation | Train faster surrogate models |

### When It Won't Help

Traditional astronomical analysis that FlashOptim does NOT apply to:

| Task | Method | Why FlashOptim Doesn't Help |
|------|--------|----------------------------|
| SED fitting | MCMC or least squares | Not gradient descent |
| Photometric redshift (template-based) | χ² minimization | Not neural network |
| Cosmological parameter estimation | MCMC | Not gradient descent |
| Source detection | Thresholding, wavelets | No training step |
| Astrometry/photometry | Linear algebra | Not gradient descent |

---

## Summary: Should You Use It?

### Use FlashOptim If:

✅ You're training neural networks (CNNs, Transformers, etc.)
✅ You're fine-tuning pretrained models
✅ GPU memory is limiting your experiments
✅ You use PyTorch with AdamW, SGD, or Lion

### Don't Use FlashOptim If:

❌ You're doing traditional fitting (MCMC, least squares, etc.)
❌ You're not using gradient descent
❌ You're not training neural networks
❌ Your bottleneck is compute, not memory

---

## Key Takeaways

| Aspect | Summary |
|--------|---------|
| **What it is** | Memory-efficient versions of AdamW, SGD, Lion for neural network training |
| **Memory savings** | 50%+ reduction (16 → 7 bytes per parameter) |
| **Quality impact** | None - identical training convergence |
| **Speed impact** | None - fused kernels prevent overhead |
| **Ease of use** | Drop-in replacement for PyTorch optimizers |
| **For astronomy** | Useful if you train neural networks; NOT for traditional fitting |

---

## Citation

```bibtex
@article{gupta2026flashoptim,
  title={FlashOptim: Optimizers for Memory Efficient Training},
  author={Gupta, Abhay and Renard, Chris and Blalock, Davis},
  journal={arXiv preprint arXiv:2602.23349},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key distinction to remember:**
> FlashOptim is for **training neural networks with gradient descent** (AdamW, SGD, Lion). It does NOT help with traditional optimization (MCMC, least squares, scipy.optimize).

**When I could use it:**
- Training CNNs for galaxy classification
- Fine-tuning foundation models on astronomical text
- Building spectral analysis models
- Any deep learning with limited GPU memory

**When I should NOT use it:**
- SED fitting with MCMC
- Photometric redshift with template fitting
- Cosmological parameter estimation
- Traditional model fitting

**Action items:**
- [ ] Check which of my projects involve neural network training
- [ ] Identify memory-constrained training scenarios
- [ ] Try FlashOptim as drop-in replacement for AdamW
- [ ] Monitor memory usage vs. training quality

**Code:** github.com/databricks/flashoptim
