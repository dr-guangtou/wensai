---
title: "Agentic AI - The 2-Minute Claude Code Upgrade You're Probably Missing: LSP"
source: "https://karanbansal.in/blog/claude-code-lsp/"
author:
  - "[[Karan Bansal]]"
tags:
  - clippings
published: 2026-02-28
created: 2026-03-08
description: "Every Claude Code user is running without LSP. That means 30-60s grep searches instead of 50ms precise answers. Here's how to enable it — setup, real debug data, and undocumented discoveries."
---
Right now, every Claude Code user is running without LSP. That means every time you ask "where is `processPayment` defined?", Claude Code does what you'd do with a terminal. It greps. It searches text patterns across your entire codebase, reads through dozens of files, and tries to figure out which match is the actual definition.

It works. But it's slow, it's fuzzy, and on large codebases it regularly misses or gets confused. Search for `User` in a real project and you get 847 matches across 203 files: class definitions, variable names, comments, imports, CSS classes, SQL columns. The thing you actually wanted? Buried somewhere in the middle. Claude Code has to read through each match to narrow it down. That takes 30-60 seconds. Sometimes longer.

There's a feature that changes this entirely. It's called **LSP**, the Language Server Protocol. It's not enabled by default. It's not prominently documented. The setup requires a flag discovered through a GitHub issue, not the official docs. But once it's on, the same query ("where is `processPayment` defined?") returns the exact file and line number in **50 milliseconds**. Not 30 seconds. Fifty milliseconds. With 100% accuracy.

That's not an incremental improvement. That's a category change in how Claude Code navigates your code.

TL;DR

Claude Code ships without LSP enabled. Enabling it gives Claude the same code intelligence your IDE has: go-to-definition, find references, type info, real-time error detection. From my debug logs: ~50ms per query vs 30-60s with grep. Two minutes of setup. [Jump to setup →](https://karanbansal.in/blog/claude-code-lsp/#setting-it-up)

## What You're Currently Running

By default, Claude Code navigates your codebase with text search tools: `Grep`, `Glob`, and `Read`. It's the same as having a very fast developer with `grep` and `find` at a terminal. Smart pattern matching, but fundamentally just matching text.

The core problem: **grep treats code as text. But code is not text. It has structure, meaning, and relationships.** When you ask "where is `getUserById` defined?", you want the one function definition, not the 50 places that call it plus the 12 comments that mention it. Grep can't tell the difference. LSP can.

## What LSP Actually Is

Before 2016, every code editor had to build its own language support from scratch. VS Code needed a Python plugin. Vim needed a separate Python plugin. Emacs, Sublime, Atom — each one reinventing the same work. Twenty editors times fifty languages meant a thousand separate implementations, most of them incomplete.

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 520" style="width: 100%; height: auto; margin: 2.5rem auto; display: block;"><defs><marker id="arr" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#495057"></polygon></marker></defs><text x="300" y="24" text-anchor="middle" font-family="Inter, sans-serif" font-size="15" font-weight="600" fill="#212529">Before LSP: M × N</text> <rect x="20" y="48" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="70" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">VS Code</text> <rect x="20" y="92" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="114" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Vim</text> <rect x="20" y="136" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="158" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Emacs</text> <rect x="20" y="180" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="202" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Sublime</text> <rect x="460" y="48" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="70" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Python</text> <rect x="460" y="92" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="114" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">TypeScript</text> <rect x="460" y="136" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="158" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Go</text> <rect x="460" y="180" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="202" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Rust</text> <line x1="140" y1="65" x2="460" y2="65" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="65" x2="460" y2="109" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="65" x2="460" y2="153" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="65" x2="460" y2="197" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="109" x2="460" y2="65" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="109" x2="460" y2="109" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="109" x2="460" y2="153" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="109" x2="460" y2="197" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="153" x2="460" y2="65" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="153" x2="460" y2="109" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="153" x2="460" y2="153" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="153" x2="460" y2="197" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="197" x2="460" y2="65" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="197" x2="460" y2="109" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="197" x2="460" y2="153" stroke="#ced4da" stroke-width="1"></line><line x1="140" y1="197" x2="460" y2="197" stroke="#ced4da" stroke-width="1"></line><line x1="180" y1="50" x2="420" y2="210" stroke="#dc3545" stroke-width="3" opacity="0.6"></line><line x1="420" y1="50" x2="180" y2="210" stroke="#dc3545" stroke-width="3" opacity="0.6"></line><text x="300" y="240" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" font-weight="500" fill="#dc3545">4 × 4 = 16 plugins</text> <line x1="20" y1="262" x2="580" y2="262" stroke="#e9ecef" stroke-width="1"></line><text x="300" y="292" text-anchor="middle" font-family="Inter, sans-serif" font-size="15" font-weight="600" fill="#212529">With LSP: M + N</text> <rect x="20" y="312" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="334" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">VS Code</text> <rect x="20" y="356" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="378" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Vim</text> <rect x="20" y="400" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="422" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Emacs</text> <rect x="20" y="444" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="80" y="466" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Claude Code</text> <rect x="240" y="332" width="120" height="130" rx="8" fill="#212529"></rect><text x="300" y="390" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="14" font-weight="600" fill="#ffffff">LSP</text> <text x="300" y="410" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#adb5bd">Protocol</text> <rect x="460" y="312" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="334" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">Pyright</text> <rect x="460" y="356" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="378" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">ts-server</text> <rect x="460" y="400" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="422" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">gopls</text> <rect x="460" y="444" width="120" height="34" rx="5" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="520" y="466" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">rust-analyzer</text> <line x1="140" y1="329" x2="240" y2="370" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="140" y1="373" x2="240" y2="387" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="140" y1="417" x2="240" y2="405" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="140" y1="461" x2="240" y2="425" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="360" y1="370" x2="460" y2="329" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="360" y1="387" x2="460" y2="373" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="360" y1="405" x2="460" y2="417" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><line x1="360" y1="425" x2="460" y2="461" stroke="#495057" stroke-width="1.5" marker-end="url(#arr)"></line><text x="300" y="506" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" font-weight="500" fill="#198754">4 + 4 = 8 implementations</text></svg>

In 2016, Microsoft had an insight: separate the language intelligence from the editor. Create a **protocol**, a standard way for any editor to talk to any language server. The editor says "where is this symbol defined?" in JSON-RPC. The language server (a separate process that deeply understands one language) answers.

That's LSP. It turned a thousand-implementation problem into a seventy-implementation one. And it's why your VS Code Python experience is exactly as good as your Neovim Python experience — they're both talking to Pyright.

## The Performance Gap

Here's the thing nobody talks about: AI coding assistants had the exact same problem that editors had before LSP. Without it, Claude Code does text search. `Grep`, `Glob`, `Read`. It works. But the cost is measured in seconds per query, multiplied by dozens of queries per task. It adds up fast.

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 390" style="width: 100%; height: auto; margin: 2.5rem auto; display: block;"><defs><marker id="arr2" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#495057"></polygon></marker></defs><text x="20" y="24" font-family="Inter, sans-serif" font-size="15" font-weight="600" fill="#6c757d">Without LSP</text> <rect x="20" y="42" width="250" height="50" rx="7" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="145" y="72" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" fill="#495057">grep -r "User"</text> <line x1="270" y1="67" x2="318" y2="67" stroke="#495057" stroke-width="1.5" marker-end="url(#arr2)"></line><rect x="326" y="42" width="250" height="50" rx="7" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="451" y="64" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" fill="#495057">847 matches</text> <text x="451" y="82" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#adb5bd">203 files</text> <line x1="451" y1="92" x2="451" y2="112" stroke="#495057" stroke-width="1.5" marker-end="url(#arr2)"></line><rect x="326" y="120" width="250" height="50" rx="7" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="451" y="142" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" fill="#495057">Filter &amp; read</text> <text x="451" y="160" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#adb5bd">each file...</text><line x1="326" y1="145" x2="278" y2="145" stroke="#495057" stroke-width="1.5" marker-end="url(#arr2)"></line> <rect x="20" y="120" width="250" height="50" rx="7" fill="#fff3cd" stroke="#ffc107" stroke-width="1.5"></rect><text x="145" y="142" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" font-weight="500" fill="#664d03">~30-60 seconds</text> <text x="145" y="160" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#997404">maybe correct</text> <line x1="20" y1="196" x2="580" y2="196" stroke="#e9ecef" stroke-width="1"></line><text x="20" y="228" font-family="Inter, sans-serif" font-size="15" font-weight="600" fill="#6c757d">With LSP</text> <rect x="20" y="244" width="210" height="50" rx="7" fill="#212529"></rect><text x="125" y="274" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" fill="#ffffff">goToDefinition</text> <text x="300" y="256" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#adb5bd">JSON-RPC</text> <line x1="238" y1="269" x2="360" y2="269" stroke="#495057" stroke-width="1.5" stroke-dasharray="6 4" marker-end="url(#arr2)"></line><rect x="368" y="244" width="210" height="50" rx="7" fill="#212529"></rect><text x="473" y="266" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="13" fill="#ffffff">user-service.ts</text> <text x="473" y="284" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#adb5bd">line 42</text> <line x1="300" y1="294" x2="300" y2="320" stroke="#495057" stroke-width="2" marker-end="url(#arr2)"></line><rect x="20" y="326" width="558" height="50" rx="7" fill="#d1e7dd" stroke="#198754" stroke-width="1.5"></rect><text x="299" y="348" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="14" font-weight="500" fill="#0f5132">~50ms · 100% accurate</text> <text x="299" y="366" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="11" fill="#198754">~900× faster, guaranteed accuracy</text></svg>

## What Claude Code Gets from LSP

LSP gives Claude Code two categories of superpowers: things that happen automatically and things it can actively request.

### Passive: Self-Correcting Edits

This is the most valuable part, and most people don't even realize it's happening. After every file edit, the language server pushes diagnostics: type errors, missing imports, undefined variables. Claude Code sees these *immediately* and fixes them in the same turn, before you ever see the error.

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 340" style="width: 100%; height: auto; margin: 2.5rem auto; display: block;"><defs><marker id="arr3" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#495057"></polygon></marker><marker id="arr3r" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#dc3545"></polygon></marker></defs><text x="30" y="24" font-family="JetBrains Mono, monospace" font-size="12" font-weight="600" fill="#6c757d">1</text> <rect x="20" y="36" width="230" height="70" rx="8" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1.5"></rect><text x="135" y="66" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" font-weight="500" fill="#212529">You ask Claude:</text><text x="135" y="88" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#495057">"Add email param"</text> <line x1="250" y1="71" x2="300" y2="71" stroke="#495057" stroke-width="1.5" marker-end="url(#arr3)"></line><text x="318" y="24" font-family="JetBrains Mono, monospace" font-size="12" font-weight="600" fill="#6c757d">2</text> <rect x="308" y="36" width="230" height="70" rx="8" fill="#212529"></rect><text x="423" y="66" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" font-weight="500" fill="#ffffff">Claude edits</text> <text x="423" y="88" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#adb5bd">createUser()</text> <line x1="423" y1="106" x2="423" y2="154" stroke="#dc3545" stroke-width="1.5" marker-end="url(#arr3r)"></line><text x="318" y="150" font-family="JetBrains Mono, monospace" font-size="12" font-weight="600" fill="#6c757d">3</text> <rect x="308" y="162" width="230" height="70" rx="8" fill="#fff3cd" stroke="#ffc107" stroke-width="1.5"></rect><text x="423" y="190" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" font-weight="500" fill="#664d03">LSP detects</text> <text x="423" y="212" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#997404">3 errors in call sites</text> <line x1="308" y1="197" x2="258" y2="197" stroke="#495057" stroke-width="1.5" marker-end="url(#arr3)"></line><text x="30" y="150" font-family="JetBrains Mono, monospace" font-size="12" font-weight="600" fill="#6c757d">4</text> <rect x="20" y="162" width="230" height="70" rx="8" fill="#d1e7dd" stroke="#198754" stroke-width="1.5"></rect><text x="135" y="190" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" font-weight="500" fill="#0f5132">Claude fixes all 3</text> <text x="135" y="212" text-anchor="middle" font-family="JetBrains Mono, monospace" font-size="12" fill="#198754">0 errors ✓</text> <rect x="60" y="266" width="440" height="58" rx="8" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1"></rect><text x="280" y="291" text-anchor="middle" font-family="Inter, sans-serif" font-size="13" font-weight="500" fill="#212529">All 4 steps happen in a single turn — before you see the result.</text><text x="280" y="310" text-anchor="middle" font-family="Inter, sans-serif" font-size="11" fill="#6c757d">No manual iteration. No "oops, I missed a call site." It just works.</text></svg>

Think about what this means in practice. You ask Claude to add an `email` parameter to `createUser()`. Claude edits the function signature. The language server instantly reports 3 errors at three call sites that now have the wrong number of arguments. Claude sees the errors, finds all three call sites, and fixes them. You get the result with zero errors on the first try.

Without LSP, Claude would edit the function, hand you the result, you'd try to compile, see 3 errors, paste them back to Claude, and iterate. With LSP, that entire loop collapses into one step.

### Active: On-Demand Code Intelligence

Beyond automatic diagnostics, Claude Code can explicitly ask the language server questions:

- **`goToDefinition`** — "Where is `processOrder` defined?" → exact file and line
- **`findReferences`** — "Find all places that call `validateUser` " → every call site with location
- **`hover`** — "What type is the `config` variable?" → full type signature and docs
- **`documentSymbol`** — "List all functions in this file" → every symbol with location
- **`workspaceSymbol`** — "Find the `PaymentService` class" → search symbols across the entire project
- **`goToImplementation`** — "What classes implement `AuthProvider`?" → concrete implementations of interfaces
- **`incomingCalls` / `outgoingCalls`** — "What calls `processPayment`?" → full call hierarchy tracing

You don't need to use these operations explicitly. Just ask Claude Code naturally. "Where is authenticate defined?", "find all usages of UserService", "what type is response?" It routes to the right LSP operation automatically.

## Setting It Up

Here's the full setup. It takes about 2 minutes, and you only do it once.

### Prerequisites

- Claude Code version **2.0.74 or later** (run `claude --version` to check)
- The language server binary for your language(s) installed and in `$PATH`

### Step 1: Enable the LSP Tool

This is the part that trips people up. You need to add a flag to your Claude Code settings:

Add this to your `~/.claude/settings.json`:

`"env": { "ENABLE_LSP_TOOL": "1" }`

Heads up

`ENABLE_LSP_TOOL` is **not officially documented** as of February 2026. It was discovered via [GitHub Issue #15619](https://github.com/anthropics/claude-code/issues/15619) as a community workaround. It may change or become unnecessary in future versions. I also recommend adding `export ENABLE_LSP_TOOL=1` to your shell profile (`~/.zshrc` on macOS, `~/.bashrc` on Linux) as a fallback.

### Step 2: Install the Language Server

Install the binary for each language you work with. These are the same language servers your IDE uses. LSP is universal.

| Language      | Plugin              | Install Command                                  |
| ------------- | ------------------- | ------------------------------------------------ |
| Python        | `pyright-lsp`       | `npm i -g pyright`                               |
| TypeScript/JS | `typescript-lsp`    | `npm i -g typescript-language-server typescript` |
| Go            | `gopls-lsp`         | `go install golang.org/x/tools/gopls@latest`     |
| Rust          | `rust-analyzer-lsp` | `rustup component add rust-analyzer`             |
| Java          | `jdtls-lsp`         | `brew install jdtls`                             |
| C/C++         | `clangd-lsp`        | `brew install llvm`                              |
| C#            | `csharp-lsp`        | `dotnet tool install -g csharp-ls`               |
| PHP           | `php-lsp`           | `npm i -g intelephense`                          |
| Kotlin        | `kotlin-lsp`        | GitHub releases                                  |
| Swift         | `swift-lsp`         | Included with Xcode                              |
| Lua           | `lua-lsp`           | GitHub releases                                  |

### Step 3: Install and Enable the Plugin

First, update the marketplace catalog:

`claude plugin marketplace update claude-plugins-official`

Then install the plugin for your language:

`claude plugin install pyright-lsp` Python

`claude plugin install typescript-lsp` TypeScript/JS

`claude plugin install gopls-lsp` Go

`claude plugin install rust-analyzer-lsp` Rust

`claude plugin install jdtls-lsp` Java

`claude plugin install clangd-lsp` C/C++

`claude plugin install csharp-lsp` C#

`claude plugin install php-lsp` PHP

`claude plugin install kotlin-lsp` Kotlin

`claude plugin install swift-lsp` Swift

`claude plugin install lua-lsp` Lua

Verify it's installed and enabled:

`claude plugin list`

The #1 gotcha

A plugin can be **installed but disabled**. A disabled plugin won't register its LSP server at startup. If `claude plugin list` shows `Status: disabled`, run `claude plugin enable <name>` and restart Claude Code.

To be safe, I also explicitly set them to `true` in `~/.claude/settings.json`:

```
{
  "env": {
    "ENABLE_LSP_TOOL": "1"
  },
  "enabledPlugins": {
    "pyright-lsp@claude-plugins-official": true,
    "typescript-lsp@claude-plugins-official": true,
    "gopls-lsp@claude-plugins-official": true
  }
}
```

This single issue — plugins installed but not enabled — accounts for most "LSP isn't working" problems.

### Step 4: Restart Claude Code

LSP servers initialize at startup. After installing plugins, you need a full restart. Then verify by asking Claude: "What type is \[some variable\]?" — if it uses the LSP `hover` operation instead of reading the file, you're good.

## What Happens at Startup

Here's something I found interesting while digging through debug logs. When Claude Code starts, all enabled LSP servers launch simultaneously. They don't wait for you to open a file.

From my actual debug logs (4 language servers enabled):

```
# From ~/.claude/debug/ — session on Feb 23, 2026

05:53:56.216  [LSP MANAGER] Starting async initialization
05:53:56.573  Total LSP servers loaded: 4
05:53:56.757  gopls initialized          (+0.5s)
05:53:56.762  typescript initialized     (+0.5s)
05:53:56.819  pyright initialized        (+0.6s)
05:54:04.791  jdtls initialized          (+8.6s)
              Index is warm — all LSP operations now ~50ms
```

Two things stand out. First, the Java server takes ~8 seconds because of JVM warmup — this is normal, not a bug. Second, servers start indexing your entire project immediately. They scan all files of their language type, build symbol tables, and resolve dependencies. By the time you ask your first question, the index is already warm.

This means `goToDefinition`, `findReferences`, and `hover` work for *any* symbol in your project — not just files you've opened. The language server has already seen everything.

## Using It in Practice

You don't need to learn any new commands. Just talk to Claude Code the way you normally would:

| You say... | Claude uses... |
| --- | --- |
| "Where is `authenticate` defined?" | `goToDefinition` |
| "Find all usages of `UserService` " | `findReferences` |
| "What type is `response`?" | `hover` |
| "What functions are in auth.ts?" | `documentSymbol` |
| "Find the `PaymentService` class" | `workspaceSymbol` |
| "What implements `AuthProvider`?" | `goToImplementation` |
| "What calls `processPayment`?" | `incomingCalls` |
| "What does `handleOrder` call?" | `outgoingCalls` |

The real power shows up in refactoring sessions. When you're renaming a method, adding a parameter, or changing a return type, LSP ensures Claude finds *every* reference and updates them correctly — not the "grep found 47 out of 52 actual usages" situation.

You can also press `Ctrl+O` to see diagnostics pushed by LSP servers. This shows you what the language servers are seeing in real time.

## The Gotchas

I hit most of these so you don't have to.

| Issue | Cause | Fix |
| --- | --- | --- |
| LSP tool not available at all | `ENABLE_LSP_TOOL` not set | Add under `"env"` in `settings.json`, restart |
| "Plugin not found in any marketplace" | Stale marketplace catalog | `claude plugin marketplace update claude-plugins-official` |
| Plugin installed but disabled | Not enabled after install | `claude plugin enable <name>` + restart |
| "Executable not found in $PATH" | Binary not installed or not in PATH | Install binary, verify with `which <binary>` |
| "No server available" | Race condition during startup | Restart Claude Code, wait for servers to initialize |
| "Total LSP servers loaded: 0" in logs | Plugins installed but all disabled | Enable plugins, restart |

### Debug Checklist

When things aren't working:

1. Check the binary is installed: `which pyright-langserver` (or whatever binary your language needs)
2. Check plugin status: `claude plugin list` — look for `Status: enabled`
3. Check debug logs at `~/.claude/debug/latest` — search for "Total LSP servers loaded: N" where N should be > 0

### Nudging Claude to Actually Use LSP

Even with LSP fully set up, Claude Code may default to its familiar tools (Grep, Read, Glob) instead of LSP. This is the most common complaint after setup. The fix: add explicit instructions telling Claude to prefer LSP for code navigation.

Two ways to do this:

- **CLAUDE.md** — add the snippet below to `~/.claude/CLAUDE.md` so it applies globally across all your projects. Or add it to your project's `CLAUDE.md` if you only want it for one repo.
- **Auto memory** — tell Claude in conversation: "remember to always prefer LSP over Grep for code navigation." Claude saves it to [auto memory](https://code.claude.com/docs/en/memory#auto-memory) and follows it in future sessions. Note: auto memory is per working tree, so you'd need to do this in each repo.
```
### Code Intelligence

Prefer LSP over Grep/Glob/Read for code navigation:
- \`goToDefinition\` / \`goToImplementation\` to jump to source
- \`findReferences\` to see all usages across the codebase
- \`workspaceSymbol\` to find where something is defined
- \`documentSymbol\` to list all symbols in a file
- \`hover\` for type info without reading the file
- \`incomingCalls\` / \`outgoingCalls\` for call hierarchy

Before renaming or changing a function signature, use
\`findReferences\` to find all call sites first.

Use Grep/Glob only for text/pattern searches (comments,
strings, config values) where LSP doesn't help.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.
```

Without these instructions, Claude treats LSP as just another tool in its toolbox. With them, it reaches for LSP first for code navigation and falls back to text search only when LSP can't help.

---

Every Claude Code session you run without LSP is a session where every "find this definition" takes 30-60 seconds instead of 50ms. Where every refactor misses call sites that a language server would have caught instantly. Where errors that LSP would have surfaced and auto-fixed slip through to your review.

The setup is two minutes. The feature flag is one line in your settings. The performance difference is not subtle — it's the gap between text search and semantic code intelligence. The same gap that made IDEs better than Notepad, except now it's making your AI assistant better at its job.

If you're already using Claude Code, [enable LSP](https://karanbansal.in/blog/claude-code-lsp/#setting-it-up). You'll feel it on the very first query.