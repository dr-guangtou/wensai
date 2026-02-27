---
title: "Setting Up SSH Keys for GitHub on macOS"
date: 2026-02-25
topic: "Git & GitHub Configuration"
category: "Development Tools"
tags: ["ssh", "github", "macos", "git", "authentication", "security"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Setting Up SSH Keys for GitHub on macOS

**Purpose:** Configure SSH key authentication so you can push/pull to GitHub without entering your password every time.

**Time Required:** ~5 minutes

---

## Quick Reference (For Those Who've Done It Before)

```bash
# 1. Generate key
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. Start agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Copy public key
pbcopy < ~/.ssh/id_ed25519.pub

# 4. Paste into GitHub → Settings → SSH Keys → New SSH Key

# 5. Test
ssh -T git@github.com
```

---

## Step-by-Step Guide

### Step 1: Check for Existing Keys

First, see if you already have SSH keys:

```bash
ls -la ~/.ssh
```

**Look for files named:**
- `id_ed25519` / `id_ed25519.pub` (recommended, modern)
- `id_rsa` / `id_rsa.pub` (older, but still works)

**If you see these files,** you can either:
- **Reuse them** — skip to Step 3
- **Start fresh** — backup and create new ones:

```bash
# Backup existing keys
mkdir -p ~/.ssh/backup
mv ~/.ssh/id_* ~/.ssh/backup/

# Or delete them (irreversible!)
rm ~/.ssh/id_*
```

---

### Step 2: Generate a New SSH Key

**Recommended: Ed25519 (faster, more secure)**

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**Alternative: RSA (if Ed25519 not supported)**

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

**When prompted:**

| Prompt | What to Enter |
|--------|---------------|
| "Enter file to save the key" | Press **Enter** (use default location) |
| "Enter passphrase" | Press **Enter** (empty = no passphrase) OR type a passphrase for extra security |
| "Enter same passphrase again" | Press **Enter** or repeat your passphrase |

**Note:** Using no passphrase means you never need to type anything, but anyone with access to your computer can use your key. Using a passphrase is more secure but requires entering it each session (unless you use Keychain, see below).

---

### Step 3: Start SSH Agent and Add Your Key

The SSH agent holds your key in memory so you don't need to specify it each time.

**Start the agent:**
```bash
eval "$(ssh-agent -s)"
```

**Add your key:**
```bash
# For Ed25519
ssh-add ~/.ssh/id_ed25519

# For RSA
ssh-add ~/.ssh/id_rsa
```

---

### Step 4: (Optional) Save Passphrase to macOS Keychain

If you chose to use a passphrase, you can save it to macOS Keychain so you never need to type it:

**1. Edit SSH config:**
```bash
nano ~/.ssh/config
```

**2. Add these lines:**
```
Host *.github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

**3. Save and exit:** Press `Ctrl+O`, `Enter`, then `Ctrl+X`

**4. Add key with Keychain:**
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

---

### Step 5: Copy Your Public Key

**Copy to clipboard:**
```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

**Or view it to copy manually:**
```bash
cat ~/.ssh/id_ed25519.pub
```

Your public key looks like:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your_email@example.com
```

---

### Step 6: Add Key to GitHub

**1. Open GitHub in your browser:**
- Go to https://github.com
- Sign in

**2. Navigate to SSH Settings:**
- Click your **avatar** (top right)
- Click **Settings**
- Click **SSH and GPG keys** (left sidebar)
- Click **New SSH key**

**3. Add the key:**
- **Title:** Something descriptive like "MacBook Pro - Work"
- **Key type:** Authentication Key
- **Key:** Paste your public key (already in clipboard from Step 5)
- Click **Add SSH key**
- Confirm with your GitHub password

---

### Step 7: Test the Connection

```bash
ssh -T git@github.com
```

**Expected output:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

If you see this, **you're done!** 🎉

---

## Step 8: Update Existing Repositories

If you have existing repositories cloned with HTTPS, you need to switch them to SSH:

**Check current remote:**
```bash
cd /path/to/your/repo
git remote -v
```

**If you see `https://github.com/...`:**

```bash
# Switch to SSH
git remote set-url origin git@github.com:username/repo.git

# Verify
git remote -v
```

**Should now show:**
```
origin  git@github.com:username/repo.git (fetch)
origin  git@github.com:username/repo.git (push)
```

---

## Troubleshooting

### "Permission denied (publickey)"

**Cause:** SSH agent doesn't have your key, or key isn't added to GitHub.

**Solutions:**

```bash
# 1. Check if key exists
ls -la ~/.ssh

# 2. Start agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Test again
ssh -T git@github.com
```

### "Agent admitted failure to sign"

**Cause:** Key not loaded in agent.

**Solution:**
```bash
ssh-add ~/.ssh/id_ed25519
```

### "Could not open a connection to your authentication agent"

**Cause:** SSH agent not running.

**Solution:**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### SSH Agent Doesn't Persist After Restart

**Cause:** SSH agent not configured to auto-start.

**Solution:** Add to your shell config:

```bash
# For zsh (default on macOS)
echo 'eval "$(ssh-agent -s)"' >> ~/.zshrc
echo 'ssh-add ~/.ssh/id_ed25519 2>/dev/null' >> ~/.zshrc

# Reload
source ~/.zshrc
```

### Multiple GitHub Accounts

If you need different keys for different accounts:

**1. Create config file:**
```bash
nano ~/.ssh/config
```

**2. Add multiple hosts:**
```
# Personal GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal

# Work GitHub
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
```

**3. Clone using alias:**
```bash
# Personal
git clone git@github.com:username/repo.git

# Work
git clone git@github-work:company/repo.git
```

### Verifying Your Key Fingerprint

To verify the key on GitHub matches your local key:

```bash
ssh-keygen -lf ~/.ssh/id_ed25519.pub
```

Compare the fingerprint with what's shown on GitHub → Settings → SSH Keys.

---

## Quick Reference Card

### File Locations

| File | Purpose |
|------|---------|
| `~/.ssh/id_ed25519` | Private key (NEVER share!) |
| `~/.ssh/id_ed25519.pub` | Public key (upload to GitHub) |
| `~/.ssh/config` | SSH configuration |
| `~/.ssh/known_hosts` | Verified host fingerprints |

### Key Commands

```bash
# Generate key
ssh-keygen -t ed25519 -C "email"

# Start agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Add key to macOS Keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy public key
pbcopy < ~/.ssh/id_ed25519.pub

# View public key
cat ~/.ssh/id_ed25519.pub

# List loaded keys
ssh-add -l

# Remove all keys from agent
ssh-add -D

# Test GitHub connection
ssh -T git@github.com

# Switch remote from HTTPS to SSH
git remote set-url origin git@github.com:user/repo.git
```

### GitHub URLs

| Type | Format |
|------|--------|
| HTTPS | `https://github.com/username/repo.git` |
| SSH | `git@github.com:username/repo.git` |

---

## Security Best Practices

1. **Never share your private key** (`id_ed25519`, `id_rsa`)
2. **Use a passphrase** for sensitive accounts
3. **Use Keychain** to remember passphrases on macOS
4. **Rotate keys** if you suspect compromise
5. **Use different keys** for different services/accounts
6. **Review authorized keys** periodically on GitHub

---

## Summary Checklist

- [ ] Generate SSH key: `ssh-keygen -t ed25519 -C "email"`
- [ ] Start agent: `eval "$(ssh-agent -s)"`
- [ ] Add key: `ssh-add ~/.ssh/id_ed25519`
- [ ] Copy public key: `pbcopy < ~/.ssh/id_ed25519.pub`
- [ ] Add to GitHub: Settings → SSH Keys → New SSH Key
- [ ] Test: `ssh -T git@github.com`
- [ ] Update existing repos: `git remote set-url origin git@github.com:...`

---

*Manual compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-25*
