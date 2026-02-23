---
title: "Unified Latents (UL): How to train your latents"
authors:
  - Jonathan Heek
  - Emiel Hoogeboom
  - Thomas Mensink
  - Tim Salimans
affiliations:
  - Google DeepMind Amsterdam
source: arXiv:2602.17270v1
date_published: 2026-02-19
date_read: 2026-02-23
type: paper_summary
category: ai
venue: Preprint (Machine Learning, Computer Vision)
tags:
  - diffusion-models
  - latent-representations
  - autoencoders
  - image-generation
  - video-generation
  - stable-diffusion
  - generative-ai
---

# Unified Latents (UL): How to train your latents

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Unified Latents (UL): How to train your latents |
| **arXiv ID** | 2602.17270v1 |
| **Published** | February 19, 2026 |
| **Authors** | Jonathan Heek, Emiel Hoogeboom, Thomas Mensink, Tim Salimans (Google DeepMind Amsterdam) |
| **Venue** | Preprint (cs.LG, cs.CV) |
| **Code** | Not explicitly mentioned |

---

## tl;dr (Executive Summary)

**The problem:** Current latent diffusion models (like Stable Diffusion) use VAE-style latents with manually-tuned KL penalties, making it hard to control the information content of latents. There's a trade-off: low-bitrate latents are easy to model but lose information; high-bitrate latents retain information but are hard to model.

**The solution:** **Unified Latents (UL)**—a framework where latents are jointly regularized by a **diffusion prior** and decoded by a **diffusion model**. By linking encoder noise to the prior's minimum noise level, the training objective provides a tight upper bound on latent bitrate.

**Key results:**
- ImageNet-512: **FID of 1.4** with high reconstruction quality (PSNR)
- Kinetics-600 (video): **FVD of 1.3** (new SOTA)
- Requires **fewer training FLOPs** than models trained on Stable Diffusion latents

---

## Background and Motivation

### What are Latent Diffusion Models?

Diffusion models generate data (images, videos, audio) by gradually denoising random noise. However, operating directly on high-resolution images (e.g., 512×512 pixels) is computationally expensive.

**Latent Diffusion Models (LDMs)** solve this by:
1. **Encoding:** Compress images into a compact latent representation (e.g., 32×32×4)
2. **Diffusion:** Apply diffusion in this compressed latent space
3. **Decoding:** Reconstruct images from the generated latents

**Stable Diffusion** is the most famous example of this approach.

### The Problem with Current Approaches

**Stable Diffusion's approach:**
- Uses a VAE-style autoencoder
- Applies a KL penalty between latent distribution and standard Gaussian
- The weight of this KL term must be set **manually**
- **Problem:** No principled way to reason about how many "bits" of information are actually in the latents

**The trade-off:**
- **Low bitrate (few bits):** Latents are easier to model → better generation quality, but poor reconstruction
- **High bitrate (many bits):** Better reconstruction, but latents are harder to model → worse generation quality

**Physics analogy:** Like compressing a signal—aggressive compression loses information but makes processing easier; minimal compression preserves information but requires more processing power.

### Recent Approaches and Their Limitations

| Approach | Method | Limitation |
|----------|--------|------------|
| **Semantic latents** (DINO, SigLIP) | Use pretrained network representations | Easy to learn but lose high-frequency details (PSNR ≤ 20) |
| **Heavily regularized autoencoders** | Strong KL penalties | Good FID but reconstruction artifacts |
| **Token-based** (TiTok) | Discrete tokens | Fast sampling but trade reconstruction quality |

**The core question:** How should latents be regularized when they will subsequently be modeled by a diffusion model?

---

## Core Concepts Explained

### 1. Variational Autoencoders (VAEs)

**What it is:** A framework for learning compressed representations (latents) that can reconstruct the original data.

**The ELBO (Evidence Lower Bound):**

$$
-\log p_\theta(x) \leq \underbrace{\mathbb{E}_{z_0 \sim p_\theta(z_0|x)}[-\log p_\theta(x|z_0)]}_{\text{reconstruction loss}} + \underbrace{\text{KL}[p_\theta(z_0|x) \| p_\theta(z_0)]}_{\text{prior regularization}}
$$

**Components:**
- **Encoder:** $p_\theta(z_0|x)$ — compresses image $x$ to latent $z_0$
- **Decoder:** $p_\theta(x|z_0)$ — reconstructs image from latent
- **Prior:** $p_\theta(z_0)$ — regularizes what latents are allowed

**Physics analogy:** Like lossy compression in signal processing. The encoder compresses the signal, the prior ensures the compressed representation follows some distribution, and the decoder reconstructs the original from the compressed form.

### 2. Diffusion Models

**What it is:** A generative model that learns to reverse a gradual "destruction" (noise addition) process.

**The forward process:**
$$x_t = \alpha(t) x + \sigma(t) \epsilon, \quad \epsilon \sim \mathcal{N}(0, I)$$

Gradually add Gaussian noise to clean data $x$ over time $t \in [0, 1]$.

**The reverse process:**
Train a neural network to predict the clean data $\hat{x}(x_t, \theta)$ from the noisy version $x_t$.

**Key property:** The loss can be decomposed over "noise levels" (log-SNR: signal-to-noise ratio in log space).

$$
\text{KL}[p(x_0|x) \| p_\theta(x_0)] \leq \mathbb{E}_{t \sim U(0,1)} \left[ -\frac{d\lambda(t)}{dt} \frac{e^{\lambda(t)}}{2} w(\lambda(t)) \|x - \hat{x}(x_t, \theta)\|^2 \right]
$$

**Physics analogy:** Like thermodynamic reversibility—the model learns to "unmix" a diffused substance (like unmixing cream from coffee), which is statistically possible but requires knowledge of the mixing process.

### 3. The Unified Latents Innovation

**The key insight:** Instead of using a fixed Gaussian prior (like VAEs), use a **diffusion prior** that can model the latent distribution more flexibly.

**The three key ideas:**

#### a) Encode with Fixed Gaussian Noise

Instead of learning the encoder noise level, **fix it**:

$$p(z_0 | z_{\text{clean}}) = \mathcal{N}(\alpha_0 z_{\text{clean}}, \sigma_0^2)$$

With $\lambda(0) = 5$ (log-SNR at $t=0$):
- $\alpha_0 = \text{sigmoid}(+5) \approx 1.0$
- $\sigma_0 = \text{sigmoid}(-5) \approx 0.08$

**Why this matters:** This links the encoder's precision to the prior's minimum noise level. The latent $z_0$ always has a fixed, known amount of noise.

**Physics analogy:** Like measuring a quantity with a known, fixed instrument precision. Rather than trying to learn the precision of your measurement device, you fix it to a known value and work within those constraints.

#### b) Diffusion Prior

The prior $p_\theta(z_0)$ is itself a **diffusion model** that learns the distribution of latents.

**The prior loss:**

$$
\text{KL}[p(z_0|x) \| p_\theta(z_0)] \leq \mathbb{E}_t \left[ -\frac{d\lambda_z(t)}{dt} \frac{e^{\lambda_z(t)}}{2} w(\lambda_z(t)) \|z_{\text{clean}} - \hat{z}(z_t, \theta)\|^2 + \text{KL}[p(z_1|x) \| \mathcal{N}(0, I)] \right]
$$

**Key difference:** The prior can be unweighted ($w = 1$) because the encoder can't "cheat" by putting information at discounted noise levels—the noise is fixed!

#### c) Diffusion Decoder with Reweighted Loss

The decoder is also a diffusion model, but with a **reweighted loss**:

$$w(\lambda_x(t)) = \text{sigmoid}(\lambda_x(t) - b)$$

This discounts low noise levels, forcing the decoder to model high-frequency details.

**Plus a loss factor $c_{\text{lf}}$** (typically 1.3-1.7):
- Up-weights decoder loss
- Prevents posterior collapse (where encoder stops encoding useful information)
- Controls the reconstruction-modeling trade-off

### 4. The Information-Quality Trade-off

**The fundamental tension:**
- More bits in latent → Better reconstruction (high PSNR, low rFID)
- Fewer bits in latent → Easier to model → Better generation (low gFID)

**UL's solution:** Two hyperparameters control this:
- **Loss factor ($c_{\text{lf}}$):** Higher = more bits in latent = better reconstruction
- **Sigmoid bias ($b$):** Adjusts which noise levels the decoder focuses on

| Loss Factor | Bits/pixel | rFID (reconstruction) | gFID (generation, small model) |
|-------------|-----------|----------------------|-------------------------------|
| 1.3 | 0.035 | 0.79 | 1.42 |
| 1.5 | 0.059 | 0.47 | 1.54 |
| 1.7 | 0.083 | 0.36 | 1.77 |
| 1.9 | 0.101 | 0.31 | 2.02 |
| 2.1 | 0.116 | 0.27 | 2.38 |

**Observation:** Higher loss factors improve reconstruction but hurt generation for smaller models. Larger models can handle higher bitrates.

### 5. Training Stages

**Stage 1:** Joint training of encoder, prior, and decoder
- Encoder: $E_\theta(x) \to z_{\text{clean}}$
- Prior: Diffusion model on latents $P_\theta(z_0)$
- Decoder: Diffusion model on images $D_\theta(x_t, z_0)$

**Stage 2:** Retrain the prior as a base model
- Prior from Stage 1 uses unweighted ELBO (good for likelihood, bad for sampling)
- Train new prior with sigmoid weighting (better for generation)
- Encoder and decoder are frozen

**Physics analogy:** Like two-stage instrument calibration—first you establish the relationship between raw measurements and physical quantities (Stage 1), then you optimize the measurement process for precision (Stage 2).

---

## Key Findings

### Finding 1: Superior Efficiency on ImageNet-512

UL outperforms all other approaches on **training cost vs. generation quality**:

- **FID of 1.4** at competitive training costs
- Outperforms DiT-XL/2, EDM2, and SiD2
- Even when training the same architecture on Stable Diffusion latents, UL performs better

### Finding 2: State-of-the-Art Video Generation

On Kinetics-600 (video generation):
- **FVD of 1.3** (new state-of-the-art)
- Small model achieves 1.7 FVD
- Outperforms Video Diffusion, MAGVIT-v2, W.A.L.T.

### Finding 3: Text-to-Image Quality

| Method | gFID@30K | CLIP Score |
|--------|---------|------------|
| UL (LF=1.5) | **4.1** | **27.1** |
| Pixel (no latents) | 5.0 | 27.0 |
| Stable Diffusion | 6.8 | 27.0 |

UL achieves better perceptual quality (lower FID) while maintaining text alignment.

### Finding 4: Latent Channel Count is Not Critical

| Channels | rFID | gFID@50K |
|----------|------|----------|
| 4 | 7.19 | — |
| 8 | 1.53 | 1.76 |
| 16 | 0.54 | — |
| 32 | 0.42 | 1.60 |
| 64 | 0.48 | 1.77 |

**Surprising:** FID is mostly insensitive to latent channel count (as long as ≥ 16). Only very few channels (≤ 8) hurt reconstruction.

**Implication:** The diffusion prior effectively "compresses" the information regardless of channel count.

### Finding 5: Spatial Downsampling Matters

| Downsampling | Latent Shape | rFID@50K | gFID@50K |
|--------------|-------------|----------|----------|
| 8× | 64×64×32 | 0.40 | 2.12 |
| 16× | 32×32×32 | 0.41 | **1.63** |
| 32× | 16×16×32 | 1.41 | 1.74 |

**Optimal:** 16× downsampling to 32×32 latents gives best generation quality.

### Finding 6: Ablations Validate Design

| Configuration | Latent bpd | rFID@50K | gFID@50K |
|--------------|-----------|----------|----------|
| **UL baseline** | 0.059 | 0.47 | 1.54 |
| A. No prior gradient | 0.121 | 1.81 | 7.80 |
| B. High precision latents | 0.008 | 28.27 | — |
| C. Text-to-image data | 0.034 | 1.37 | 1.63 |
| D. Learned variance | 0.060 | 0.69 | 1.81 |

**Key takeaways:**
- Removing prior gradient (A) → catastrophic failure
- Too little noise (B) → can't model bitrate
- Learned variance (D) → unstable, worse performance

---

## Practical Implications

### For Dr. Guangtou's Workflow

**1. Understanding Image Generation Models**
When using Stable Diffusion or similar tools, you now understand:
- The latent space is a **compressed representation** (like a lossy JPEG, but learned)
- There's an inherent trade-off between reconstruction quality and generation quality
- The "quality" of generation depends on how easy the latents are to model

**2. Choosing Models for Scientific Visualization**
If you use AI for generating scientific figures or visualizations:
- **High loss factor** → Better reconstruction of fine details (good for precise figures)
- **Low loss factor** → Better generation quality (good for creative exploration)
- UL's two-stage training might offer better control over this trade-off

**3. Data Compression Analogy**
The paper's insights about bitrate and information content have parallels in scientific data:
- Like compressing telescope data—how much can you compress before losing scientifically relevant information?
- The diffusion prior acts like an adaptive compression scheme that preserves what's important for downstream tasks

**4. For MUST Telescope Data**
While this paper focuses on images/video, the principles could apply to astronomical data:
- Could we learn "latent representations" of galaxy spectra or light curves?
- A diffusion prior might better capture the distribution of astronomical phenomena than simple Gaussian priors
- The bitrate control could help balance compression with scientific utility

### For AI Practitioners

**Key insights:**
1. **Fixed encoder noise** simplifies training and provides interpretable bitrate bounds
2. **Diffusion prior + diffusion decoder** is better than VAE prior + MSE decoder
3. **Two-stage training** (ELBO prior → sigmoid base model) improves generation
4. **Loss factor** is the key hyperparameter controlling reconstruction-quality trade-off

---

## Critical Analysis

### Strengths

1. **Principled framework:** Provides theoretical justification for the approach (tight upper bound on bitrate)

2. **Practical improvement:** Achieves SOTA results with fewer training FLOPs

3. **Interpretable hyperparameters:** Loss factor and bias directly control the reconstruction-modeling trade-off

4. **Thorough evaluation:** Tests on images (ImageNet), video (Kinetics), and text-to-image

5. **Rigorous ablations:** Each design choice is validated through controlled experiments

### Limitations

1. **Two-stage training:** More complex than single-stage approaches

2. **Computational cost:** Although more efficient than baselines, still requires significant compute

3. **Limited to continuous data:** Paper mentions potential for discrete data (text) but doesn't demonstrate it

4. **Dataset dependence:** Autoencoder trained on different data (text-to-image vs. ImageNet) shows different reconstruction quality

5. **No code release:** Limits reproducibility and adoption

### Open Questions

- Can this framework be extended to **multimodal data** (e.g., images + spectra)?
- How do these latents behave under **manipulation** (arithmetic in latent space)?
- Can the **scaling laws** be formalized to predict optimal bitrate given compute budget?
- Does this approach work for **3D data** (e.g., volumetric telescope data)?

---

## Related Work

### Latent Diffusion Models
- **Rombach et al. (2022):** Original LDM with VAE autoencoder (Stable Diffusion)
- **Chen et al. (2024):** Efficient autoencoders with high compression

### Diffusion Decoders
- **Pandey et al. (2022):** DiffuseVAE—diffusion decoder but trained separately
- **Shi et al. (2022):** DiVAE—diffusion decoder with discrete VQ tokens
- **Hoogeboom et al. (2024):** UVit architecture used in this work

### Diffusion Priors
- **Vahdat et al. (2021):** LSGM—joint diffusion prior but requires unstable entropy term
- This work simplifies by using fixed encoder noise

### Token-based Approaches
- **Yu et al. (2024):** TiTok—compress images to discrete tokens
- Trade reconstruction quality for speed

---

## Citation

```bibtex
@article{heek2026unified,
  title={Unified Latents (UL): How to train your latents},
  author={Heek, Jonathan and Hoogeboom, Emiel and Mensink, Thomas and Salimans, Tim},
  journal={arXiv preprint arXiv:2602.17270},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> The quality of latent representations in generative models depends on a trade-off between **information content** (bitrate) and **modeling difficulty**. Unified Latents provides a principled way to control this trade-off using a diffusion prior, achieving better generation quality with fewer training resources.

**Connections to my work:**

1. **Data compression for astronomy:** The bitrate control mechanism could inform how we compress and store telescope data. What's the minimum bitrate needed to preserve scientifically useful information?

2. **Generative models for scientific data:** If we train diffusion models on galaxy images or spectra, UL's approach might yield better sample quality with less compute—relevant for MUST data simulation.

3. **Uncertainty quantification:** The fixed encoder noise ($\sigma_0 \approx 0.08$) provides an interpretable uncertainty level. In scientific applications, this could help quantify reconstruction uncertainty.

**Questions to explore:**
- [ ] Could UL-style latents be used for **anomaly detection** in telescope data (unusual galaxies, artifacts)?
- [ ] How does the bitrate-information trade-off apply to **1D data** like light curves or spectra?
- [ ] Could we learn a "unified latent" representation that works across **multiple telescopes** (multi-modal)?
- [ ] What would be the scientific analog of FID/PSNR for astronomical data quality?

**Action items:**
- [ ] Keep an eye on whether Google releases code for this—could be useful for MUST-related generative modeling
- [ ] Consider if any MUST science cases could benefit from latent diffusion models (e.g., simulating galaxy images for training classifiers)
- [ ] Discuss with the MUST team whether generative AI for data augmentation is relevant to our science goals
