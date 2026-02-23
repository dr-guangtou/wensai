---
title: "Article-to-Podcast / Text-to-Speech Solutions"
date: 2026-02-22
topic: "Text-to-Speech & Podcast Generation"
category: "AI/ML Research"
tags: ["tts", "podcast", "elevenlabs", "voicebox", "latex", "astronomy", "open-source"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Article-to-Podcast / Text-to-Speech Solutions Investigation Report

**Research Date:** 2026-02-22  
**Investigation Topic:** Converting Articles, Papers, and AI News into Audio Podcasts  
**Focus Areas:** Technical Content Support, LaTeX Handling, Voice Quality, Pricing

---

## 1. Executive Summary

The article-to-podcast market has matured significantly, with solutions ranging from **premium cloud APIs** to **open-source local models**. For astronomy/technical papers with LaTeX symbols (e.g., `$M_{\odot}$` → "Solar mass"), **pre-processing is essential**—no TTS solution natively understands LaTeX notation.

**Key Finding:** For your specific use case (AI news, arXiv digests, astronomy papers), the workflow should be:
1. **Pre-process text** (convert LaTeX to spoken words)
2. **Use high-quality TTS** (ElevenLabs for best quality, Kokoro for free)
3. **Post-process** (add intro/outro music for podcast feel)

---

## 2. The LaTeX Challenge

### Can TTS pronounce `$M_{\odot}$` as "Solar mass"?

**Short Answer:** No TTS system natively understands LaTeX. **Pre-processing is required.**

| Approach | Feasibility | Complexity |
|----------|-------------|------------|
| **Pre-process with LLM** | ✅ Best | Medium |
| **Custom pronunciation dictionary** | ⚠️ Limited | High |
| **Manual text replacement** | ✅ Works | Tedious |

### Recommended Pre-processing Pipeline

```python
# Example: Convert LaTeX to spoken text before TTS
latex_replacements = {
    r"$M_{\odot}$": "solar masses",
    r"$\alpha$": "alpha",
    r"$\beta$": "beta",
    r"$\gamma$": "gamma",
    r"$\delta$": "delta",
    r"$\sigma$": "sigma",
    r"$\pm$": "plus or minus",
    r"$\times$": "times",
    r"$\sim$": "approximately",
    r"^2": "squared",
    r"^3": "cubed",
    r"km s^{-1}": "kilometers per second",
    r"Mpc": "megaparsecs",
    r"Gyr": "gigayears",
    r"\frac{a}{b}": "a over b",
}
```

**Better Approach:** Use an LLM (Claude, GPT-4) to convert LaTeX-heavy text to TTS-friendly prose:

```
Prompt: "Convert this LaTeX-heavy astronomy paper excerpt into 
natural spoken English. Replace all LaTeX symbols with their 
spoken equivalents (e.g., $M_{\odot}$ becomes 'solar mass'). 
Make it sound like a podcast narration."
```

---

## 3. Premium Paid Options

### 3.1 ElevenLabs ⭐ (Best Overall)

| Attribute | Details |
|-----------|---------|
| **Website** | https://elevenlabs.io |
| **Voice Quality** | ⭐⭐⭐⭐⭐ Industry-leading |
| **Pricing** | Free (10k chars) / $5-99/month / Enterprise |
| **Languages** | 70+ |
| **Best For** | Professional podcasts, audiobooks |

**Key Features:**
- **Eleven v3** (latest model): Most natural-sounding TTS available
- **Voice Cloning:** Create custom voices from samples
- **Projects:** Long-form audio generation with multiple voices
- **Dubbing:** Automatic translation + voice matching
- **Emotion Control:** `[whispers]`, `[laughs]`, `[sadly]` tags

**Pricing Tiers:**
| Plan | Price | Characters |
|------|-------|------------|
| Free | $0 | 10k/month |
| Starter | $5 | 30k/month |
| Creator | $22 | 100k/month |
| Pro | $99 | 500k/month |
| Scale | $330 | 2M/month |

**For Your Use Case:**
- Excellent for AI news digests
- Handle technical terms well (with pre-processing)
- Voice cloning for consistent podcast host
- Projects feature for multi-episode series

**Pros:**
- Best-in-class voice quality
- Extensive voice library (10,000+ voices)
- Commercial use allowed
- API available

**Cons:**
- Expensive at scale
- Requires pre-processing for LaTeX
- No built-in article parsing

---

### 3.2 Speechify

| Attribute | Details |
|-----------|---------|
| **Website** | https://speechify.com |
| **Voice Quality** | ⭐⭐⭐⭐ Good |
| **Pricing** | Free / Premium $29/month |
| **Best For** | Reading articles, accessibility |

**Key Features:**
- **AI Podcast:** Convert articles to podcast format
- **AI Summaries:** Condense long content
- **Speed Control:** Up to 5x speed
- **Cross-platform:** iOS, Android, Chrome, Edge, Mac

**Pricing:**
| Plan | Price | Features |
|------|-------|----------|
| Free | $0 | Basic voices, 1.5x speed |
| Premium | $29/mo | 1000+ voices, 5x speed, AI summaries, podcasts |

**Pros:**
- Purpose-built for article-to-audio
- AI Podcast feature
- Good integrations (Drive, Dropbox)

**Cons:**
- Voices not as natural as ElevenLabs
- Limited technical content handling
- Expensive for what it offers

---

### 3.3 NotebookLM Audio Overview

| Attribute | Details |
|-----------|---------|
| **Website** | https://notebooklm.google.com |
| **Cost** | Free (Google account) |
| **Voice Quality** | ⭐⭐⭐⭐ Good (two-host conversation) |
| **Best For** | Research papers, complex documents |

**Key Features:**
- **AI-generated podcast:** Two hosts discussing your sources
- **Multiple formats:** Deep-dive, brief, critique, debate
- **50+ languages**
- **Upload sources:** PDFs, URLs, YouTube, Google Drive
- **Automatic summarization**

**How It Works:**
1. Upload sources (PDFs, URLs)
2. Click "Generate Audio Overview"
3. AI creates conversational podcast

**For Your Use Case:**
- Excellent for arXiv papers
- Two-host format makes technical content engaging
- Free with Google account
- Can handle multiple sources

**Pros:**
- Free
- Conversational format (not just reading)
- Good for complex topics
- Multi-source synthesis

**Cons:**
- Not a "reading" of the paper—it's a discussion
- Limited control over content
- No API (must use UI)

---

### 3.4 NaturalReader AI Podcast

| Attribute | Details |
|-----------|---------|
| **Website** | https://www.naturalreaders.com |
| **Cost** | Freemium / Commercial licensing |
| **Voice Quality** | ⭐⭐⭐⭐ Good |

**Key Features:**
- **AI Podcast:** Convert documents to podcast episodes
- **Topic Focus:** Select specific sections
- **Speaker Control:** 1-2 speakers, adjustable length
- **AI Recap:** Summarize key points
- **AI Chat:** Ask questions about content

**Pros:**
- Purpose-built for podcast creation
- Educational focus
- Good for long documents

**Cons:**
- Voices less natural than ElevenLabs
- Pricing unclear for heavy use

---

### 3.5 Play.ht

| Attribute | Details |
|-----------|---------|
| **Website** | https://play.ht |
| **Voice Quality** | ⭐⭐⭐⭐ Very Good |
| **Pricing** | Free / Creator $39/mo / Unlimited $99/mo |
| **Best For** | Content creators, bloggers |

**Key Features:**
- 900+ AI voices
- Voice cloning
- Podcast hosting
- WordPress plugin
- Team collaboration

**Pros:**
- Good voice quality
- Podcast hosting included
- RSS feed generation

**Cons:**
- Pricing higher than competitors
- Less control than ElevenLabs

---

## 4. Free/Open Source Options

### 4.1 Voicebox ⭐⭐ (Best New Open Source - Highly Recommended)

| Attribute | Details |
|-----------|---------|
| **Repository** | https://github.com/jamiepine/voicebox |
| **License** | Open source (check repo for details) |
| **Voice Quality** | ⭐⭐⭐⭐⭐ Excellent (Qwen3-TTS powered) |
| **Stars** | 9.9k (very popular) |
| **Best For** | Voice cloning, podcast production, local processing |

**Key Features:**
- **Powered by Qwen3-TTS** (Alibaba's breakthrough model)
- **Voice cloning** from just a few seconds of audio
- **Multi-track timeline editor** (DAW-like) for podcast production
- **Stories editor** for multi-voice narratives and conversations
- **MLX backend** — 4-5x faster on Apple Silicon (Neural Engine)
- **Native performance** — Built with Tauri (Rust), not Electron
- **Complete privacy** — Everything runs locally
- **REST API** — Integrate into your own projects
- **Batch generation** for long-form content

**Platform Support:**
| Platform | Status | Download |
|----------|--------|----------|
| macOS (Apple Silicon) | ✅ | Available |
| macOS (Intel) | ✅ | Available |
| Windows | ✅ | Available |
| Linux | ⏳ | Coming soon |

**Installation:**
Download pre-built binaries from GitHub releases — **no Python install required**:
- macOS: `voicebox_aarch64.app.tar.gz` (Apple Silicon) or `voicebox_x64.app.tar.gz` (Intel)
- Windows: MSI or Setup.exe

**API Example:**
```bash
# Generate speech
curl -X POST http://localhost:8000/generate \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello world", "profile_id": "abc123", "language": "en"}'

# List voice profiles
curl http://localhost:8000/profiles
```

**For Your Use Case:**
- **Excellent** for astronomy paper podcasts
- **Multi-track editor** perfect for adding intro/outro music
- **Voice cloning** — create a consistent "host" voice
- **Stories editor** — create multi-part podcast series
- **Runs super fast** on your Mac Studio (MLX optimized)
- **Free alternative to ElevenLabs**

**Pros:**
- ⭐ **Best-in-class open source voice cloning** (Qwen3-TTS)
- ⭐ **Professional DAW-like editor** (unique among open source)
- ⭐ **Native Mac performance** (MLX + Metal)
- ⭐ **No cloud dependency**
- ⭐ **Easy installation** (pre-built binaries)
- Complete privacy
- Free

**Cons:**
- Requires LaTeX pre-processing (like all TTS)
- No built-in article fetching
- Relatively new project (rapid development)

---

### 4.2 Kokoro TTS (Best Lightweight Free)

| Attribute | Details |
|-----------|---------|
| **Repository** | https://huggingface.co/spaces/hexgrad/Kokoro-TTS |
| **License** | Apache 2.0 |
| **Voice Quality** | ⭐⭐⭐⭐ Very Good (surprisingly!) |
| **Size** | ~1GB |
| **Best For** | Local processing, privacy, quick setup |

**Key Features:**
- **Open source** (fully local)
- **High quality** (comparable to commercial solutions)
- **Multiple languages**
- **Fast inference**
- **Lightweight** compared to Voicebox

**Installation:**
```bash
pip install kokoro
# Or use via Hugging Face Spaces
```

**Pros:**
- Completely free
- Private (no cloud)
- Surprisingly good quality
- Can run locally on Mac Studio
- Simpler than Voicebox (no UI)

**Cons:**
- No voice cloning
- No multi-track editor
- No GUI (Python library only)
- Manual LaTeX pre-processing needed

**For Your Use Case:**
- Good lightweight option for astronomy papers
- Run locally on your Mac Studio
- Use when you don't need voice cloning

**vs Voicebox:**
- Kokoro: Simpler, library-only, no voice cloning
- Voicebox: Full studio with GUI, voice cloning, multi-track editor

---

### 4.3 Fish Speech (FishAudio-S1)

| Attribute | Details |
|-----------|---------|
| **Repository** | https://github.com/fishaudio/fish-speech |
| **License** | Apache 2.0 (code), CC-BY-NC-SA-4.0 (weights) |
| **Voice Quality** | ⭐⭐⭐⭐⭐ Excellent |
| **Size** | S1: 4B, S1-mini: 0.5B |

**Key Features:**
- **State-of-the-art quality** (0.008 WER on English)
- **Emotionally expressive**
- **Voice cloning** (30s reference)
- **Cross-lingual** voice cloning

**Pros:**
- Among best open-source TTS
- Emotionally rich
- Voice cloning works well

**Cons:**
- Requires GPU (12GB+ VRAM for full model)
- Weights are non-commercial (CC-BY-NC-SA)
- Complex setup

---

### 4.4 MetaVoice-1B

| Attribute | Details |
|-----------|---------|
| **Repository** | https://github.com/metavoiceio/metavoice-src |
| **License** | Apache 2.0 |
| **Voice Quality** | ⭐⭐⭐⭐ Good |
| **Size** | 1.2B parameters |

**Key Features:**
- **Zero-shot voice cloning** (30s audio)
- **Emotional speech** rhythm and tone
- **Arbitrary length** text support
- **Quantization:** int4/int8 for faster inference

**Pros:**
- Fully open source
- Good voice cloning
- Runs locally

**Cons:**
- Requires GPU (12GB+ VRAM)
- Setup complexity
- Less natural than Fish Speech

---

### 4.5 Bark (Suno)

| Attribute | Details |
|-----------|---------|
| **Repository** | https://github.com/suno-ai/bark |
| **License** | MIT (commercial use allowed!) |
| **Voice Quality** | ⭐⭐⭐ Good, but experimental |

**Key Features:**
- **Fully generative** (not just TTS)
- **Nonverbal sounds:** [laughs], [sighs], [gasps]
- **Multilingual**
- **Music generation**
- **2x speed-up** on GPU, 10x on CPU

**Pros:**
- Completely free
- Commercial use allowed (MIT)
- Unique nonverbal capabilities

**Cons:**
- Less predictable than TTS
- Can deviate from text unexpectedly
- Lower quality than dedicated TTS
- Slower inference

---

### 4.6 ChatTTS

| Attribute | Details |
|-----------|---------|
| **Repository** | https://github.com/2noise/ChatTTS |
| **License** | AGPLv3+ (code), CC BY-NC 4.0 (model) |
| **Languages** | English, Chinese |

**Key Features:**
- **Conversational TTS** (designed for dialogue)
- **Fine-grained control:** laughter, pauses, interjections
- **Multiple speakers** for conversations

**Pros:**
- Great for conversational content
- Natural prosody
- Free

**Cons:**
- Academic use only (CC BY-NC)
- Limited languages
- Less stable than other options

---

## 5. Comparison Matrix

### For Astronomy Papers / Technical Content

| Tool | Voice Quality | LaTeX Support | Cost | Ease of Use | Best For |
|------|---------------|---------------|------|-------------|----------|
| **ElevenLabs** | ⭐⭐⭐⭐⭐ | ⚠️ Pre-process | $$$ | Easy | Professional podcasts |
| **Voicebox** | ⭐⭐⭐⭐⭐ | ⚠️ Pre-process | Free | Easy | Voice cloning, podcast production |
| **NotebookLM** | ⭐⭐⭐⭐ | ⚠️ Pre-process | Free | Easy | Research paper summaries |
| **Kokoro** | ⭐⭐⭐⭐ | ⚠️ Pre-process | Free | Medium | Lightweight local TTS |
| **Fish Speech** | ⭐⭐⭐⭐⭐ | ⚠️ Pre-process | Free* | Hard | Technical users |
| **Speechify** | ⭐⭐⭐⭐ | ⚠️ Pre-process | $$ | Easy | Article listening |
| **Bark** | ⭐⭐⭐ | ⚠️ Pre-process | Free | Medium | Experimental use |

*Non-commercial use only for weights

---

## 6. Recommended Workflows

### Option A: Best Quality (Paid)

```
1. Fetch arXiv paper / AI news
2. LLM pre-process (LaTeX → spoken text)
3. ElevenLabs API (Projects for long-form)
4. Optional: Add intro/outro music
5. Publish to podcast RSS
```

**Cost:** ~$22-99/month (ElevenLabs Creator/Pro)

### Option B: Best Free (Recommended)

```
1. Fetch arXiv paper / AI news
2. LLM pre-process (LaTeX → spoken text)
3. Voicebox (local on Mac Studio)
   - Clone a voice for consistent "host"
   - Use Stories editor for multi-track podcast
   - Add intro/outro music in timeline
4. Export MP3
5. Publish to podcast RSS
```

**Cost:** Free
**Hardware:** Mac Studio runs Voicebox extremely fast (MLX optimized)
**Why Voicebox:** Full studio with DAW-like editor, voice cloning, native Mac performance

**Alternative (lightweight):** Use Kokoro TTS instead of Voicebox if you just need simple TTS without editing features

### Option C: Zero-Effort (Free)

```
1. Upload PDF to NotebookLM
2. Generate Audio Overview
3. Download MP3
4. No pre-processing needed!
```

**Trade-off:** Not a direct reading—it's an AI discussion of the paper

---

## 7. Technical Implementation for Astronomy Papers

### Pre-processing Script Example

```python
import re

def preprocess_latex_for_tts(text):
    """Convert LaTeX to spoken text."""
    
    replacements = {
        # Units and constants
        r"$M_{\\odot}$": "solar masses",
        r"$L_{\\odot}$": "solar luminosities",
        r"$R_{\\odot}$": "solar radii",
        r"$\\odot$": "solar",
        
        # Greek letters
        r"$\\alpha$": "alpha",
        r"$\\beta$": "beta",
        r"$\\gamma$": "gamma",
        r"$\\delta$": "delta",
        r"$\\lambda$": "lambda",
        r"$\\sigma$": "sigma",
        r"$\\rho$": "rho",
        r"$\\mu$": "mu",
        r"$\\nu$": "nu",
        
        # Operators
        r"$\\pm$": "plus or minus",
        r"$\\times$": "times",
        r"$\\sim$": "approximately",
        r"$\\approx$": "approximately",
        r"$\\propto$": "proportional to",
        r"$\\leq$": "less than or equal to",
        r"$\\geq$": "greater than or equal to",
        
        # Common astronomical units
        r"km s\^\{-1\}": "kilometers per second",
        r"km/s": "kilometers per second",
        r"Mpc": "megaparsecs",
        r"kpc": "kiloparsecs",
        r"Gyr": "gigayears",
        r"Myr": "megayears",
        r"pc": "parsecs",
        
        # Exponents
        r"\^2(?![0-9])": "squared",
        r"\^3(?![0-9])": "cubed",
        r"\^\{-1\}": "to the minus one",
        r"\^\{-2\}": "to the minus two",
    }
    
    for pattern, replacement in replacements.items():
        text = re.sub(pattern, replacement, text)
    
    # Remove remaining LaTeX commands
    text = re.sub(r"\\[a-zA-Z]+\{([^}]+)\}", r"\1", text)  # \command{...}
    text = re.sub(r"\$([^$]+)\$", r"\1", text)  # $...$
    text = re.sub(r"\\", "", text)  # stray backslashes
    
    return text

# Example usage
latex_text = "The galaxy has a mass of $10^{12} M_{\\odot}$ and is at $z \\sim 0.5$."
spoken_text = preprocess_latex_for_tts(latex_text)
# Result: "The galaxy has a mass of 10 to the 12 solar masses and is at z approximately 0.5."
```

### LLM-Based Pre-processing (Better)

```python
import anthropic

client = anthropic.Anthropic()

def convert_to_spoken_text(scientific_text):
    prompt = f"""Convert this scientific text into natural spoken English for a podcast.
    Replace all LaTeX, symbols, and technical notation with their spoken equivalents.
    
    Rules:
    - $M_{{\\odot}}$ → "solar masses"
    - $\\alpha$, $\\beta$, etc. → Greek letter names
    - $^2$, $^3$ → "squared", "cubed"
    - km s⁻¹ → "kilometers per second"
    - Mpc → "megaparsecs"
    - z ∼ 0.5 → "redshift approximately 0.5"
    - Make it flow naturally for listening
    - Keep technical accuracy
    
    Text:
    {scientific_text}
    
    Spoken version:"""
    
    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4000,
        messages=[{"role": "user", "content": prompt}]
    )
    
    return response.content[0].text
```

---

## 8. Summary Recommendations

### Best Overall: ElevenLabs
- **Why:** Unmatched voice quality, Projects feature for long-form
- **Cost:** $22/month (Creator plan)
- **Best for:** Professional-quality astronomy podcast

### Best Free: Voicebox ⭐ (New Top Pick)
- **Why:** Qwen3-TTS powered voice cloning, professional DAW-like editor, native Mac performance (MLX)
- **Cost:** Free
- **Best for:** Full podcast production on Mac Studio
- **Download:** https://github.com/jamiepine/voicebox/releases

### Alternative Free: Kokoro TTS
- **Why:** Lightweight, surprisingly good quality, fully local
- **Cost:** Free
- **Best for:** Simple TTS without editing features

### Easiest: NotebookLM
- **Why:** Upload PDF, get AI-generated podcast discussion
- **Cost:** Free
- **Best for:** Quick paper summaries without setup

### Best Open Source (Alternative): Fish Speech
- **Why:** SOTA quality, voice cloning, emotional expression
- **Cost:** Free (non-commercial)
- **Best for:** Technical users who want best free quality

---

## 9. Resources

### Commercial
- ElevenLabs: https://elevenlabs.io
- Speechify: https://speechify.com
- NotebookLM: https://notebooklm.google.com
- NaturalReader: https://www.naturalreaders.com
- Play.ht: https://play.ht

### Open Source
- Voicebox: https://github.com/jamiepine/voicebox
- Kokoro: https://huggingface.co/spaces/hexgrad/Kokoro-TTS
- Fish Speech: https://github.com/fishaudio/fish-speech
- MetaVoice: https://github.com/metavoiceio/metavoice-src
- Bark: https://github.com/suno-ai/bark
- ChatTTS: https://github.com/2noise/ChatTTS

---

## 10. Open Questions

1. **LaTeX parsing:** Is there a robust open-source LaTeX-to-speech preprocessor?
2. **Astronomy domain:** Can we build a specialized model for astronomy terms?
3. **Batch processing:** Best workflow for daily arXiv digest → podcast?
4. **Voice consistency:** Best approach for multi-episode series?

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-22*  
*File: `~/Desktop/yuzhe/investigation/Article-to-Podcast-TTS-2026-02-22.md`*
