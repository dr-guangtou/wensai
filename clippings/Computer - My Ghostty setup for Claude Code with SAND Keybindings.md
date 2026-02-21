---
title: Comnputer - My Ghostty setup for Claude Code with SAND Keybindings
source: https://x.com/dani_avila7/status/2023151176758268349
author:
  - "[[Daniel San]]"
published: 2026-02-16
created: 2026-02-20
description: Assistant Prof. in Astronomy at Tsinghua University, Beijing. @drguangtou@masodon.onlineLove all galaxies, study the big and small ones.
tags:
  - clippings
  - computer
---
After months using Claude Code daily I realized I was barely using VSCode or Cursor, just the terminal and git panel, everything else Claude Code handled.

The problem is VSCode’s terminal is fragile, long Claude Code sessions crash it, even on an M4. It’s not hardware, it’s a terminal not built for AI-scale output... I needed a real terminal

![Image](https://pbs.twimg.com/media/HBOlLlKbsAAGdbZ?format=png&name=large)

Ghostty came up, community matters and it’s built by [@mitchellh](https://x.com/@mitchellh), co-founder of HashiCorp, someone with a serious track record. Ghostty felt future-proof.

![Image](https://pbs.twimg.com/media/HBOk1hWXcAEtktr?format=jpg&name=large)

This is the first of three articles about my workflow with Ghostty and Claude Code I start with my "SAND" keybindings that make panel management second nature

1. My Ghostty setup for Claude Code with SAND Keybindings
2. Monitoring Claude Code changes with Lazygit
3. Parallel agents with Git worktrees and Claude Code

## Getting Started with Ghostty

Download Ghostty from [ghostty.org](https://ghostty.org/) (macOS and Linux). Once installed, you need a configuration file at ~/.config/ghostty/config.

The easiest way to set it up? Open Claude Code and tell it:

> Configure Ghostty with this config: [https://gist.github.com/davila7/5b07f55a6e65a06c121da9702d10c2e2](https://gist.github.com/davila7/5b07f55a6e65a06c121da9702d10c2e2)

Claude will read the gist, create the config file, and you're done. If you prefer to do it manually:

```bash
mkdir -p ~/.config/ghostty
curl -o ~/.config/ghostty/config https://gist.githubusercontent.com/davila7/5b07f55a6e65a06c121da9702d10c2e2/raw/config
```

# How I Manage Panels in Ghostty

Using Ghostty with Claude Code works best with split panels you might have Claude on one side, git changes on another, maybe a file browser on a third If you can’t split, navigate, and close panels without thinking you end up fumbling with shortcuts instead of coding.

I kept forgetting Ghostty’s keybindings so I organized them into a mnemonic SAND Four letters, four actions every panel operation falls into one of these categories

## S - Split: Create new panels

Split your terminal into multiple panels.

- Cmd+D splits right (vertical)
- Cmd+Shift+D splits down (horizontal)

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2023144301946085376/img/ej99O1DSAwK3p4MN.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/2cb636be-367b-4d6f-9589-30036fe4ab49"></video>

0:02 / 0:10

## A - Across: Move between tabs

Navigate across tabs.

- Cmd+T opens a new tab
- Cmd+Shift+Left/Right moves between them

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2023144669643939840/img/fBmkSo3y5xCkmOvD.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/1e178204-7dc7-4ab8-aa5c-73c6f7929545"></video>

0:01 / 0:07

## N - Navigate: Jump between split panels

Move focus between your splits.

- Cmd+Alt+Arrows jumps in any direction
- Cmd+Shift+E equalizes all splits

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2023144970392322048/img/nHFTG0DBmnxioM6q.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/b3dfd65b-8afd-4d86-ab44-63086a2f141d"></video>

![](https://pbs.twimg.com/amplify_video_thumb/2023144970392322048/img/nHFTG0DBmnxioM6q.jpg?name=large)

- Cmd+Shift+F zooms into one panel (press again to restore)

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2024289614102425601/img/oPbhX-zt0Wr5tBlf.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/0ef078b1-ae58-46d1-b46e-2ec7a302b472"></video>

0:01 / 0:07

## D - Destroy: Close panels and tabs

Close what you don't need.

- Cmd+W closes the current panel or tab

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2023145201729163264/img/vx3PYwrn3cKmXctc.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/2b46a40d-54dd-4134-ab62-ee118b49047f"></video>

0:02 / 0:10

## My Workflow Layout

This is what my daily setup looks like, and it scales from 1 to 3 Claude Code instances running in parallel... remember use SAND!

**Start simple:** one Claude Code panel on the left, **S** (Cmd+D) to split right, and run [lazygit](https://github.com/jesseduffield/lazygit) there to monitor every commit and diff Claude makes in real time.

![Image](https://pbs.twimg.com/media/HBOowOKaYAAnxMd?format=jpg&name=large)

Then **S** again (Cmd+Shift+D) to split the right panel down and open [yazi](https://github.com/sxyazi/yazi) as a file browser:

![Image](https://pbs.twimg.com/media/HBOpMvyXQAA-Qtz?format=jpg&name=large)

But when you're working on multiple tasks, you can split the left side into 2 or 3 Claude Code instances, each running on a different Git worktree:

![Image](https://pbs.twimg.com/media/HBOpcAiXMAAP-yn?format=jpg&name=large)

If some Claude Code panels get too big because you need more context you can press Cmd+Shift+E to equalize all windows and bring them back to a balanced layout

That’s the power of combining Ghostty with worktrees you go from a single agent to a multi-agent setup without leaving your terminal

## Tip:

stick a post-it with the letters SAND somewhere you can see it every time you see it, practice the commands after a week you’ll have Ghostty fully under control from the keyboard

![Image](https://pbs.twimg.com/media/HBOr3XvbQAAMr4R?format=jpg&name=large)

And if you ever forget a shortcut, just press **Cmd + Shift + P** to open the Command Palette and see the full list of available commands.

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2024290313917853697/img/uo3mvLqE9AduGy7S.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/b84f34fd-4080-4fba-844c-1b92fe2aaa12"></video>

0:01 / 0:09

# Next Articles

This was the first article ehe next two will show how I work with Ghostty and Claude Code

One article will cover **Lazygit,** watch Claude Code’s commits, diffs, and branch changes in real time

The other will cover git **worktrees and parallel agents,** run multiple Claude Code instances on different tasks and use **yazi** to browse project files

Follow me to catch the next articles! 👇