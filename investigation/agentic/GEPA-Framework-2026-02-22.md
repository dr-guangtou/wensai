---
title: "GEPA (Genetic-Pareto) Framework"
date: 2026-02-22
topic: "Prompt Optimization & AI System Optimization"
category: "AI/ML Research"
tags: ["gepa", "prompt-optimization", "genetic-algorithm", "pareto", "dspy", "reinforcement-learning"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# GEPA (Genetic-Pareto) Framework Investigation Report

**Research Date:** 2026-02-22  
**Investigation Topic:** GEPA - Reflective Prompt Evolution Framework  
**Focus Areas:** Basic Concepts, Applications, Workflow Integration

---

## 1. Executive Summary

**GEPA (Genetic-Pareto)** is a state-of-the-art framework for optimizing any system with textual parameters (prompts, code, configurations, agent architectures) using LLM-based reflective evolution and Pareto-efficient search. Unlike traditional reinforcement learning (RL) that requires thousands of rollouts, GEPA achieves comparable or better results with **35x fewer evaluations** (100-500 vs 5,000-25,000+).

**Key Innovation:** Instead of collapsing execution traces into scalar rewards, GEPA uses LLMs to read full diagnostic feedback (error messages, profiling data, reasoning logs) and propose targeted fixes through natural language reflection.

---

## 2. Core Concepts

### 2.1 The Problem with Traditional Optimization

| Approach | Limitation | Why It Fails |
|----------|------------|--------------|
| **Reinforcement Learning (GRPO)** | Requires 5,000-25,000+ rollouts | Expensive, slow, sample-inefficient |
| **Bayesian Optimization** | Scalar rewards only | Knows *that* a candidate failed, not *why* |
| **Manual Prompt Engineering** | Human intuition, trial-and-error | Time-consuming, inconsistent |

**The Key Insight:** Traditional optimizers receive only a scalar score. They know a candidate failed but cannot see the stack trace, error message, or reasoning that would explain *why*.

### 2.2 How GEPA Works: The 5-Step Process

```
┌─────────────────────────────────────────────────────────────────────┐
│ 1. SELECT from Pareto Front                                         │
│    Pick candidate excelling on some examples/tasks                  │
│                         ↓                                           │
│ 2. EXECUTE on Minibatch                                             │
│    Run candidate, capture FULL execution traces                     │
│    (errors, logs, profiler output, reasoning chains)               │
│                         ↓                                           │
│ 3. REFLECT with LLM                                                 │
│    LLM reads traces, diagnoses failures in natural language        │
│    "The error occurs because X; suggest fix Y"                      │
│                         ↓                                           │
│ 4. MUTATE Candidate                                                 │
│    Generate improved candidate incorporating:                       │
│    - Lessons from reflection                                        │
│    - Accumulated wisdom from all ancestors                          │
│                         ↓                                           │
│ 5. ACCEPT if Improved                                               │
│    Add to pool, update Pareto frontier                              │
│    Repeat until convergence                                         │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.3 Key Technical Innovations

#### A. Actionable Side Information (ASI)
**ASI is the text-optimization analogue of gradients.**

Where gradients tell numerical optimizers which direction to move, ASI tells an LLM proposer why a candidate failed and how to fix it.

**Examples of ASI:**
- Error messages and stack traces
- Profiler output ("function X is 90% of runtime")
- Reasoning chain logs
- Compiler warnings
- Test failure details
- Multi-objective scores

**ASI in Code:**
```python
import gepa.optimize_anything as oa

def evaluate(candidate: str) -> float:
    result = run_my_system(candidate)
    
    # ASI: Diagnostic feedback for the LLM proposer
    oa.log(f"Error: {result.stderr}")
    oa.log(f"Output: {result.stdout}")
    oa.log(f"Runtime: {result.time_ms}ms")
    
    return result.score
```

#### B. Pareto-Efficient Search
Traditional optimizers collapse multi-dimensional performance into a single average score. This hides which aspects are strong/weak.

**GEPA's Approach:**
- Track scores per task/metric individually
- Maintain Pareto frontier: candidates that are best at *something* survive
- Reflection minibatch = 2-3 examples (focused improvement)
- System-aware merge: combine strengths of two Pareto-optimal candidates

**Example:**
```
Candidate A: 90% accuracy, 10s runtime (fast but inaccurate)
Candidate B: 50% accuracy, 1s runtime (slow but accurate)

Traditional: Pick one (averaging discards both advantages)
GEPA: Keep both on frontier, merge to get:
Candidate C: 85% accuracy, 2s runtime (combines strengths)
```

#### C. Three Optimization Modes

| Mode | Use Case | API |
|------|----------|-----|
| **Single-Task Search** | Solve one hard problem | `optimize_anything(seed, evaluator)` |
| **Multi-Task Search** | Batch of related problems with cross-transfer | `optimize_anything(seed, evaluator, dataset)` |
| **Generalization** | Build skill transferring to unseen problems | `optimize_anything(seed, evaluator, dataset, valset)` |

---

## 3. Proven Results & Impact

### 3.1 Key Performance Metrics

| Metric | Result | Context |
|--------|--------|---------|
| **Cost Reduction** | 90x cheaper | Open-source + GEPA beats Claude Opus 4.1 (Databricks) |
| **Speedup vs RL** | 35x faster | 100-500 evals vs 5,000-25,000+ for GRPO |
| **Accuracy Gain** | 32% → 89% | ARC-AGI agent via architecture discovery |
| **Cost Savings** | 40.2% | Cloud scheduling policy vs expert heuristics |
| **Resolve Rate** | 55% → 82% | Coding agent on Jinja via auto-learned skills |
| **AIME Math** | +10 points | GPT-4.1 Mini: 46.6% → 56.6% (prompt only) |

### 3.2 Production Use Cases

**Enterprise:**
- **Databricks:** 90x cost reduction, 3-7% performance gains
- **Shopify:** Severely under-hyped according to CEO Tobi Lutke
- **OpenAI:** Featured in official cookbook for self-evolving agents
- **Dropbox, Pydantic, MLflow, Comet ML:** Production deployments

**Research:**
- **CUDA Kernel Generation:** 87% match/beat baseline, 25% 20%+ faster
- **Circle Packing:** Outperforms AlphaEvolve
- **Blackbox Optimization:** Matches Optuna (industry standard)
- **ARC-AGI:** Nearly triples Gemini Flash accuracy (32.5% → 89.5%)

---

## 4. How You Can Use GEPA

### 4.1 Installation

```bash
pip install gepa
```

### 4.2 Quick Start: Prompt Optimization

```python
import gepa

# Load dataset
trainset, valset, _ = gepa.examples.aime.init_dataset()

# Define initial prompt
seed_prompt = {
    "system_prompt": "You are a helpful assistant. Answer the question."
}

# Run optimization
result = gepa.optimize(
    seed_candidate=seed_prompt,
    trainset=trainset,
    valset=valset,
    task_lm="openai/gpt-4.1-mini",
    max_metric_calls=150,
    reflection_lm="openai/gpt-5",
)

print("Optimized prompt:", result.best_candidate['system_prompt'])
```

### 4.3 The `optimize_anything` API

For optimizing any text artifact (code, configs, SVGs, etc.):

```python
import gepa.optimize_anything as oa
from gepa.optimize_anything import optimize_anything, GEPAConfig, EngineConfig

def evaluate(candidate: str) -> float:
    """Your evaluation function."""
    result = run_my_system(candidate)
    
    # ASI: Critical diagnostic feedback
    oa.log(f"Error: {result.error}")
    oa.log(f"Output: {result.output}")
    
    return result.score

result = optimize_anything(
    seed_candidate="<your initial artifact>",
    evaluator=evaluate,
    objective="Describe what you want to optimize for",
    config=GEPAConfig(
        engine=EngineConfig(max_metric_calls=100)
    ),
)
```

### 4.4 Integration with DSPy (Recommended)

```python
import dspy

# Define your program
class MyRAG(dspy.Module):
    def __init__(self):
        self.retrieve = dspy.Retrieve(k=3)
        self.generate = dspy.ChainOfThought("context, question -> answer")
    
    def forward(self, question):
        context = self.retrieve(question).passages
        return self.generate(context=context, question=question)

# Optimize with GEPA
optimizer = dspy.GEPA(
    metric=your_metric,
    max_metric_calls=150,
    reflection_lm="openai/gpt-5"
)

optimized = optimizer.compile(
    student=MyRAG(),
    trainset=trainset,
    valset=valset
)
```

---

## 5. Applications for Your Workflow

### 5.1 Optimizing Agent Prompts (Claude Code, OpenClaw)

**Use Case:** Automatically improve prompts for your research assistant agents

```python
import gepa

# Define evaluation metric for your agent
def evaluate_agent_prompt(candidate_prompt: dict) -> float:
    """Evaluate how well the prompt works for astronomy queries."""
    agent = configure_agent(candidate_prompt['system_prompt'])
    
    # Test on benchmark astronomy questions
    test_questions = load_astronomy_benchmark()
    scores = []
    
    for q in test_questions:
        response = agent.ask(q)
        score = grade_astronomy_response(response, q.expected)
        scores.append(score)
        
        # ASI: Why did it fail?
        if score < 0.5:
            oa.log(f"Question: {q.text}")
            oa.log(f"Error: Response lacked {q.required_concepts}")
    
    return np.mean(scores)

# Optimize
result = gepa.optimize(
    seed_candidate={"system_prompt": "You are a research assistant..."},
    trainset=astronomy_train,
    valset=astronomy_val,
    task_lm="claude-sonnet-4.5",
    evaluator=evaluate_agent_prompt,
)
```

**Benefits:**
- Systematically improve prompt quality
- Discover unexpected prompt strategies
- Transfer optimized prompts across models
- 10-30% accuracy gains typical

### 5.2 Optimizing RAG Pipelines

**Use Case:** Improve retrieval quality for astronomy literature

```python
from gepa.adapters import GenericRAGAdapter

# Optimize RAG: retrieval count, reranking, chunk size
adapter = GenericRAGAdapter(
    vector_store=chroma_client,
    embedding_model="text-embedding-3-large"
)

result = gepa.optimize(
    seed_candidate={
        "retrieval_k": 5,
        "rerank": True,
        "chunk_size": 1000
    },
    trainset=arxiv_qa_pairs,
    valset=held_out_papers,
    adapter=adapter
)
```

**Benefits:**
- Optimize retrieval parameters automatically
- Discover optimal chunking strategies
- Improve citation accuracy

### 5.3 Code Generation & Scientific Computing

**Use Case:** Optimize data analysis pipelines

```python
import gepa.optimize_anything as oa

def evaluate_analysis_pipeline(candidate_code: str) -> float:
    """Evaluate code for analyzing telescope data."""
    try:
        # Execute candidate
        exec(candidate_code, globals())
        result = analyze_fits_data(test_file)
        
        # Score: accuracy vs runtime tradeoff
        accuracy = check_results(result, ground_truth)
        runtime = result.execution_time
        
        # ASI
        oa.log(f"Runtime: {runtime}s")
        if runtime > 60:
            oa.log("Warning: Exceeds 1 minute threshold")
        
        return accuracy * 0.7 + (1 / (1 + runtime/60)) * 0.3
        
    except Exception as e:
        oa.log(f"Error: {str(e)}")
        return 0.0

result = oa.optimize_anything(
    seed_candidate=baseline_pipeline_code,
    evaluator=evaluate_analysis_pipeline,
    objective="Optimize FITS data analysis for accuracy and speed"
)
```

### 5.4 Agent Architecture Discovery

**Use Case:** Design optimal multi-agent systems for research tasks

```python
# Optimize agent architecture for paper summarization
def evaluate_architecture(agent_code: str) -> float:
    """Evaluate multi-agent summarization system."""
    agent_system = build_agent_from_code(agent_code)
    
    scores = []
    for paper in test_papers:
        summary = agent_system.summarize(paper)
        
        # Metrics: accuracy, completeness, conciseness
        acc = check_factual_accuracy(summary, paper)
        comp = check_completeness(summary, paper)
        concise = 1 / (1 + len(summary) / 1000)
        
        scores.append((acc + comp + concise) / 3)
        
        # ASI for failed papers
        if acc < 0.7:
            oa.log(f"Missed key findings: {paper.key_findings}")
    
    return np.mean(scores)

# Start from simple agent, evolve complex system
result = oa.optimize_anything(
    seed_candidate=simple_agent_stub,
    evaluator=evaluate_architecture,
    dataset=training_papers,
    valset=validation_papers
)
```

**Real-world result:** ARC-AGI agent evolved from 10-line stub to 300+ line system, accuracy 32.5% → 89.5%

### 5.5 Workflow Optimization

**Use Case:** Optimize daily research workflows (arXiv digest, literature review)

```python
# Optimize your daily arXiv digest generation
def evaluate_digest_workflow(workflow_config: str) -> float:
    """Evaluate arXiv digest quality."""
    config = parse_config(workflow_config)
    
    # Generate digests for past week
    digests = []
    for day in last_7_days:
        digest = generate_digest(day, config)
        digests.append(digest)
    
    # Metrics
    relevance = rate_relevance(digests, your_interests)
    diversity = check_topic_diversity(digests)
    actionability = rate_actionability(digests)
    
    # ASI: Which papers were missed?
    missed = find_missed_important_papers(digests)
    if missed:
        oa.log(f"Missed important papers: {missed}")
    
    return (relevance + diversity + actionability) / 3

result = oa.optimize_anything(
    seed_candidate=current_digest_config,
    evaluator=evaluate_digest_workflow,
    objective="Optimize arXiv digest for relevance and diversity"
)
```

---

## 6. Advantages for Research Workflows

### 6.1 Why GEPA Fits Research

| Research Challenge | How GEPA Helps |
|-------------------|----------------|
| **Expensive evaluations** | 35x fewer evaluations than RL |
| **No training data** | Works with 3-10 examples |
| **Interpretability** | Human-readable optimization traces |
| **API-only models** | Optimize Claude, GPT-4, Gemini directly |
| **Complex agents** | Optimize entire architectures, not just prompts |
| **Multi-objective** | Balance accuracy, speed, cost automatically |

### 6.2 When to Use GEPA

**GEPA shines when:**
- ✓ Evaluations are expensive (simulations, API calls)
- ✓ Data is scarce (new domain, novel tasks)
- ✓ You need interpretability (debuggable optimization)
- ✓ Working with API-only models (no fine-tuning access)
- ✓ Multi-objective optimization needed

**Use alternatives when:**
- ✗ You have 100,000+ cheap rollouts (use RL)
- ✗ Simple prompt with clear best practice (manual tuning)
- ✗ Single-shot optimization (no iterative improvement needed)

---

## 7. Getting Started Checklist

### Week 1: Basic Prompt Optimization
- [ ] Install GEPA: `pip install gepa`
- [ ] Run AIME example from documentation
- [ ] Optimize one agent prompt in your workflow
- [ ] Measure before/after performance

### Week 2: Custom Evaluation
- [ ] Identify one workflow to optimize
- [ ] Write evaluation function with ASI logging
- [ ] Run `optimize_anything` with your evaluator
- [ ] Analyze optimization traces

### Week 3: Production Integration
- [ ] Integrate optimized prompts into OpenClaw
- [ ] Set up continuous evaluation pipeline
- [ ] Deploy and monitor performance
- [ ] Iterate based on production feedback

---

## 8. Resources

### Official Links
- **GitHub:** https://github.com/gepa-ai/gepa
- **Documentation:** https://gepa-ai.github.io/gepa/
- **Paper:** https://arxiv.org/abs/2507.19457 (ICLR 2026 Oral)
- **PyPI:** https://pypi.org/project/gepa/

### Community
- **Discord:** https://discord.gg/WXFSeVGdbW
- **Slack:** https://join.slack.com/t/gepa-ai/shared_invite/...
- **Twitter/X:** https://x.com/gepa_ai

### Tutorials
- **DSPy Integration:** https://dspy.ai/tutorials/gepa_ai_program/
- **OpenAI Cookbook:** https://cookbook.openai.com/examples/partners/self_evolving_agents/
- **HuggingFace Cookbook:** https://huggingface.co/learn/cookbook/en/dspy_gepa

---

## 9. Summary

**GEPA is a game-changer for optimizing AI systems because it:**

1. **Achieves RL-level performance with 35x fewer evaluations** — critical when API calls or simulations are expensive

2. **Uses natural language reflection** — the LLM reads diagnostic traces and proposes targeted fixes, just like an engineer debugging code

3. **Maintains Pareto frontiers** — preserves candidates that excel at different aspects, then merges their strengths

4. **Optimizes anything representable as text** — prompts, code, configs, agent architectures, even SVGs and 3D models

5. **Requires minimal setup** — pip install, define evaluator, run optimization

**For your workflow specifically:**
- Optimize OpenClaw agent prompts for astronomy queries
- Improve RAG retrieval for literature reviews
- Evolve multi-agent systems for research tasks
- Optimize data analysis pipelines
- Fine-tune daily workflows (arXiv digest, paper summarization)

**Bottom line:** If you can measure it, GEPA can optimize it — with far less cost and far more interpretability than traditional methods.

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-22*  
*File: `~/Desktop/yuzhe/investigation/GEPA-Framework-2026-02-22.md`*
