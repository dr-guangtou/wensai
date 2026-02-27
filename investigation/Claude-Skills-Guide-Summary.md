---
title: "The Complete Guide to Building Skills for Claude - Summary"
author: Anthropic
source: "The-Complete-Guide-to-Building-Skill-for-Claude.pdf"
date_read: 2026-02-22
type: summary
tags:
  - claude
  - ai
  - skills
  - mcp
  - automation
  - documentation
---

# The Complete Guide to Building Skills for Claude - Summary

## What is a Skill?

A **skill** is a folder containing instructions that teach Claude how to handle specific tasks or workflows. Instead of re-explaining preferences in every conversation, skills let you teach Claude once and benefit every time.

### Core Use Cases
- Generating frontend designs from specs
- Conducting research with consistent methodology
- Creating documents following team style guides
- Orchestrating multi-step processes

---

## Skill Structure

```
your-skill-name/
├── SKILL.md          # Required - main instructions with YAML frontmatter
├── scripts/          # Optional - executable code (Python, Bash)
├── references/       # Optional - documentation loaded as needed
└── assets/           # Optional - templates, fonts, icons
```

### Key Files

| File | Purpose | Required |
|------|---------|----------|
| `SKILL.md` | Main instructions in Markdown with YAML frontmatter | ✅ Yes |
| `scripts/` | Executable code for data processing | ❌ No |
| `references/` | Additional documentation | ❌ No |
| `assets/` | Templates and visual assets | ❌ No |

**Important:** No `README.md` inside the skill folder - all docs go in `SKILL.md` or `references/`.

---

## Core Design Principles

### 1. Progressive Disclosure (Three-Level System)

| Level | Content | When Loaded |
|-------|---------|-------------|
| **Level 1** | YAML frontmatter | Always - tells Claude when to use the skill |
| **Level 2** | SKILL.md body | When skill is relevant to current task |
| **Level 3** | Linked files (`references/`, `scripts/`) | Only as needed |

This minimizes token usage while maintaining expertise.

### 2. Composability
- Claude can load multiple skills simultaneously
- Your skill should work alongside others
- Don't assume it's the only capability available

### 3. Portability
- Skills work identically across Claude.ai, Claude Code, and API
- Create once, use everywhere

---

## YAML Frontmatter (Critical!)

The frontmatter is how Claude decides whether to load your skill.

### Minimal Required Format
```yaml
---
name: your-skill-name
description: What it does. Use when user asks to [specific phrases].
---
```

### Field Requirements

| Field | Rules |
|-------|-------|
| `name` | kebab-case only, no spaces/underscores/capitals, match folder name |
| `description` | MUST include: (1) What skill does, (2) When to use it (trigger conditions). Under 1024 chars. |
| `license` | Optional - MIT, Apache-2.0, etc. |
| `compatibility` | Optional - environment requirements (1-500 chars) |
| `metadata` | Optional - author, version, mcp-server |

### Good Description Examples
```yaml
# ✅ Good - specific with trigger phrases
description: Analyzes Figma design files and generates developer handoff documentation. Use when user uploads .fig files, asks for "design specs", "component documentation", or "design-to-code handoff".

# ✅ Good - clear value proposition  
description: Manages Linear project workflows including sprint planning, task creation, and status tracking. Use when user mentions "sprint", "Linear tasks", "project planning", or asks to "create tickets".
```

### Bad Description Examples
```yaml
# ❌ Too vague
description: Helps with projects.

# ❌ Missing triggers
description: Creates sophisticated multi-page documentation systems.

# ❌ Too technical, no user triggers
description: Implements the Project Entity model with hierarchical relationships.
```

---

## Three Skill Use Case Categories

### Category 1: Document & Asset Creation
**Used for:** Creating consistent, high-quality output (documents, presentations, apps, designs, code)

**Example:** `frontend-design` skill  
*"Create distinctive, production-grade frontend interfaces with high design quality. Use when building web components, pages, artifacts, posters, or applications."*

**Key Techniques:**
- Embedded style guides and brand standards
- Template structures for consistent output
- Quality checklists before finalizing
- Uses Claude's built-in capabilities (no external tools)

---

### Category 2: Workflow Automation
**Used for:** Multi-step processes with consistent methodology, coordination across multiple MCP servers

**Example:** `skill-creator` skill  
*"Interactive guide for creating new skills. Walks the user through use case definition, frontmatter generation, instruction writing, and validation."*

**Key Techniques:**
- Step-by-step workflow with validation gates
- Templates for common structures
- Built-in review and improvement suggestions
- Iterative refinement loops

---

### Category 3: MCP Enhancement
**Used for:** Workflow guidance to enhance tool access an MCP server provides

**Example:** `sentry-code-review` skill  
*"Automatically analyzes and fixes detected bugs in GitHub Pull Requests using Sentry's error monitoring data via their MCP server."*

**Key Techniques:**
- Coordinates multiple MCP calls in sequence
- Embeds domain expertise
- Provides context users would otherwise need to specify
- Error handling for common MCP issues

---

## Skills vs MCP: The Kitchen Analogy

| Component | Analogy | Role |
|-----------|---------|------|
| **MCP** | Professional kitchen | Access to tools, ingredients, equipment |
| **Skills** | Recipes | Step-by-step instructions to create value |

**MCP (Connectivity)** | **Skills (Knowledge)**
---|---
Connects Claude to your service (Notion, Asana, Linear) | Teaches Claude how to use your service effectively
Provides real-time data access and tool invocation | Captures workflows and best practices
**What** Claude can do | **How** Claude should do it

### Why Skills Matter for MCP Users

**Without skills:**
- Users connect MCP but don't know what to do next
- Support tickets asking "how do I do X"
- Each conversation starts from scratch
- Inconsistent results

**With skills:**
- Pre-built workflows activate automatically
- Consistent, reliable tool usage
- Best practices embedded in every interaction
- Lower learning curve

---

## Writing Effective Instructions

### Recommended SKILL.md Structure
```markdown
---
name: your-skill
description: [...]
---

# Your Skill Name

## Instructions

### Step 1: [First Major Step]
Clear explanation of what happens.

Actions:
1. [Specific action with tool call if applicable]
2. [Next action]

Expected output: [describe success]

### Step 2: [Next Step]
...

## Examples

### Example 1: [common scenario]
User says: "..."

1. [Step]
2. [Step]

Result: ...

## Troubleshooting

### Error: [common error]
Cause: [Why it happens]
Solution: [How to fix]
```

### Best Practices

**✅ Be Specific and Actionable**
```markdown
✅ Run `python scripts/validate.py --input {filename}` to check data format.
   If validation fails, common issues include:
   - Missing required fields (add them to the CSV)
   - Invalid date formats (use YYYY-MM-DD)

❌ Validate the data before proceeding.
```

**✅ Reference Bundled Resources**
```markdown
Before writing queries, consult `references/api-patterns.md` for:
- Rate limiting guidance
- Pagination patterns
- Error codes and handling
```

**✅ Include Error Handling**
```markdown
## Common Issues

### MCP Connection Failed
If you see "Connection refused":
1. Verify MCP server is running: Check Settings > Extensions
2. Confirm API key is valid
3. Try reconnecting: Settings > Extensions > [Your Service] > Reconnect
```

---

## Testing and Iteration

### Three Testing Areas

#### 1. Triggering Tests
**Goal:** Skill loads at the right times

| Test | Expected Result |
|------|-----------------|
| Obvious tasks | ✅ Triggers |
| Paraphrased requests | ✅ Triggers |
| Unrelated topics | ❌ Doesn't trigger |

#### 2. Functional Tests
**Goal:** Verify correct outputs
- Valid outputs generated
- API calls succeed
- Error handling works
- Edge cases covered

#### 3. Performance Comparison
**Goal:** Prove skill improves results vs baseline

| Metric | Without Skill | With Skill |
|--------|---------------|------------|
| User instructions | Repeated each time | Automatic |
| Messages | 15 back-and-forth | 2 clarifying questions |
| Failed API calls | 3 retries | 0 failures |
| Tokens consumed | 12,000 | 6,000 |

### Success Criteria (Aspirational Targets)

**Quantitative:**
- Skill triggers on 90% of relevant queries
- Completes workflow in X tool calls (measure with/without skill)
- 0 failed API calls per workflow

**Qualitative:**
- Users don't need to prompt about next steps
- Workflows complete without user correction
- Consistent results across sessions

---

## Common Patterns

### Pattern 1: Sequential Workflow Orchestration
**Use when:** Multi-step processes in specific order

```markdown
## Workflow: Onboard New Customer

### Step 1: Create Account
Call MCP tool: `create_customer`
Parameters: name, email, company

### Step 2: Setup Payment
Call MCP tool: `setup_payment_method`
Wait for: payment method verification

### Step 3: Create Subscription
Call MCP tool: `create_subscription`
Parameters: plan_id, customer_id (from Step 1)
```

**Key techniques:**
- Explicit step ordering
- Dependencies between steps
- Validation at each stage
- Rollback instructions for failures

---

### Pattern 2: Multi-MCP Coordination
**Use when:** Workflows span multiple services

Example: Design-to-development handoff
- **Phase 1:** Export from Figma MCP
- **Phase 2:** Store assets in Drive MCP
- **Phase 3:** Create tasks in Linear MCP

---

### Pattern 3: Iterative Refinement
**Use when:** Output quality improves with iteration

```markdown
## Iterative Report Creation

### Initial Draft
1. Fetch data via MCP
2. Generate first draft
3. Save to temporary file

### Quality Check
Run validation: `scripts/check_report.py`
Identify issues:
- Missing sections
- Inconsistent formatting
- Data validation errors

### Refinement
Fix identified issues and regenerate
```

---

## Troubleshooting Guide

### Execution Issues
| Symptom | Solution |
|---------|----------|
| Inconsistent results | Improve instructions, add error handling |
| API call failures | Add retry logic, validate inputs |
| User corrections needed | Add more examples, clarify steps |

### Undertriggering (Skill doesn't load when it should)
**Signals:**
- Users manually enabling skill
- Support questions about when to use it

**Solution:** Add more detail and keywords to description

### Overtriggering (Skill loads for irrelevant queries)
**Signals:**
- Skill loads for wrong queries
- Users disabling it
- Confusion about purpose

**Solution:** Add negative triggers, be more specific in description

---

## Distribution and Sharing

### Current Distribution Model

**Individual users:**
1. Download skill folder
2. Zip the folder (if needed)
3. Upload to Claude.ai via Settings > Capabilities > Skills
4. Or place in Claude Code skills directory

**Organization-level:**
- Admins can deploy skills workspace-wide
- Automatic updates, centralized management

### Recommended Approach

1. **Host on GitHub**
   - Public repo for open-source skills
   - Clear README (for humans - separate from skill folder)
   - Example usage and screenshots

2. **Document in Your MCP Repo**
   - Link to skills from MCP documentation
   - Explain value of using both together

3. **Create Installation Guide**
   ```markdown
   ## Installing the [Your Service] skill
   
   1. Download: `git clone https://github.com/yourcompany/skills`
   2. Install in Claude: Settings > Skills > Upload
   3. Enable the skill toggle
   4. Test: "Set up a new project in [Your Service]"
   ```

### API Access
- `/v1/skills` endpoint for listing/managing skills
- Add skills to Messages API via `container.skills` parameter
- Requires Code Execution Tool beta

---

## Key Takeaways

1. **Skills are portable knowledge** - Teach Claude once, use everywhere
2. **Progressive disclosure** is critical - Don't overload the system prompt
3. **Frontmatter descriptions** determine when skills trigger - invest time here
4. **MCP provides tools, skills provide expertise** - they're complementary
5. **Start with 2-3 concrete use cases** - iterate on one task until it works
6. **Test triggering first** - skill must load before it can help
7. **Skills are living documents** - plan to iterate based on feedback

---

## Resources

- **skill-creator skill:** Available in Claude.ai plugin directory
- **Build time:** 15-30 minutes for first working skill
- **Standard:** Agent Skills is an open standard (like MCP)

---

## Notes for My Use Case

*Dr. Guangtou - Add your specific notes here about how you might apply this to your astronomy research workflows, MUST telescope project management, etc.*

**Potential skill ideas:**
- [ ] Literature review assistant for arXiv papers
- [ ] MUST telescope observation planning
- [ ] Data analysis workflow for galaxy surveys
- [ ] Research note formatting for Obsidian vault
