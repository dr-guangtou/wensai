---
title: "Agentic AI - How I Think About Codex"
source: "https://x.com/gabrielchua/status/2025017553442201807"
author:
  - "[[Gabriel Chua]]"
published: 2026-02-10
created: 2026-02-22
description:
tags:
  - "clippings"
---
When people say “Codex,” they don’t always mean the same thing. Sometimes they mean the model. Sometimes the app. Sometimes the agent.

Understandably, this can be confusing.

In plain terms, Codex is OpenAI’s software engineering agent, available through multiple interfaces, and an agent is a model plus instructions and tools, wrapped in a runtime that can execute tasks on your behalf.

Most developers don’t need to think about the internals. Pick the surface that fits your workflow and start building—often via the [quickstart](https://developers.openai.com/codex/quickstart). If you’re new to agentic coding, the standalone Codex app is the simplest entry point.

![Image](https://pbs.twimg.com/media/HBpJkDGasAAkoMS?format=jpg&name=large)

If you're new to agentic coding or Codex, the Codex App is our recommended way of getting started! It is a focused desktop experience for working on Codex threads in parallel, with built-in worktree support, automations, and Git functionality.

Source: [https://developers.openai.com/codex](https://developers.openai.com/codex)

But if you’re evaluating Codex for a team—or trying to make sense of online discussions, documentation, and frequent releases—the distinctions matter. “Codex” can refer to different layers of the system.

This post is for developers, and offers my **personal (and very unofficial)** mental model that I use to understand what’s actually changing when something new ships.

## My Mental Model: Codex = Model + Harness + Surfaces

At a high level, I see Codex as three parts working together:

Codex = Model + Harness + Surfaces

where

- The model provides intelligence.
- The harness (which is the collection of instructions & tools) turns that intelligence into something that can safely operate in a real development environment.
- The surfaces are the runtime and interfaces where you put that agent to work.

And more specifically:

- Model + Harness = the Agent
- Surfaces = how you interact with the Agent

Once you separate those layers, the rest becomes much easier to understand.

## The Model: Intelligence Optimized for Software Engineering

At the core of Codex are large language models (LLMs) optimized specifically for software engineering.

At a basic level, a LLM predicts the next token, and code is text. But [reasoning variants](https://developers.openai.com/api/docs/guides/reasoning/) go beyond autocomplete. Before producing an answer, the model can perform structured internal reasoning: decomposing the task, evaluating options, planning multi-step edits. That’s why Codex does not always respond instantly — it is reasoning.

> PS: You may sometimes notice terms like \`high\` or \`xhigh\` attached to the name of the model in the benchmark results. This is the \`reasoning\_effort\` parameter, a configurable dial that controls how much reasoning the model performs. Higher effort generally trades latency for stronger planning and better results on complex tasks.

But real software engineering is not just generating lines of code. It involves:

- Reading and understanding repositories
- Forming multi-step plans
- Editing across many files
- Running tools and interpreting outputs
- Responding to failures
- Iterating until something actually works

Today, OpenAI's flagship models are:

- [GPT-5.3-Codex](https://openai.com/index/introducing-gpt-5-3-codex/) — designed for complex, long-running, agentic coding tasks
- [GPT-5.3-Codex-Spark](https://openai.com/index/introducing-gpt-5-3-codex-spark/) — a smaller, faster variant optimized for real-time coding interactions

These same models can power other coding experiences, depending on product and integration choices. For example, you can use them inside tools like [Cursor](https://x.com/cursor_ai/status/2020921643145519249) or [GitHub Copilot](https://x.com/github/status/2020926945324679411). You can access them through your ChatGPT plan in tools like [OpenCode](https://x.com/thdxr/status/2009803906461905202). And they are also available via the Responses API, although API releases may lag behind first-party surfaces to [ensure safe deployments](https://x.com/OpenAIDevs/status/2019477567506383101?s=20).

> Feb 10
> 
> GPT-5.3 Codex is now available in Cursor! It's noticeably faster than 5.2 and is now the preferred model for many of our engineers.

> Jan 10
> 
> in opencode v1.1.11 you can now use your ChatGPT Plus/Pro plans in OpenCode /connect to set it up

The key point: the model is the intelligence. But intelligence alone does not make an agent.

## The Harness: What Turns a Model Into an Agent

A model can generate code, suggest edits, and reason about a diff. What it cannot do on its own is operate inside a real repository. It can’t inspect the file system, run tests, execute a build, or invoke the tools engineers rely on every day.

That’s what the harness is for.

The harness is the system that connects the model to a working software environment. It provides controlled access to files and repositories, the ability to run commands [safely](https://developers.openai.com/codex/security/), and a structured way to pass information into and out of the model so it can take on larger tasks without collapsing under context. The harness is what lets the model pull in extra context and use tools to get work done — for example via [MCP servers](https://developers.openai.com/codex/mcp/) or [Skills](https://developers.openai.com/codex/skills).

In practical terms, the harness enables the agent to read, plan, execute, verify, and iterate toward a working result.

Without the harness, you have suggestions.

With the harness, you have execution.

Notably, the Codex harness is [open source](http://github.com/openai/codex). You can inspect how it works and understand how execution is structured. For example, for longer-running tasks, the system uses [compaction](https://developers.openai.com/api/docs/guides/compaction). Instead of carrying forward an ever-growing conversation history, it compresses prior context into a summary that preserves the state needed to continue. The goal is continuity without ballooning context.

![Image](https://pbs.twimg.com/media/HBpKwDXbgAA8llO?format=jpg&name=large)

[https://github.com/openai/codex/](https://github.com/openai/codex/)

If you are curious to learn more about the Codex harness, you can refer to our engineering blog [post](https://openai.com/index/unrolling-the-codex-agent-loop/).

![Image](https://pbs.twimg.com/media/HBpLqkHa0AAYvEj?format=jpg&name=large)

Source: [https://openai.com/index/unlocking-the-codex-harness/](https://openai.com/index/unlocking-the-codex-harness/)

## The Model Trained for the Harness

The model and the harness aren’t separate pieces assembled later — they’re co-designed.

Codex models are trained in the presence of the harness. Tool use, execution loops, compaction, and iterative verification aren’t bolted on behaviors — they’re part of how the model learns to operate. The harness, in turn, is shaped around how the model plans, invokes tools, and recovers from failure.

Think of it like an athlete and their racquet. A professional trains with specific equipment for years. You wouldn’t swap it out the day before competition and expect the same performance.

Codex’s behavior emerges from the pairing. Change one, and you change the agent.

## The Surfaces: How You Put the Agent to Work

Once you have a model and a harness, you have an agent. The remaining question is how you want to use it. That’s where product surfaces come in.

You can use the Codex agent in different ways depending on the task. Sometimes you want to supervise multiple long-running threads in parallel. Sometimes you want tight, in-editor iteration. Sometimes you want terminal-native composability. Sometimes you want a lightweight entry point for remote or asynchronous work.

Codex exists across multiple surfaces because different stages of the software development lifecycle demand different interaction patterns.

1. The [Codex app](https://developers.openai.com/codex/app) is optimized for orchestrating parallel work: multiple agents, multiple threads, and long-running tasks supervised from one place. It also provides a single view for managing automations and skills, especially as these grow over time and within teams.
2. The [CLI](https://developers.openai.com/codex/cli) is built for terminal-first workflows where explicit control and composability matter. It integrates naturally into scripts and CI pipelines, and it also provides a [TypeScript SDK](https://developers.openai.com/codex/sdk) for building programmatic workflows on top of the same agent infrastructure.
3. The VSCode [IDE](https://developers.openai.com/codex/ide) extension emphasizes rapid, in-context editing — reviewing diffs, accepting changes, and iterating directly where you write code. Other native integrations are also available for [JetBrains IDEs](https://blog.jetbrains.com/ai/2026/01/codex-in-jetbrains-ides/) and [Xcode](https://x.com/OpenAIDevs/status/2018796432443244897).
4. The [web interface](https://developers.openai.com/codex/cloud) offers a lightweight way to start and supervise asynchronous tasks in a remote environment.

![Image](https://pbs.twimg.com/media/HBpLe4facAAa-Ym?format=jpg&name=large)

Source: [https://openai.com/index/unlocking-the-codex-harness/](https://openai.com/index/unlocking-the-codex-harness/)

Under the hood, many of these experiences are powered by the [Codex App Server](https://developers.openai.com/codex/app-server). The app server manages authentication, conversation history, approvals, and streamed agent events, enabling rich clients — such as IDE extensions or embedded integrations — to interact with the same underlying agent system. This makes it possible to embed Codex into other products while retaining a consistent execution model. The app server is also open source, so teams can inspect it or build on top of it directly. You can learn more about the app server in this [post](https://openai.com/index/unlocking-the-codex-harness/).

Codex is also designed to show up inside collaboration workflows. In [GitHub](https://developers.openai.com/codex/integrations/github), you can use it for code reviews and to fire off asynchronous web tasks in the PRs. In tools like [Slack](https://developers.openai.com/codex/integrations/slack) or [Linear](https://developers.openai.com/codex/integrations/linear), it can operate where teams plan and coordinate work, triggering tasks and connecting execution back to shared planning systems.

## Looking Ahead

In conclusion, thinking about Codex in terms of the **model, harness, and product surfaces** helps me understand what’s actually changing when something new ships.

That said, over time, these distinctions should matter less in day-to-day use. You’ll simply reach for Codex wherever it makes sense for the task at hand, and it should feel like one coherent toolkit — consistent behavior, consistent safety boundaries, consistent expectations — regardless of where you invoke it.

If you’re new to agentic coding, the best next step isn’t to internalize the architecture. It’s to try a real task end-to-end. Pick a surface (the Codex app is usually the easiest starting point) and see how it behaves on something that matters to you.

> One historical note to close: “Codex” originally referred to the [model](https://arxiv.org/abs/2107.03374) that powered the first version of GitHub Copilot. Today’s Codex models and product line are a separate system — different architecture, different harness, different agent design — but the name carried forward. The underlying idea remained the same: helping developers build faster with AI. Now, instead of just assisting with lines of code, Codex can help you ship complete work — and you can just build things.