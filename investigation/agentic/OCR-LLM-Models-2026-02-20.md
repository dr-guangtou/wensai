---
title: "OCR and AI Models Investigation Report"
date: 2026-02-20
topic: "OCR & Vision-Language Models"
category: "AI/ML Research"
tags: ["ocr", "vlm", "ai-models", "qwen", "mac-deployment", "chinese-support", "open-source"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
focus_areas: ["efficiency", "cost", "mac-deployment", "chinese-support"]
---

# OCR and AI Models Investigation Report

**Research Date:** 2026-02-20  
**Investigation Topic:** State-of-the-Art OCR and Vision-Language Models  
**Focus Areas:** Efficiency, Cost, Open Source Options, Mac Deployment, Chinese Support

---

## 1. Executive Summary

The OCR landscape has evolved significantly from traditional pipeline-based OCR (OCR-1.0) to end-to-end Vision-Language Models (OCR-2.0). The current state-of-the-art includes:

- **Commercial APIs**: GPT-4o, Gemini 1.5 Pro, Claude 3.5 Sonnet
- **Open Source VLMs**: Qwen2.5-VL, GOT-OCR2.0, MiniCPM-V 2.6, Florence-2
- **Traditional OCR**: PaddleOCR, Tesseract (still relevant for basic tasks)

**Key Finding**: For Mac Studio deployment, models in the 7B parameter range with 4-bit quantization are optimal. The best Chinese-supporting models are Qwen2.5-VL and MiniCPM-V 2.6.

---

## 2. State-of-the-Art Models

### 2.1 Commercial/Cloud Models

| Model | Provider | Key Strengths | OCR Focus |
|-------|----------|---------------|-----------|
| **GPT-4o** | OpenAI | General-purpose VLM, excellent reasoning | Document understanding, charts |
| **GPT-4V** | OpenAI | Vision capabilities | Strong on TextVQA, DocVQA |
| **Gemini 1.5 Pro** | Google | 1M+ context, video understanding | Long document OCR |
| **Claude 3.5 Sonnet** | Anthropic | Document analysis, reasoning | PDF understanding |
| **Florence-2** | Microsoft | 0.77B parameters, efficient | Specialized OCR task prompts |

**Benchmarks (DocVQA test):**
- Qwen2-VL-7B: 94.5
- Qwen2.5-VL-7B: **95.7** (SOTA among open 7B models)
- MiniCPM-V 2.6 (8B): 93
- GPT-4o-mini: N/A (proprietary)

### 2.2 OCR-Specific Foundation Models

#### GOT-OCR2.0 (General OCR Theory)
- **Developed by:** UCAS, StepFun
- **Paper:** arXiv:2409.01704 (Sept 2024)
- **Parameters:** ~580M (efficient)
- **Key Innovation:** Unified end-to-end OCR-2.0 model
- **Features:**
  - Plain text OCR
  - Formatted text OCR (preserves layout)
  - Fine-grained OCR (region-specific)
  - Multi-crop/multi-page support
  - Renders OCR results to HTML
- **Deployment:** Available via Hugging Face, ModelScope
- **GitHub:** https://github.com/Ucas-HaoranWei/GOT-OCR2.0
- **Downloads:** 1M+ on Hugging Face

#### Florence-2 (Microsoft)
- **Parameters:** 0.23B (base), 0.77B (large)
- **Architecture:** Encoder-decoder (Vision Transformer + BART-style)
- **Training Data:** FLD-5B (5.4B annotations, 126M images)
- **OCR Tasks:** `<OCR>`, `<OCR_WITH_REGION>`
- **Advantage:** Extremely efficient, runs on modest hardware
- **COCO Det. val2017:** 37.5 mAP (large)

---

## 3. Open Source Options

### 3.1 Large Vision-Language Models (7B+ parameters)

| Model | Params | License | Best For |
|-------|--------|---------|----------|
| **Qwen2.5-VL-7B** | 7B | Apache-2.0 | Best overall open VLM |
| **Qwen2-VL-7B** | 7B | Apache-2.0 | Strong predecessor |
| **LLaVA-NeXT (v1.6)** | 7B/13B/34B | LLaMA 2 License | General multimodal |
| **MiniCPM-V 2.6** | 8B | Apache-2.0 | Best efficiency/performance ratio |
| **InternVL2-8B** | 8B | Various | Strong document understanding |

**OCRBench Scores (Higher is better):**
- MiniCPM-V 2.6: **852**
- Qwen2.5-VL-7B: **864**
- Qwen2-VL-7B: 845
- GPT-4o: 785
- InternVL2-8B: 794

### 3.2 Document Understanding (OCR-free)

| Model | Params | Purpose |
|-------|--------|---------|
| **Donut** | ~200M | OCR-free document parsing |
| **Nougat** | ~350M | Academic paper OCR |

---

## 4. Mac Studio Deployment

### 4.1 Hardware Context

**Mac Studio (M1 Ultra) Specs:**
- CPU: 20-core (16 performance + 4 efficiency)
- GPU: 64-core Neural Engine: 32-core
- Unified Memory: 64GB
- Memory Bandwidth: 800 GB/s

### 4.2 Deployment Frameworks

| Framework | Best For | Notes |
|-----------|----------|-------|
| **MLX (Apple)** | Native Apple Silicon | Fastest, easiest |
| **llama.cpp** | GGUF quantization | CPU/GPU hybrid |
| **Ollama** | Easy local deployment | Good model library |
| **Transformers** | Full feature set | May need optimization |

### 4.3 Recommended Mac-Compatible Models

#### Via MLX (mlx-community)
```bash
pip install mlx-vlm
python -m mlx_vlm.generate --model mlx-community/Qwen2-VL-7B-Instruct-4bit
```

**Available MLX Models:**
- `mlx-community/Qwen2-VL-7B-Instruct-4bit`
- Various quantized versions for memory efficiency

#### Via Ollama
```bash
ollama run minicpm-v
ollama run llava
ollama run llama3.2-vision
```

**Available Vision Models in Ollama:**
- `minicpm-v` (8B) - Good for OCR
- `llava` (7B/13B/34B) - General vision
- `llama3.2-vision` (11B/90B) - Latest Meta VLM
- `gemma3` (4B/12B/27B) - Google vision model

### 4.4 Quantization for Mac

| Precision | Memory (7B model) | Speed | Quality |
|-----------|-------------------|-------|---------|
| FP16 | ~14 GB | Baseline | Best |
| INT8 | ~7 GB | 2x faster | Slight loss |
| 4-bit | ~4 GB | 3-4x faster | Acceptable |
| GGUF Q4_K_M | ~4-5 GB | Fast | Good balance |

**Recommendation for Mac Studio:**
- Use 4-bit quantized models for 7B parameter VLMs
- 64GB memory can run multiple models simultaneously
- MLX framework provides best performance on Apple Silicon

---

## 5. Chinese Language Support

### 5.1 Best Models for Chinese OCR

| Model | Chinese Capability | Notes |
|-------|-------------------|-------|
| **Qwen2.5-VL** | Excellent | Native Chinese training |
| **MiniCPM-V 2.6** | Excellent | Optimized for CJK |
| **GOT-OCR2.0** | Good | Tested on Chinese documents |
| **Donut** | Limited | Primarily English |

### 5.2 Chinese Benchmarks

**MTVQA (Multilingual Text VQA):**
- Qwen2-VL-7B: 26.3 (strong on Chinese text)

**COCO-CN (Chinese image captions):**
- Qwen models excel here

### 5.3 Vertical Text & Handwriting

- **Vertical Text**: Qwen2.5-VL and MiniCPM-V handle this well
- **Handwriting**: GOT-OCR2.0 has specific fine-grained modes
- **Mixed Documents**: All major VLMs handle mixed Chinese/English

---

## 6. Cost Analysis

### 6.1 Commercial API Pricing (Approximate)

| Service | Input/1M tokens | Output/1M tokens | Notes |
|---------|-----------------|------------------|-------|
| **OpenAI GPT-4o** | $2.50 | $10.00 | Vision included |
| **OpenAI GPT-4o-mini** | $0.15 | $0.60 | Cheaper, less capable |
| **Anthropic Claude 3.5** | $3.00 | $15.00 | Excellent for docs |
| **Google Gemini 1.5 Flash** | $0.075 | $0.30 | Cost-effective |
| **Google Gemini 1.5 Pro** | $1.25 | $5.00 | High quality |

### 6.2 Self-Hosted / Local Cost

**One-time Costs:**
- Mac Studio (already owned): $0 marginal
- Model downloads: Free (Hugging Face)

**Operational Costs:**
- Electricity: Negligible for inference
- Maintenance: Personal time only

**Break-even Analysis:**
- If processing >1000 pages/month, local deployment saves money
- At GPT-4o rates: 1000 pages ≈ $25-50 in API costs
- Local: $0 after initial setup

### 6.3 Cloud Inference Options

| Platform | Pricing Model | Good For |
|----------|---------------|----------|
| **Hugging Face Inference** | Pay per request | Occasional use |
| **Together AI** | Per token | High volume |
| **Groq** | Per token | Very fast inference |
| **Replicate** | Per prediction | Easy deployment |

---

## 7. Recommendations

### 7.1 For Mac Studio (Your Setup)

**Best Overall:**
1. **Qwen2.5-VL-7B (4-bit MLX)** - Best balance of accuracy and speed
2. **MiniCPM-V 2.6 (Ollama)** - Excellent OCR efficiency, 640 tokens per image

**Lightweight Option:**
- **Florence-2-large** (0.77B) - Fast, accurate for standard OCR tasks

**Specialized OCR:**
- **GOT-OCR2.0** - For formatted documents, academic papers

### 7.2 Quick Start Commands

```bash
# Install MLX VLM
pip install mlx-vlm

# Run Qwen2-VL on Mac
python -m mlx_vlm.generate \
  --model mlx-community/Qwen2-VL-7B-Instruct-4bit \
  --image path/to/image.jpg \
  --prompt "Extract all text from this image"

# Or use Ollama
ollama pull minicpm-v
ollama run minicpm-v
```

### 7.3 For Different Use Cases

| Use Case | Recommended Model | Why |
|----------|-------------------|-----|
| **General OCR** | Qwen2.5-VL-7B | Best accuracy |
| **Chinese documents** | Qwen2.5-VL or MiniCPM-V | Native CJK support |
| **Fast batch processing** | Florence-2 | Small, efficient |
| **Academic papers** | GOT-OCR2.0 | Preserves formatting |
| **Low resource** | Florence-2-base (0.23B) | Runs on any hardware |

---

## 8. Resources & Links

### Model Repositories
- **Qwen2.5-VL**: https://huggingface.co/Qwen/Qwen2.5-VL-7B-Instruct
- **GOT-OCR2.0**: https://huggingface.co/stepfun-ai/GOT-OCR2_0
- **MiniCPM-V**: https://huggingface.co/openbmb/MiniCPM-V-2_6
- **Florence-2**: https://huggingface.co/microsoft/Florence-2-large
- **MLX Community**: https://huggingface.co/mlx-community

### GitHub Repos
- **GOT-OCR2.0**: https://github.com/Ucas-HaoranWei/GOT-OCR2.0
- **MiniCPM-V**: https://github.com/OpenBMB/MiniCPM-V
- **MLX Examples**: https://github.com/ml-explore/mlx-examples
- **mlx-vlm**: https://github.com/Blaizzy/mlx-vlm

### Tools
- **Ollama**: https://ollama.com (for easy local deployment)
- **PaddleOCR**: Traditional OCR alternative

---

## 9. Next Steps & Open Questions

### To Investigate Further
1. **Quantization impact on Chinese OCR accuracy** - Need specific benchmarks
2. **Batch processing speeds** on Mac Studio for production workloads
3. **Fine-tuning** options for domain-specific documents
4. **Comparison with traditional OCR** (PaddleOCR, EasyOCR) on specific tasks
5. **Document parsing pipelines** - Layout preservation vs. plain text

### Potential Follow-up Investigations
- **Multimodal RAG** - Combining OCR with retrieval
- **Video OCR** - Extracting text from video frames
- **Handwriting recognition** benchmarks on Chinese text
- **Production deployment** strategies for document processing pipelines

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-20*
