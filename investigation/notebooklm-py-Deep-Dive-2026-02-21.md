---
title: "notebooklm-py Deep Dive"
date: 2026-02-21
topic: "NotebookLM Python API"
category: "AI Tools & APIs"
tags: ["notebooklm", "google", "api", "python", "claude-code", "research"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# notebooklm-py Deep Dive Investigation Report

**Research Date:** 2026-02-21  
**Investigation Topic:** notebooklm-py - Unofficial Python API for Google NotebookLM  
**Focus Areas:** Architecture, Capabilities, Claude Code Integration, Risk Assessment

---

## 1. Executive Summary

**notebooklm-py** is the most popular unofficial Python API for Google NotebookLM, with **2.1k GitHub stars** and active maintenance (last updated 25 days ago). It provides comprehensive programmatic access to NotebookLM features—including capabilities the web UI doesn't expose.

**Key Value Proposition:**
- Works with **personal Google accounts** (unlike Enterprise API)
- Ships with **Claude Code skills** for natural language automation
- **Async Python API** for building research pipelines
- **CLI** for shell scripting and automation
- Features **beyond the web UI** (batch downloads, quiz export, etc.)

**⚠️ Critical Caveat:** Uses undocumented Google APIs that can break without notice. Not affiliated with Google.

---

## 2. Architecture Overview

### 2.1 How It Works

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Your Code     │────▶│  notebooklm-py   │────▶│  Google APIs    │
│                 │     │  (Python/CLI)    │     │  (undocumented) │
│ - Python API    │     │                  │     │                 │
│ - CLI commands  │     │ - Auth handling  │     │ - Internal      │
│ - Claude Skills │     │ - Rate limiting  │     │   endpoints     │
│                 │     │ - Error retry    │     │ - Web UI API    │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

**Authentication Method:**
- Browser-based login (Playwright)
- Session persistence
- No API key required (uses Google account cookies)

### 2.2 Three Usage Modes

| Mode | Best For | Entry Point |
|------|----------|-------------|
| **Python API** | Application integration, async workflows | `import notebooklm_py as nblm` |
| **CLI** | Shell scripts, quick tasks, CI/CD | `notebooklm [command]` |
| **Agent Skills** | Claude Code, LLM agents | `notebooklm skill install` |

---

## 3. Complete Feature Inventory

### 3.1 Core Notebook Operations

| Feature | Description | Web UI Equivalent |
|---------|-------------|-------------------|
| Create notebook | Create new notebook with title | ✅ Yes |
| List notebooks | Get all user notebooks | ✅ Yes |
| Rename notebook | Change notebook title | ✅ Yes |
| Delete notebook | Remove notebook | ✅ Yes |

### 3.2 Source Management

| Source Type | Add Source | Refresh | Get Guide | Get Fulltext |
|-------------|------------|---------|-----------|--------------|
| **URLs** | ✅ | ✅ | ✅ | ⚠️ API only |
| **YouTube** | ✅ | ✅ | ✅ | ⚠️ API only |
| **PDFs** | ✅ | ✅ | ✅ | ⚠️ API only |
| **Text/Markdown** | ✅ | N/A | ✅ | ⚠️ API only |
| **Word (DOCX)** | ✅ | ✅ | ✅ | ⚠️ API only |
| **Google Drive** | ✅ | ✅ | ✅ | ⚠️ API only |
| **Audio files** | ✅ | N/A | ✅ | ⚠️ API only |
| **Video files** | ✅ | N/A | ✅ | ⚠️ API only |
| **Images** | ✅ | N/A | ✅ | ⚠️ API only |
| **Pasted text** | ✅ | N/A | ✅ | ⚠️ API only |

**API-Only Features:**
- Source fulltext extraction (get the indexed text content)
- Batch source operations
- Web research agent with auto-import
- Drive research agent with auto-import

### 3.3 Chat Interface

| Feature | Description | API Access |
|---------|-------------|------------|
| Ask questions | Query sources | ✅ Full |
| Conversation history | Get chat history | ✅ Full |
| Custom personas | Set chat persona | ✅ Full |

### 3.4 Content Generation (NotebookLM Studio)

| Type | Options | Download Format | Web UI |
|------|---------|-----------------|--------|
| **Audio Overview** | 4 formats (deep-dive, brief, critique, debate), 3 lengths, 50+ languages | MP3/MP4 | ✅ Yes |
| **Video Overview** | 2 formats, 9 visual styles (classic, whiteboard, kawaii, anime, etc.) | MP4 | ✅ Yes |
| **Slide Deck** | Detailed or presenter format, adjustable length | PDF | ✅ Yes |
| **Infographic** | 3 orientations, 3 detail levels | PNG | ✅ Yes |
| **Quiz** | Configurable quantity and difficulty | JSON, Markdown, HTML | ⚠️ API only (export) |
| **Flashcards** | Configurable quantity and difficulty | JSON, Markdown, HTML | ⚠️ API only (export) |
| **Report** | Briefing doc, study guide, blog post, custom prompt | Markdown | ✅ Yes |
| **Data Table** | Custom structure via natural language | CSV | ⚠️ API only |
| **Mind Map** | Interactive hierarchical visualization | JSON | ⚠️ API only (data extraction) |

### 3.5 Beyond Web UI Features

| Feature | Description | Use Case |
|---------|-------------|----------|
| **Batch downloads** | Download all artifacts of a type at once | Research archiving |
| **Quiz/Flashcard export** | Get structured JSON, Markdown, or HTML | LMS integration |
| **Mind map data extraction** | Export hierarchical JSON | Visualization tools |
| **Data table CSV export** | Download structured tables as spreadsheets | Data analysis |
| **Source fulltext access** | Retrieve indexed text content of any source | Custom processing |
| **Programmatic sharing** | Manage permissions without UI | Collaboration workflows |

### 3.6 Sharing & Collaboration

| Feature | API Support | Notes |
|---------|-------------|-------|
| Public links | ✅ | Create public shareable links |
| Private links | ✅ | Email-based sharing |
| Viewer permissions | ✅ | Read-only access |
| Editor permissions | ✅ | Full edit access |
| Permission management | ✅ | Programmatic control |

---

## 4. Claude Code Integration (Agent Skills)

### 4.1 Built-in Skills

notebooklm-py ships with Claude Code skills for natural language automation:

```bash
# Install skills
notebooklm skill install

# Available skills after installation
notebooklm create "Research Topic"  # Create notebook
notebooklm add-source "https://..."  # Add URL source
notebooklm chat "Summarize key findings"  # Query notebook
notebooklm generate audio  # Create Audio Overview
```

### 4.2 Natural Language Interface

The skills enable Claude Code to interact with NotebookLM using conversational commands:

```
User: "Create a notebook about black holes and add these papers"
Claude: [Uses notebooklm skill to create notebook and add sources]

User: "Generate a podcast explaining this research"
Claude: [Uses notebooklm skill to generate Audio Overview]

User: "Export all the quizzes as JSON"
Claude: [Uses notebooklm skill to export quiz data]
```

### 4.3 Skill Architecture

```
Claude Code
    │
    ├── notebooklm skill (YAML + Python)
    │       ├── create: Create notebooks
    │       ├── add-source: Add sources
    │       ├── chat: Query notebooks
    │       ├── generate: Create content
    │       └── export: Download artifacts
    │
    └── notebooklm-py library
            └── Google APIs
```

---

## 5. Installation & Setup

### 5.1 Basic Installation

```bash
# Basic install
pip install notebooklm-py

# With browser login support (required for first-time setup)
pip install "notebooklm-py[browser]"
playwright install chromium
```

### 5.2 Development Installation

```bash
# Install from source
pip install git+https://github.com/teng-lin/notebooklm-py@main

# Note: main branch may have unstable changes
# Use PyPI releases for production
```

### 5.3 Authentication Setup

**First-time setup requires browser login:**

```python
import notebooklm_py as nblm

# This will open a browser for Google authentication
# Session is persisted for subsequent runs
```

**Authentication notes:**
- Uses Playwright for browser automation
- Stores session cookies locally
- Requires manual login on first run
- Session persists across restarts

---

## 6. Usage Examples

### 6.1 Python API (Async)

```python
import asyncio
import notebooklm_py as nblm

async def research_workflow():
    # Create notebook
    notebook = await nblm.create_notebook("AI Research")
    
    # Add sources
    await nblm.add_source_url(notebook.id, "https://arxiv.org/abs/...")
    await nblm.add_source_file(notebook.id, "./paper.pdf")
    
    # Chat with sources
    response = await nblm.chat(
        notebook.id, 
        "What are the key findings?"
    )
    
    # Generate Audio Overview
    audio = await nblm.generate_audio(
        notebook.id,
        style="deep-dive",
        length="medium"
    )
    
    # Download artifacts
    await nblm.download_audio(audio.id, "./output.mp3")

asyncio.run(research_workflow())
```

### 6.2 CLI Usage

```bash
# Add source
notebooklm source add "https://en.wikipedia.org/wiki/Artificial_intelligence"
notebooklm source add "./paper.pdf"

# Chat with sources
notebooklm ask "What are the key themes?"

# Generate content
notebooklm generate audio "make it engaging" --wait
notebooklm generate video --style whiteboard --wait
notebooklm generate quiz --difficulty hard
notebooklm generate flashcards --quantity more
notebooklm generate slide-deck
notebooklm generate infographic --orientation portrait
notebooklm generate mind-map
notebooklm generate data-table "compare key concepts"

# Download artifacts
notebooklm download audio --all
notebooklm download quiz --format json
```

### 6.3 Research Automation Pipeline

```python
import notebooklm_py as nblm

async def automated_research(urls: list[str], topic: str):
    """Bulk import sources and extract insights."""
    
    # Create notebook
    notebook = await nblm.create_notebook(topic)
    
    # Bulk add sources
    for url in urls:
        await nblm.add_source_url(notebook.id, url)
    
    # Run web research with auto-import
    research = await nblm.research_web(
        notebook.id,
        query=topic,
        mode="deep",  # or "fast"
        auto_import=True
    )
    
    # Generate comprehensive report
    report = await nblm.generate_report(
        notebook.id,
        style="study-guide"
    )
    
    # Export all artifacts
    await nblm.export_all(notebook.id, "./research-output/")
    
    return notebook
```

---

## 7. Risk Assessment

### 7.1 Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **API breakage** | Medium | High | Pin to specific version; monitor GitHub issues |
| **Rate limiting** | Medium | Medium | Implement exponential backoff; cache results |
| **Session expiry** | Low | Medium | Auto-refresh session; re-auth prompt |
| **Google ToS violation** | Low | High | Use for personal research only; no commercial use |

### 7.2 Operational Risks

| Risk | Description |
|------|-------------|
| **No SLA** | Community project; no guarantees |
| **Breaking changes** | Google can change internal APIs anytime |
| **Data access** | Requires Google account credentials |
| **Maintenance dependency** | Relies on single maintainer (teng-lin) |

### 7.3 Comparison with Official API

| Aspect | notebooklm-py | Official Enterprise API |
|--------|---------------|------------------------|
| **Stability** | ⚠️ Fragile | ✅ Stable |
| **Account type** | Personal | Enterprise only |
| **Google support** | ❌ None | ✅ Yes |
| **Rate limits** | Unknown/enforced by Google | Documented |
| **Feature coverage** | ✅ More than web UI | ⚠️ Limited (alpha) |
| **Setup complexity** | Low | High (GCP required) |
| **Cost** | Free | Enterprise pricing |

---

## 8. Integration with OpenClaw

### 8.1 Potential Skill Design

```yaml
# notebooklm.skill.yml
name: notebooklm
description: Integrate with Google NotebookLM for research automation
version: 0.1.0
commands:
  - name: create
    description: Create a new notebook
    args: [title]
  
  - name: add-source
    description: Add source to notebook
    args: [notebook_id, source_url_or_path]
  
  - name: research
    description: Run web research and auto-import
    args: [notebook_id, query]
  
  - name: chat
    description: Query notebook sources
    args: [notebook_id, question]
  
  - name: generate
    description: Generate content (audio, quiz, etc.)
    args: [notebook_id, type]
  
  - name: export
    description: Export notebook artifacts
    args: [notebook_id, output_dir]
```

### 8.2 Implementation Approaches

**Option A: Python Wrapper**
- Import notebooklm-py as dependency
- Expose via skill system
- Handle auth/session management

**Option B: CLI Wrapper**
- Shell out to `notebooklm` CLI
- Parse JSON output
- Simpler but less flexible

**Option C: Direct API**
- Reimplement API calls
- Full control but high maintenance
- Not recommended

### 8.3 Prerequisites for OpenClaw Skill

1. **Authentication handling**
   - Browser automation for initial login
   - Session persistence
   - Re-auth when expired

2. **Error handling**
   - Retry logic for rate limits
   - Graceful degradation
   - User-friendly error messages

3. **Configuration**
   - Google account selection
   - Default notebook settings
   - Download paths

---

## 9. Alternative Approaches

### 9.1 If notebooklm-py breaks:

| Alternative | Approach | Effort |
|-------------|----------|--------|
| **Official API** | Migrate to Enterprise API | High (requires GCP) |
| **Browser automation** | Playwright/Selenium directly | Medium (brittle) |
| **Manual workflow** | Hybrid automation + manual | Low (loses benefits) |

### 9.2 Related Projects

| Project | Language | Approach | Stars |
|---------|----------|----------|-------|
| **nblm-rs** | Rust/Python | Enterprise API only | 75 |
| **notebooklm-podcast-automator** | Python | FastAPI + Playwright | 91 |
| **NotebookLM Reimagined** | TypeScript | Self-hosted alternative | 21 |

---

## 10. Recommendations

### For Personal Research Use ✅

**Recommended:** notebooklm-py is suitable for:
- Personal research workflows
- Prototyping automation pipelines
- Claude Code integration
- Academic/non-commercial use

### For OpenClaw Skill ⚠️

**Conditional recommendation:**
- **Pros:** Feature-rich, Claude Code skills already exist
- **Cons:** Fragile dependency, may break unexpectedly

**Suggested approach:**
1. **Prototype** with notebooklm-py for immediate functionality
2. **Monitor** for breaking changes
3. **Plan** migration path to official API when available for consumers
4. **Document** limitations clearly for users

### Risk Mitigation Strategy

1. **Pin version:** Use exact version in requirements
2. **Error handling:** Wrap all calls with retries
3. **Fallbacks:** Provide manual workflow alternatives
4. **Monitoring:** Watch GitHub repo for updates/issues
5. **User communication:** Clear warnings about unofficial API

---

## 11. Resources

### Official Links
- **GitHub:** https://github.com/teng-lin/notebooklm-py
- **PyPI:** https://pypi.org/project/notebooklm-py/
- **Documentation:** https://github.com/teng-lin/notebooklm-py/tree/main/docs

### Related Documentation
- **Troubleshooting:** https://github.com/teng-lin/notebooklm-py/blob/main/docs/troubleshooting.md
- **Enterprise API:** https://cloud.google.com/gemini/enterprise/notebooklm-enterprise/docs/overview

### Community
- **Issues:** https://github.com/teng-lin/notebooklm-py/issues
- **Releases:** https://github.com/teng-lin/notebooklm-py/releases

---

## 12. Open Questions

1. **Rate limits:** What are the actual Google-enforced limits?
2. **Session lifetime:** How long do sessions remain valid?
3. **Concurrent usage:** Can multiple notebooks be processed in parallel?
4. **Error recovery:** How robust is the retry logic?
5. **Google response:** What's Google's stance on unofficial APIs?

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-21*  
*File: `~/Desktop/yuzhe/investigation/notebooklm-py-Deep-Dive-2026-02-21.md`*
