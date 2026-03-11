---
title: "Codified Context: Infrastructure for AI Agents in a Complex Codebase"
authors:
  - Anonymous (experience report)
source: "arXiv:2602.20478v1"
tags:
  - paper
  - ai/agent
  - dev/tool
  - ai/llm
date_published: 2026-02-19
date_read: 2026-03-01
type: paper_summary
category: ai
venue: "Preprint (Software Engineering, AI Agents)"
---
# Codified Context: Infrastructure for AI Agents in a Complex Codebase

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | Codified Context: Infrastructure for AI Agents in a Complex Codebase |
| **arXiv ID** | 2602.20478v1 |
| **Published** | February 19, 2026 |
| **Type** | Experience report (systems paper) |
| **Project size** | 108,000 lines of C# (distributed system) |
| **Context infrastructure** | ~26,000 lines across 54 files |

---

## The Big Idea (In Simple Terms)

**The problem:** AI coding assistants (Claude Code, Cursor, GitHub Copilot) have **no persistent memory**. Every session starts fresh—they forget:
- Project conventions
- Past mistakes and fixes
- Architectural decisions
- What worked and what didn't

**The current solution:** Developers write manifest files like `AGENTS.md`, `.cursorrules`, or `CLAUDE.md`. These work for small projects but **don't scale**—you can't describe a 100,000-line system in a single file.

**This paper's solution:** A **three-tier architecture** for organizing project knowledge:
1. **Hot memory** (always loaded): Core rules and conventions
2. **Specialist agents** (invoked per task): Domain experts for specific areas
3. **Cold memory** (retrieved on demand): Detailed specifications

**Key insight:** Treat documentation as **infrastructure**—structured artifacts written for AI consumption, not human reading.

---

## Why This Matters

### The Scaling Problem

| Project Size | Manifest Approach | Problem |
|--------------|------------------|---------|
| 1,000 lines | Single AGENTS.md works | ✅ Fine |
| 10,000 lines | AGENTS.md getting long | ⚠️ Awkward |
| 100,000 lines | Can't fit in one file | ❌ Breaks down |

The author built a **108,000-line C# distributed system** using Claude Code, and discovered that single-file manifests simply don't work at that scale.

### The Author's Background

Interesting detail: the author is a **chemist by training**, not a software engineer. They built this complex system entirely through AI-assisted coding. This makes the paper relevant to **domain experts using AI to build software outside their expertise**—like astronomers building data pipelines.

---

## The Three-Tier Architecture

### Tier 1: Project Constitution (Hot Memory)

**What it is:** A single file (~660 lines) loaded into **every session automatically**.

**What it contains:**
- Code quality standards
- Naming conventions
- Build commands
- Architectural summaries (with links to detailed docs)
- Checklists for common operations
- Known failure modes
- **Trigger tables** for routing tasks to specialist agents

**Design constraint:** Must be concise. The constitution answers "what rules must you ALWAYS follow?"—not "how does subsystem X work?"

**Analogy:** Like a company's employee handbook—the rules everyone needs to know, not the technical manuals.

### Tier 2: Specialized Agents (Domain Experts)

**What it is:** 19 agent specification files (115–1,233 lines each, ~9,300 lines total).

**What they do:** Each agent is a "domain expert" for a specific area:
- Network protocol design
- Coordinate systems
- Debugging
- Architecture review
- Testing
- etc.

**Key insight:** Over **half of each agent's content** is project-specific domain knowledge (code patterns, formulas, known failure modes)—not just behavioral instructions.

**Why this matters:** Agents in complex domains fail without pre-loaded context. The "brevity bias" (tendency toward short, generic prompts) produces unreliable results.

**Trigger tables:** The constitution embeds rules like:
- "If editing `*Network*.cs` → invoke network-protocol-designer"
- "If editing `*Coordinate*.cs` → invoke coordinate-wizard"

This automates the decision of which expert to consult.

### Tier 3: Knowledge Base (Cold Memory)

**What it is:** 34 specification documents (~16,250 lines) retrieved **on demand**.

**What they contain:**
- Detailed subsystem documentation
- Correctness requirements
- Known failure modes with fixes
- Code patterns and examples

**Format:** Written explicitly for AI consumption:
- Explicit file paths and parameter names
- Symptom-cause-fix tables
- Code examples with expected behavior

**Retrieval:** Served through an **MCP (Model Context Protocol) server** with tools like:
- `find_relevant_context(task)`
- `suggest_agent(task)`
- `search_context_documents(query)`

---

## Visual Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     HUMAN PROMPT                            │
└─────────────────────┬───────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  SESSION (always loads Constitution)                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
┌───────────┐  ┌───────────┐  ┌───────────┐
│  TIER 1   │  │  TIER 2   │  │  TIER 3   │
│Constitution│  │Specialist │  │ Knowledge │
│~660 lines │  │  Agents   │  │   Base    │
│           │  │19 agents  │  │ 34 docs   │
│(ALWAYS    │  │~9,300 lines│  │~16,250 ln │
│ LOADED)   │  │           │  │           │
└───────────┘  │(PER TASK) │  │(ON DEMAND)│
               └───────────┘  └───────────┘
                     ▲             ▲
                     │             │
               ┌─────┴─────┐ ┌─────┴─────┐
               │  Trigger  │ │MCP Server │
               │   Table   │ │ Retrieval │
               └───────────┘ └───────────┘
```

---

## How the Architecture Evolved

The infrastructure wasn't designed upfront—it **emerged** from failure patterns:

| Phase | Days | What Happened |
|-------|------|---------------|
| **Phase 1** | 1–10 | Only a ~100-line constitution. Worked for initial prototyping. |
| **Phase 2** | 11–30 | Specifications and initial agents emerged for **high-failure domains** (networking, coordinates). When debugging consumed entire sessions without resolution, they created a specialized agent instead. |
| **Phase 3** | 31–70 | MCP retrieval service integrated. Agent pool expanded as new domains needed specialization. |

**Practical heuristic:** "If debugging a particular domain consumed an extended session without resolution, it was faster to create a specialized agent and restart than to continue the unguided session."

---

## Key Metrics

| Metric | Value |
|--------|-------|
| **C# code produced** | 108,000 lines |
| **Context infrastructure** | ~26,000 lines |
| **Knowledge-to-code ratio** | 24.2% |
| **Development sessions** | 283 |
| **Development days** | 70 |
| **Human prompts** | 2,801 |
| **Agent invocations** | 1,197 |
| **Agent turns** | 16,522 |
| **Specialist agents** | 19 |
| **Knowledge documents** | 34 |

---

## Key Insights

### 1. Documentation as Infrastructure

> The primary audience is an AI agent, not a developer.

This is a shift in thinking:
- **Traditional docs:** Written for humans, AI might read them
- **Codified context:** Written for AI, humans maintain them

The documents are **load-bearing**—the AI depends on them to produce correct output.

### 2. Agents Need Embedded Knowledge

**The brevity bias:** There's a tendency to make prompts short and generic. But this paper shows:
> Agents in complex domains fail without pre-loaded context.

The solution: Embed domain knowledge **directly into agent specifications** (often 50%+ of content), not just rely on retrieval.

### 3. Failure-Driven Agent Creation

Agents were created when:
- A domain repeatedly caused debugging failures
- The same knowledge had to be re-explained multiple times
- Sessions stalled without resolution

**Practical rule:** "If you're explaining the same thing three times, create an agent."

### 4. Intentional Overlap Between Tiers

The tiers aren't cleanly separated:
- Agents (Tier 2) embed knowledge that also exists in documents (Tier 3)
- This redundancy is **intentional**—complex domains need complete mental models

### 5. Trigger Tables Automate Decisions

Instead of remembering "when I work on networking, I should invoke the networking agent," the trigger table automates this:
- File pattern → Agent
- Reduces cognitive load
- Ensures consistency

---

## Comparison to Current Approaches

| Approach | Scale | Memory | Complexity |
|----------|-------|--------|------------|
| **No manifest** | Any | None | Simple but unreliable |
| **Single AGENTS.md** | ~10K lines | Session-level | Works for small projects |
| **Cursor codebase indexing** | Large | Embeddings | Indexes code, not intent |
| **This paper's approach** | 100K+ lines | Three-tier | Scales but requires maintenance |

**Key difference from codebase indexing:** Tools like Cursor index **code**. This approach indexes **knowledge about code**—design intent, constraints, failure modes not present in any single source file.

---

## What This Means for You

### Your Current Setup

You already use:
- `AGENTS.md` in your workspace
- `MEMORY.md` for long-term context
- `memory/YYYY-MM-DD.md` for daily logs

**The paper validates this approach** but shows how to scale it further.

### What You Could Add

| Your Current Setup | Paper's Equivalent | Potential Upgrade |
|-------------------|-------------------|-------------------|
| Single AGENTS.md | Constitution (Tier 1) | ✅ You have this |
| (None) | Specialist agents (Tier 2) | 📝 Could add for MUST domains |
| MEMORY.md + daily logs | Knowledge base (Tier 3) | 📝 Could organize by topic |

### Practical Applications for Your Work

**1. MUST Telescope Domains**
If you're using AI for MUST-related coding:
- **spectrograph-agent:** Expert in spectrograph calibration, fiber positioning
- **data-pipeline-agent:** Expert in MUST data formats, reduction steps
- **simulation-agent:** Expert in galaxy survey simulations, selection functions

**2. Research Workflow**
- **literature-agent:** Expert in your research areas, paper digestion
- **observing-agent:** Expert in telescope proposals, time allocation

**3. Creating Agents**
Use the paper's heuristic:
> If you explain the same domain knowledge 3+ times to an AI, codify it into an agent.

### Questions to Consider

- Are there domains in your work where you repeatedly explain the same concepts?
- Could your MEMORY.md be reorganized into topic-specific documents (Tier 3)?
- Would trigger tables help route tasks to the right AI behavior?

---

## Limitations and Open Questions

### Limitations

1. **Maintenance cost:** 26,000 lines of context infrastructure requires ongoing maintenance
2. **Author bias:** Single author, chemistry background—results may not generalize
3. **No causal claims:** Can't prove the infrastructure caused success (confounded by author learning)
4. **Project-specific:** The architecture was tuned for one specific project

### Open Questions

- How much of this is generalizable to other domains (e.g., astronomy)?
- What's the minimum viable context infrastructure for a 10K-line project?
- How do you keep specifications in sync with evolving code?
- Can LLMs automatically maintain/update the knowledge base?

---

## Summary

### The Problem
AI coding agents forget everything between sessions. Single-file manifests don't scale to large projects.

### The Solution
Three-tier architecture:
1. **Constitution** (always loaded): Core rules
2. **Specialist agents** (per task): Domain experts
3. **Knowledge base** (on demand): Detailed specs

### The Key Insights
1. Write documentation for AI, not humans
2. Embed knowledge directly into agents (don't just retrieve)
3. Create agents when domains cause repeated failures
4. Use trigger tables to automate routing

### The Evidence
- Built a 108,000-line system with 283 sessions
- 26,000 lines of context infrastructure
- 19 specialist agents, 34 knowledge documents

---

## Citation

```bibtex
@article{anonymous2026codified,
  title={Codified Context: Infrastructure for AI Agents in a Complex Codebase},
  journal={arXiv preprint arXiv:2602.20478},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> When project knowledge outgrows a single manifest file, use a three-tier architecture: constitution (always loaded), specialist agents (per task), and knowledge base (on demand). Write documentation for AI consumption, not human reading.

**Connections to my work:**
1. **Current setup:** AGENTS.md + MEMORY.md is a good start, but could scale further
2. **MUST domains:** Could create specialist agents for spectrograph, pipeline, simulation
3. **Research workflow:** Literature agent, observing agent, etc.
4. **Maintenance trade-off:** 24% knowledge-to-code ratio—is this worth it for my projects?

**Questions to explore:**
- [ ] Which domains in my work require repeated explanations to AI?
- [ ] Should I create specialist agents for MUST-related tasks?
- [ ] How would I organize MEMORY.md into topic-specific documents?
- [ ] What trigger tables would make sense for my workflow?

**Action items:**
- [ ] Review current AGENTS.md—is it getting too long?
- [ ] Identify domains where I repeatedly explain concepts
- [ ] Consider organizing memory files by topic rather than just date
- [ ] Experiment with "domain expert" prompts for MUST work
