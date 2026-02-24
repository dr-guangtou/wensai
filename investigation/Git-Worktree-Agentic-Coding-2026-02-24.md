---
title: "Git Worktree for Agentic Coding - Investigation Report"
date: 2026-02-24
topic: "Git Worktree Workflow"
category: "Development Tools"
tags: ["git", "worktree", "agentic-coding", "aider", "claude-code", "workflow", "productivity"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Git Worktree for Agentic Coding - Investigation Report

**Research Date:** 2026-02-24  
**Investigation Topic:** Git Worktree Feature for Agentic Coding Workflows  
**Focus Areas:** What it is, How to use it, Best scenarios, Coding agent support

---

## 1. What is Git Worktree?

### Simple Explanation

**Git worktree** allows you to have **multiple working directories** for the **same Git repository**. Instead of switching branches (which changes your working directory), you can have different branches checked out simultaneously in separate directories.

### The Problem It Solves

**Traditional workflow (without worktree):**
```
You're working on feature-A in ~/project
→ Need to quickly check something on main
→ git stash (save your changes)
→ git checkout main
→ Do the check
→ git checkout feature-A
→ git stash pop (restore your changes)
→ Hope nothing broke in the process
```

**With worktree:**
```
~/project/main     → Always has main branch
~/project/feature-A → Your feature work
~/project/feature-B → Another feature
→ Just cd to the directory you need!
```

### Key Concept: Linked Worktrees

A Git repository has:
- **One main worktree** (created by `git clone` or `git init`)
- **Zero or more linked worktrees** (created by `git worktree add`)

All worktrees share:
- ✓ The same `.git` directory (repository history)
- ✓ Same remote configuration
- ✓ Same stashes, tags, refs

Each worktree has its own:
- ✓ Working directory (files on disk)
- ✓ HEAD (current commit)
- ✓ Index (staging area)
- ✓ Uncommitted changes

---

## 2. Basic Commands & How to Use It

### Essential Commands

```bash
# 1. CREATE a new worktree
git worktree add <path> [<branch>]

# Example: Create worktree for feature branch
git worktree add ../my-feature feature-branch

# Example: Create worktree with new branch
git worktree add ../hotfix -b hotfix-123

# 2. LIST all worktrees
git worktree list

# 3. REMOVE a worktree
git worktree remove <path>

# 4. Clean up stale worktree references
git worktree prune
```

### Common Workflows

#### Workflow 1: Feature Development with Clean Main

```bash
# Your main project directory
~/project (main branch)

# Create a worktree for your feature
cd ~/project
git worktree add ../project-feature-x feature-x

# Now you have two directories:
# ~/project           → main branch (reference/clean)
# ~/project-feature-x → feature-x branch (active work)

# Work on your feature
cd ../project-feature-x
# ... code, commit, etc. ...

# When done, remove it
git worktree remove ../project-feature-x
```

#### Workflow 2: Quick Hotfix Without Disturbing Current Work

```bash
# You're deep in feature work with uncommitted changes
cd ~/project-feature-x
# ... lots of changes ...

# Main needs an urgent fix
git worktree add ../hotfix main
cd ../hotfix
# ... make the fix ...
git commit -m "Fix critical bug"
git push

# Back to feature work
cd ../project-feature-x
# ... your uncommitted changes are still there! ...

# Clean up later
git worktree remove ../hotfix
```

#### Workflow 3: Code Review in Isolation

```bash
# Review someone's PR branch without affecting your work
git fetch origin pull/123/head:pr-123
git worktree add ../pr-review-123 pr-123
cd ../pr-review-123
# ... review the code ...
# ... run tests ...

# When done
git worktree remove ../pr-review-123
```

---

## 3. Best Scenarios for Using Git Worktree

### Scenario 1: Agentic Coding with Multiple Agents ⭐

**The Problem:** You want to use multiple AI coding agents simultaneously on different parts of your project.

**Worktree Solution:**
```
~/project-main/      → Reference, read-only
git worktree add ../project-agent-1 agent-1-work  → Claude Code working here
git worktree add ../project-agent-2 agent-2-work  → Aider working here
git worktree add ../project-agent-3 agent-3-work  → Codex working here
```

**Benefits:**
- Each agent works in isolation
- No conflicts between agents
- Easy to compare results
- Can run tests independently

### Scenario 2: Long-Running Tasks (Fuzzing, CI)

**Matklad's Pattern** (from TigerBeetle development):
```
~/tigerbeetle/main/   → Clean reference to main
~/tigerbeetle/work/   → Active development
~/tigerbeetle/fuzz/   → Long-running fuzz tests
~/tigerbeetle/review/ → Code review
~/tigerbeetle/scratch/→ Quick experiments
```

**Workflow:**
```bash
# Start working on feature
cd ~/tigerbeetle/work
git switch -c matklad/awesome-feature
# ... code furiously ...
git add . && git commit -m "WIP"

# Kick off fuzzing in parallel
cd ../fuzz
git switch -d $(cd ../work && git rev-parse HEAD)
./zig build fuzz  # Runs for hours

# Continue coding while fuzzer runs
cd ../work
# ... keep coding ...
```

### Scenario 3: Large Refactoring with Reference

```bash
# Keep main as reference
cd ~/project-main

# Create worktree for major refactor
git worktree add ../project-refactor

# In one terminal: reference the original
cd ~/project-main
# ... compare behavior ...

# In another terminal: do the refactor
cd ~/project-refactor
git switch -c big-refactor
# ... make changes ...
```

### Scenario 4: Maintaining Multiple Release Branches

```bash
# Support different versions simultaneously
git worktree add ../project-v1.x v1.x
git worktree add ../project-v2.x v2.x
git worktree add ../project-v3.x v3.x

# Now you can:
cd ../project-v1.x && git cherry-pick fix-abc
cd ../project-v2.x && git cherry-pick fix-abc
cd ../project-v3.x && git cherry-pick fix-abc
```

### Scenario 5: Documentation/Website Work

```bash
# Main code
cd ~/project

# Documentation site (often a separate branch)
git worktree add ../project-docs gh-pages
cd ../project-docs
# ... update documentation ...
```

---

## 4. Recommended Worktree Layout for Agentic Coding

Based on research (especially Matklad's workflow), here's an optimal setup:

### Directory Structure

```
~/projects/
  my-project/
    main/        ← Original clone, main branch (reference)
    work/        ← Primary development worktree
    review/      ← Code review worktree
    agent-1/     ← Claude Code sessions
    agent-2/     → Aider sessions
    agent-3/     → Other AI agent sessions
    fuzz/        ← Long-running tests
    scratch/     ← Throwaway experiments
    hotfix/      ← Emergency fixes
```

### Setting It Up

```bash
# 1. Initial clone (this becomes your 'main' reference)
git clone https://github.com/user/repo.git my-project
cd my-project

# 2. Create the worktrees
git worktree add ../work
git worktree add ../review
git worktree add ../agent-1
git worktree add ../agent-2
git worktree add ../agent-3
git worktree add ../scratch

# 3. List them
git worktree list
```

### Usage Pattern

```bash
# Reference the clean main
cd ~/projects/my-project/main
# ... compare against baseline ...

# Primary development
cd ~/projects/my-project/work
git switch -c feature/new-thing
# ... write code ...

# Run AI agent in isolated worktree
cd ~/projects/my-project/agent-1
# Claude Code / Aider runs here
# ... agent makes changes ...

# Review PRs
cd ~/projects/my-project/review
git fetch origin pull/123/head:pr-123
git switch pr-123
# ... review ...
```

---

## 5. Which Coding Agents Support Git Worktree?

### Aider ⭐⭐⭐ (Best Support)

**Status:** Native Git integration, works well with worktrees

**Features:**
- Automatically commits changes with descriptive messages
- `/undo` command to revert AI changes
- Respects git workflow in any worktree
- Can commit changes before/after AI edits

**Usage with Worktree:**
```bash
cd ~/project/agent-1
aider --model sonnet
# Aider works normally, commits go to this worktree only
```

**Limitations:**
- No explicit "worktree awareness" in prompts
- Still one agent per worktree (by design)

### Claude Code ⭐⭐⭐ (Excellent)

**Status:** Full Git integration, worktree-compatible

**Features:**
- Reads entire codebase
- Makes file edits
- Runs commands
- Git operations work normally

**Usage with Worktree:**
```bash
cd ~/project/agent-2
claude
# Claude Code sees only this worktree's files
```

**Advantages:**
- Can start multiple Claude Code sessions in different worktrees
- Each session is isolated
- Can compare approaches across worktrees

### Codex (GitHub Copilot) ⭐⭐⭐

**Status:** Works in any worktree

**Features:**
- IDE extension works in any directory
- Git operations are standard

**Usage:**
- Open `~/project/agent-3` in VS Code
- Codex/Copilot works normally

### Cursor ⭐⭐⭐

**Status:** Full worktree support

**Features:**
- Open any worktree as a project
- AI features work normally

---

## 6. Advanced Tips & Best Practices

### Tip 1: Use Detached HEAD for Experiments

```bash
# Create a throwaway worktree not attached to any branch
git worktree add -d ../experiment

# Do whatever you want here
# When done, just delete it - no branch cleanup needed
git worktree remove ../experiment
```

### Tip 2: Lock Worktrees on Network Drives

```bash
# If worktree is on external/network drive
git worktree lock --reason "On NAS" ../network-project

# Won't be pruned automatically
git worktree unlock ../network-project
```

### Tip 3: Prune Stale Worktrees

```bash
# Remove worktree metadata for deleted directories
git worktree prune

# Dry run first
git worktree prune -n
```

### Tip 4: Shell Aliases

```bash
# Add to ~/.bashrc or ~/.zshrc
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtl='git worktree list'
alias gwtr='git worktree remove'

# Create worktree for new feature
function gwt-feature() {
    local name=$1
    git worktree add ../$(basename $(pwd))-$name -b $name
}
```

### Tip 5: Worktree-Aware Prompt

```bash
# Show current worktree in shell prompt
function git_worktree_name() {
    local wt=$(git worktree list --porcelain 2>/dev/null | grep -E "^worktree " | grep "$(pwd)" | cut -d' ' -f2-)
    if [[ "$wt" != "$(git rev-parse --show-toplevel 2>/dev/null)" ]]; then
        echo " ($(basename $wt))"
    fi
}

# Add to PS1
export PS1='\u@\h:\w$(git_worktree_name) \$ '
```

---

## 7. Summary

### What is Git Worktree?

Git worktree allows **multiple working directories** for a single repository. Instead of switching branches (and stashing changes), you `cd` to a different directory.

### When to Use It?

| Scenario | Worktree Solution |
|----------|-------------------|
| **Multiple AI agents** | Each agent gets its own worktree |
| **Long-running tests** | Run tests in parallel worktree |
| **Code review** | Checkout PRs without disturbing work |
| **Hotfixes** | Fix main without stashing feature work |
| **Experiments** | Try things in isolated throwaway worktree |

### Best Practice Layout

```
project/
  main/      → Reference (read-only main)
  work/      → Your primary development
  agent-*/   → AI agent worktrees
  review/    → Code review
  fuzz/      → Long-running tests
  scratch/   → Experiments
```

### Coding Agent Support

| Agent | Worktree Support | Notes |
|-------|------------------|-------|
| **Aider** | ⭐⭐⭐ Excellent | Native git integration, auto-commit |
| **Claude Code** | ⭐⭐⭐ Excellent | Multiple isolated sessions |
| **Codex** | ⭐⭐⭐ Good | Works in any directory |
| **Cursor** | ⭐⭐⭐ Good | Standard IDE integration |

### Key Commands

```bash
git worktree add ../feature-x feature-x     # Create worktree
git worktree list                            # List all worktrees
git worktree remove ../feature-x             # Remove worktree
git worktree prune                           # Clean up stale refs
```

---

## 8. Further Reading

- **Official Docs:** https://git-scm.com/docs/git-worktree
- **Matklad's Blog:** https://matklad.github.io/2024/07/25/git-worktrees.html (Highly recommended!)
- **Aider Git Integration:** https://aider.chat/docs/git.html
- **Claude Code Docs:** https://code.claude.com/docs

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-24*
