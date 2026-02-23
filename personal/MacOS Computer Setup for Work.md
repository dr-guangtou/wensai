---
title: "MacOS Computer Setup for Work"
date: 2026-02-23
topic: "Mac Setup"
category: "Documentation"
tags: ["macos", "setup", "tools", "productivity", "development"]
status: "complete"
source: "Yuzhe Research"
type: "documentation"
---

# MacOS Computer Setup for Work

A comprehensive guide for setting up a productive macOS development environment. This document covers essential utilities, terminal tools, coding environments, and agentic AI tools.

---

## Important Utility

### Magnet (Window Manager)
- **Website:** <https://magnet.crowdcafe.com>
- **Mac App Store:** <https://apps.apple.com/app/magnet/id441258766>

**Installation:**
- Purchase and download directly from the Mac App Store (~$7.99 USD, one-time purchase)

**Best Practices:**
- Enable "Launch at login" in preferences
- Learn/customize keyboard shortcuts:
  - **Ctrl+Option+Enter** — Maximize window
  - **Ctrl+Option+Arrow keys** — Snap to halves
  - **Ctrl+Option+U/I/O/P** — Snap to quarters
- Supports up to 6 external displays
- Works with vertical monitors (thirds arrange along sides)

---

### Dropbox
- **Website:** <https://www.dropbox.com>
- **Download:** <https://www.dropbox.com/download>

**Installation:**
- Download the `.dmg` installer from the website
- Double-click to mount, drag Dropbox.app to the Applications folder
- Sign in with your account during the first launch

**Best Practices:**
- Enable "Start Dropbox on system startup."
- Use **Selective Sync** to manage which folders download locally vs. stay online-only
- Enable **Smart Sync** for saving local disk space
- Enable Camera Uploads for automatic photo backup

---

### Grammarly
- **Website:** <https://www.grammarly.com/desktop>
- **Direct Download:** <https://www.grammarly.com/service/download/direct>

**Installation:**
- Download Grammarly for Mac from the website
- Open the `.dmg` and follow the installation prompts
- Requires Grammarly account (free tier available)

**Best Practices:**
- Grant accessibility permissions when prompted (required to work across apps)
- Works in Microsoft Word, Pages, email clients, browsers, and most text fields
- Use the Grammarly widget to quickly enable/disable for specific apps
- Premium features: tone detection, advanced suggestions, generative AI

---

### Bartender
- **Website:** <https://www.macbartender.com>

**Installation:**
- Download Bartender 6 from the website (DMG installer)
- **Note:** Bartender 6 requires **macOS Sequoia or later**
- Drag to the Applications folder and launch
- 4-week free trial; license required after

**Best Practices:**
- **Groups:** Combine related menu bar items (e.g., all cloud drives together)
- **Presets:** Create different layouts for work vs. personal use
- **Triggers:** Auto-switch presets based on WiFi network, location, time, or battery
- **Quick Search:** Press hotkey to instantly find and activate any menu bar item
- **Styling:** Customize menu bar appearance with colors, gradients, rounded corners

---

### iStat Menus
- **Website:** <https://bjango.com/mac/istatmenus/>

**Installation:**
- Download from the website (also available on Setapp)
- 14-day free trial; license required after
- Family pack available for up to 5 family members

**Best Practices:**
- Use **Combined Mode** to save menu bar space while accessing all stats
- Configure **Rules** for notifications (e.g., CPU > 60%, low disk space)
- Enable the **Weather** widget for detailed forecasts
- Monitor **Apple Silicon**-specific sensors (efficiency/performance cores)
- Control fan speeds gradually based on temperature curves

---

### 1Password
- **Website:** <https://1password.com>
- **Download:** <https://1password.com/downloads/mac/>

**Installation:**
- Download from the website or Mac App Store
- Requires a 1Password account (subscription-based)

**Best Practices:**
- Enable **biometric unlock** (Touch ID/Face ID) for quick access
- Use **Watchtower** to monitor for password breaches
- Set up **Shared Vaults** for family/team passwords
- Enable **Autofill** in browsers and Mac apps
- Generate strong passwords and passkeys for all accounts
- Use **Secure Notes** for sensitive non-password data

---

### Homebrew
- **Website:** <https://brew.sh>
- **Documentation:** <https://docs.brew.sh>

**Installation:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Post-Installation (Apple Silicon):**
```bash
# Add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Best Practices:**
- Run `brew update` regularly to keep the package list current
- Use `brew upgrade` to update installed packages
- Use `brew doctor` to check for issues
- Install GUI apps via `brew install --cask <app-name>`
- Keep Brewfile for reproducible setups: `brew bundle dump`

---

## Terminal Environment

### Ghostty
- **Website:** <https://ghostty.org>
- **GitHub:** <https://github.com/ghostty-org/ghostty>

**Installation:**
```bash
brew install --cask ghostty
```

**Best Practices:**
- Configure via `~/.config/ghostty/config`
- Supports GPU acceleration for smooth rendering
- Native macOS integration with tabs and split panes
- Configure custom keybindings for workflow efficiency

---

### LazyVim
- **Website:** <https://www.lazyvim.org>
- **GitHub:** <https://github.com/LazyVim/LazyVim>

**Installation:**
```bash
# Make backup of existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove .git folder to avoid conflicts
rm -rf ~/.config/nvim/.git
```

**Best Practices:**
- Leader key is **Space** by default
- Use `<leader>sk` to search keymaps
- Add custom plugins in `~/.config/nvim/lua/plugins/`
- Modify settings in `~/.config/nvim/lua/config/options.lua`
- Run `:Lazy` to manage plugins
- Run `:Mason` to manage LSP servers

- Tip: `neovim`'s Markdown lint can be too aggressive. To suppress it completely, edit `~/.config/nvim/lua/plugins/markdownlint.lua`: 

```lua
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = false,
      },
    },
  },
}
```
- Tip: `Neovim`'s `flash.nvim` plugin "stole" the key mapping for `s` to search. To restore the desired "delete the character and start editing" behavior: 
	- In `~/.config/nvim/lua/config/keymaps.lua` , add:
	```lua
	pcall(vim.keymap.del, { "n", "x", "o" }, "s")
	pcall(vim.keymap.del, { "n", "x", "o" }, "S")
	```


---

### Lazygit
- **Website:** <https://github.com/jesseduffield/lazygit>

**Installation:**
```bash
brew install lazygit
```

**Best Practices:**
- Launch with `lazygit` in any git repository
- Use `?` to show keybindings for current context
- Configure via `~/.config/lazygit/config.yml`
- Integrate with your editor for seamless workflow
- Use arrow keys to navigate, enter to select, space to stage

---

### Yazi
- **Website:** <https://yazi-rs.github.io>
- **GitHub:** <https://github.com/sxyazi/yazi>

**Installation:**
```bash
brew install yazi
```

**Best Practices:**
- Configuration in `~/.config/yazi/yazi.toml`
- Supports image previews in terminal
- Use `y` to yank, `p` to paste, `d` to delete
- Integrates with zoxide for smart directory jumping
- Use `~` for home, `-` for previous directory

---

### fzf
- **Website:** <https://github.com/junegunn/fzf>

**Installation:**
```bash
brew install fzf

# Set up shell integration
$(brew --prefix)/opt/fzf/install
```

**Best Practices:**
- Use **Ctrl+T** to fuzzy find files
- Use **Ctrl+R** to search command history
- Use `command **<Tab>` for fuzzy completion
- Configure via `~/.fzf.zsh` or `~/.fzf.bash`
- Combine with other tools: `git ls-files | fzf`

---

### mole (SSH Tunneling)
- **Website:** <https://davrodpin.github.io/mole/>
- **GitHub:** <https://github.com/davrodpin/mole>

**Installation:**
```bash
brew install mole
```

**Best Practices:**
- Create alias configurations in `~/.mole/` directory
- Use `mole start <alias>` to start tunnels
- Store connection configurations for frequently used servers
- Combine with SSH config for streamlined access

---

### Bun
- **Website:** <https://bun.sh>

**Installation:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**Best Practices:**
- Use `bun` instead of `npm` for faster package installation
- Run scripts with `bun run <script>`
- Use `bunx` instead of `npx`
- Configure via `bunfig.toml`

---

### gtop / htop
- **htop Website:** <https://htop.dev>
- **gtop GitHub:** <https://github.com/aksakalli/gtop>

**Installation:**
```bash
brew install htop
brew install gtop
```

**Best Practices:**
- Use `htop` for interactive process viewer with color-coded CPU/Memory
- Use `gtop` for graphical system monitoring in terminal
- In htop: use `F3` to search, `F4` to filter, `F9` to kill processes
- Customize htop display with `F2` setup menu

---

### tmux
- **Website:** <https://github.com/tmux/tmux>

**Installation:**
```bash
brew install tmux
```

**Best Practices:**
- Configure via `~/.tmux.conf`
- Set prefix to **Ctrl+A** (easier reach than default Ctrl+B)
- Use plugins via TPM (Tmux Plugin Manager)
- Essential keybindings:
  - `Prefix + c` — new window
  - `Prefix + n/p` — next/previous window
  - `Prefix + %` — vertical split
  - `Prefix + "` — horizontal split
  - `Prefix + arrow` — navigate panes

---

### screen
- **Built-in with macOS**

**Basic Usage:**
```bash
screen -S session_name    # Create named session
screen -ls                # List sessions
screen -r session_name    # Reattach to session
Ctrl+A, D                 # Detach from session
```

**Best Practices:**
- Use tmux instead for modern terminal multiplexing
- Useful for long-running processes on remote servers
- Screen is always available (no installation needed)

---

## Basic Coding

### Xcode Command Line Tools
**Installation:**
```bash
xcode-select --install
```

**Verification:**
```bash
xcode-select -p
# Should show: /Library/Developer/CommandLineTools or /Applications/Xcode.app/...
```

**Best Practices:**
- Required for Homebrew and many development tools
- Install before attempting Homebrew installation
- Accept license agreement: `sudo xcodebuild -license accept`

---

### Python (via Miniforge)
- **Website:** <https://github.com/conda-forge/miniforge>

**Installation:**
```bash
brew install miniforge
```

**Best Practices:**
- Use `conda` for environment management
- Create environments: `conda create -n myenv python=3.11`
- Activate: `conda activate myenv`
- Prefer conda-forge channel over defaults
- Use `mamba` (included) for faster dependency resolution

---

### uv (Python Package Manager)
- **Website:** <https://docs.astral.sh/uv/>
- **GitHub:** <https://github.com/astral-sh/uv>

**Installation:**
```bash
brew install uv
```

**Best Practices:**
- Extremely fast Python package installer (replaces pip)
- Create virtual environments: `uv venv`
- Install packages: `uv pip install <package>`
- Run scripts: `uv run script.py`
- Lock dependencies: `uv pip compile requirements.in -o requirements.txt`

---

### ruff (Python Linter & Formatter)
- **Website:** <https://docs.astral.sh/ruff/>
- **GitHub:** <https://github.com/astral-sh/ruff>

**Installation:**
```bash
brew install ruff
```

**Best Practices:**
- Drop-in replacement for flake8, black, isort, and more
- Configure via `pyproject.toml`:
  ```toml
  [tool.ruff]
  line-length = 88
  select = ["E", "F", "I"]
  ```
- Run linter: `ruff check .`
- Run formatter: `ruff format .`
- Integrate with pre-commit hooks

---

## VPN

### Astrill VPN
- **Website:** <https://www.astrill.com>

**Installation:**
- Download from website
- Install the `.pkg` or `.dmg` installer
- Sign in with Astrill account

**Best Practices:**
- Enable "Connect on startup" in settings
- Use StealthVPN or OpenWeb protocols for restrictive networks
- Configure kill switch to prevent leaks
- Test connection with built-in speed test

---

### Proton VPN
- **Website:** <https://protonvpn.com>

**Installation:**
```bash
brew install --cask protonvpn
```

**Best Practices:**
- Enable **Kill Switch** in settings
- Use **NetShield** for ad/tracker blocking
- Enable **Secure Core** for enhanced privacy (slower but more secure)
- Configure auto-connect on untrusted networks

---

## Communication & Collaboration

### Slack
- **Website:** <https://slack.com/downloads/mac>

**Installation:**
```bash
brew install --cask slack
```

**Best Practices:**
- Enable dark mode for reduced eye strain
- Configure notifications per workspace
- Use keyboard shortcuts: `Cmd+K` for quick switcher
- Enable "Launch on login" for work accounts

---

### Discord
- **Website:** <https://discord.com/download>

**Installation:**
```bash
brew install --cask discord
```

**Best Practices:**
- Enable "Open Discord" at login if needed
- Configure push notifications per server/channel
- Use `Cmd+Shift+N` for new server
- Enable noise suppression for better audio quality

---

### Zoom
- **Website:** <https://zoom.us/download>

**Installation:**
```bash
brew install --cask zoom
```

**Best Practices:**
- Enable "Silence system notifications when sharing screen"
- Configure virtual backgrounds for professional meetings
- Use "Touch up my appearance" option if desired
- Enable dual monitor support for screen sharing

---

### Tencent Meeting (腾讯会议)
- **Website:** <https://meeting.tencent.com>
- **Note:** Use the Chinese version (not VooV/International)

**Installation:**
- Download from official Chinese website
- Install via `.dmg` installer

**Best Practices:**
- Sign in with WeChat or phone number
- Enable "Join audio automatically"
- Configure virtual backgrounds
- Use beauty filter for video meetings

---

### Feishu (飞书)
- **Website:** <https://www.feishu.cn/download>
- **Note:** Use the Chinese version (not Lark/International)

**Installation:**
- Download from official Chinese website
- Sign in with phone number or enterprise account

**Best Practices:**
- Enable notifications for important conversations
- Use "Do Not Disturb" mode during focus time
- Integrate with calendar for meeting reminders
- Enable cloud document sync

---

## Notebook Related

### Obsidian
- **Website:** <https://obsidian.md>

**Installation:**
```bash
brew install --cask obsidian
```

**Best Practices:**
- Use **Vaults** to organize different projects/areas of life
- Enable **Sync** for cross-device access (subscription)
- Install community plugins via Settings > Community Plugins
- Recommended plugins:
  - Dataview (database queries)
  - Templater (templates)
  - Calendar (daily notes)
- Use **Daily Notes** for journaling
- Learn Markdown for formatting

**Obsidian CLI Setup:**
```bash
# Install official Obsidian CLI
# Download from: https://github.com/obsidianmd/obsidian-cli
# Or use community alternatives
```

---

## Coding IDE

### VSCode
- **Website:** <https://code.visualstudio.com>

**Installation:**
```bash
brew install --cask visual-studio-code
```

**Best Practices:**
- Install essential extensions:
  - Python (Microsoft)
  - GitLens (Git supercharged)
  - Prettier (code formatter)
  - Error Lens (inline error display)
  - Todo Tree (highlight TODOs)
- Enable Settings Sync for cross-device configuration
- Configure `code` command in PATH
- Use workspaces for project organization

---

## Agentic Coding Environments

### Claude Code (Anthropic)
- **Website:** <https://claude.ai/code>
- **Documentation:** <https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview>

**Installation:**
```bash
# Install via npm
npm install -g @anthropic-ai/claude-code

# Or use npx (no install)
npx @anthropic-ai/claude-code
```

**CLAUDE.md Configuration:**
- Create `CLAUDE.md` in project root or home directory (`~/.claude/CLAUDE.md`)
- This file serves as the "master mandate" for Claude Code
- Include:
  - Project context and goals
  - Coding standards and conventions
  - Preferred tools and workflows
  - Constraints and preferences

**Example CLAUDE.md structure:**
```markdown
# Project Context
[Description of project]

## Coding Standards
- Language: Python
- Style: PEP 8
- Testing: pytest

## Tools
- Package manager: uv
- Linter: ruff
- Formatter: ruff

## Constraints
- Never use camelCase (always snake_case)
- Protect main branch (always use feature branches)
```

---

### Claude Desktop
- **Website:** <https://claude.ai/download>

**Installation:**
- Download from official website
- Sign in with Anthropic account

**Best Practices:**
- Enable "Launch at login"
- Configure global keyboard shortcut for quick access
- Use Projects for context-aware conversations
- Upload files for analysis and editing

---

### Codex CLI (OpenAI)
- **Website:** <https://github.com/openai/codex>

**Installation:**
```bash
npm install -g @openai/codex
```

**Configuration:**
- Requires OpenAI API key
- Set `OPENAI_API_KEY` environment variable
- Or use `codex config` to set credentials

**AGENTS.md Configuration:**
- Create `AGENTS.md` in project root
- Serves as the master mandate file for Codex
- Similar structure to CLAUDE.md

---

### Codex Desktop
- **Website:** <https://openai.com/codex>

**Installation:**
- Download from OpenAI website
- Sign in with OpenAI account

---

### Kimi CLI (Moonshot AI)
- **Website:** <https://www.moonshot.cn>

**Installation:**

- Using `uv`:

```bash
uv tool install --python 3.13 kimi-cli
```

- Or 
```bash
curl -LsSf https://code.kimi.com/install.sh | bash
```

**KIMI.md Configuration:**
- Create `KIMI.md` in project root
- Moonshot AI's equivalent to CLAUDE.md
- Define project context, standards, and preferences

**Upgrade** through `uv`

```bash
uv tool upgrade kimi-cli --no-cache
```

---

### Gemini CLI (Google)
- **Website:** <https://ai.google.dev/gemini-api/docs/cli>

**Installation:**
```bash
# Install via npm
npm install -g @google/gemini-cli
```

**GEMINI.md Configuration:**
- Create `GEMINI.md` in project root
- Google's mandate file for project context
- Include API key configuration and preferences

---

### Antigravity (Google)
- **Website:** <https://github.com/google/antigravity>

**Note:** Experimental Google AI tool for coding assistance

**Installation:**
```bash
# Clone and install from GitHub
git clone https://github.com/google/antigravity.git
cd antigravity && pip install -e .
```

---

### Copilot CLI (GitHub)
- **Website:** https://github.com/features/copilot/cli

**Installation:**
```bash
npm install -g @github/copilot
```

**Best Practices:**
- Requires GitHub Copilot subscription
- Authenticate with `gh auth login`
- Use `gh copilot suggest` for command suggestions
- Use `gh copilot explain` to explain commands

---

### TRAE CN Desktop App
- **Website:** <https://trae.ai> (Chinese version)

**Installation:**
- Download from official Chinese website
- Install via `.dmg` installer

**Note:** TRAE is a Chinese AI coding assistant with IDE integration

---

### Qoder Desktop App
- **Website:** <https://www.qoder.ai>

**Installation:**
- Download from official website
- Sign up/in with account

**Note:** AI-powered code editor with integrated assistance

---

### Opencode CLI
- **Website:** <https://opencode.ai>
- **GitHub:** <https://github.com/opencode-ai/opencode>

**Installation:**
```bash
# Install via npm
npm install -g opencode-ai
```

---

## OpenClaw
- **Website:** <https://openclaw.ai>
- **Documentation:** <https://docs.openclaw.ai>

**Installation:**
```bash
# Install via npm
npm install -g openclaw

# Or download from website
```

**Setup:**
```bash
# Initialize OpenClaw
openclaw init

# Configure channels (Discord, WhatsApp, etc.)
openclaw configure

# Check status
openclaw status
```

**AGENTS.md Configuration:**
- OpenClaw reads `AGENTS.md` in workspace root
- Similar to other agent mandate files
- Define identity, preferences, and constraints

**OpenClaw CLI Commands:**
```bash
openclaw status              # Check system status
openclaw logs --follow       # Follow logs
openclaw gateway start       # Start gateway service
openclaw gateway stop        # Stop gateway service
openclaw update              # Update to latest version
```

**Best Practices:**
- Keep workspace in `~/.openclaw/workspace/`
- Configure memory files for continuity:
  - `SOUL.md` — Define personality and behavior
  - `USER.md` — Information about the human user
  - `MEMORY.md` — Long-term knowledge storage
  - `AGENTS.md` — Working principles and constraints
- Use skills for extended capabilities
- Set up cron jobs for automated tasks

---

## Summary

This guide covers the essential tools for a productive macOS development environment:

1. **Utilities** — Window management, cloud storage, password management
2. **Terminal** — Modern shell tools for efficient command-line work
3. **Coding** — Python environment with modern tooling (uv, ruff)
4. **VPN** — Secure connectivity options
5. **Communication** — Team collaboration tools
6. **Note-taking** — Obsidian for knowledge management
7. **IDE** — VSCode for development
8. **AI Agents** — Multiple coding assistants with mandate file patterns

### Mandate File Pattern

Most AI coding agents follow a similar configuration pattern:

| Agent | Mandate File | Location |
|-------|-------------|----------|
| Claude Code | `CLAUDE.md` | Project root or `~/.claude/` |
| Codex | `AGENTS.md` | Project root |
| Kimi | `KIMI.md` | Project root |
| Gemini | `GEMINI.md` | Project root |
| OpenClaw | `AGENTS.md` | Workspace root (`~/.openclaw/workspace/`) |

These files typically include:
- Project context and goals
- Coding standards (language, style, conventions)
- Preferred tools and workflows
- Constraints and boundaries
- Communication preferences

---

*Last Updated: 2026-02-23*
*Created by: Yuzhe*
