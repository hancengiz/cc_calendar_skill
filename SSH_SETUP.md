# SSH Setup Guide for Claude Code

This guide explains the SSH key setup for secure GitHub access with your Claude Code projects.

## 🔑 SSH Key Information

**Key Type**: ED25519 (Modern, secure, compact)
**Private Key**: `~/.ssh/claude_code_github`
**Public Key**: `~/.ssh/claude_code_github.pub`
**Identifier**: `claude-code`

### Public Key

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPc4Az97sukCf9xNRXrxgRlvcL9XDLgymtRxhu0yHi90 claude-code
```

## 📋 What Was Configured

1. **SSH Key Generated**
   - Created ED25519 key pair for Claude Code
   - Stored in `~/.ssh/claude_code_github`
   - Secured with proper file permissions (600)

2. **SSH Config Updated**
   - Modified `~/.ssh/config` to use new key for GitHub
   - Configured automatic key loading with UseKeychain

## 🚀 Add SSH Key to GitHub

To complete the setup and use SSH authentication with GitHub:

### Step 1: Copy Public Key

```bash
cat ~/.ssh/claude_code_github.pub
```

Output:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPc4Az97sukCf9xNRXrxgRlvcL9XDLgymtRxhu0yHi90 claude-code
```

### Step 2: Add to GitHub

1. Go to: https://github.com/settings/keys
2. Click **"New SSH key"**
3. **Title**: "Claude Code"
4. **Key type**: Authentication Key
5. **Key**: Paste the entire public key (output from Step 1)
6. Click **"Add SSH key"**

### Step 3: Verify Connection

```bash
ssh -T git@github.com
```

Expected output:
```
Hi HanCengiz! You've successfully authenticated, but GitHub does not provide shell access.
```

## 📚 SSH Configuration Details

Your SSH config now includes:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/claude_code_github
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes
    PreferredAuthentications publickey
```

This configuration:
- Uses the Claude Code SSH key for GitHub
- Automatically adds key to ssh-agent on first use
- Stores passphrase in macOS Keychain
- Prioritizes public key authentication

## 🔐 Security Features

✅ **ED25519 Encryption**: Modern, NIST-approved curve
✅ **File Permissions**: Private key is 600 (owner read/write only)
✅ **Keychain Integration**: Password stored securely in macOS Keychain
✅ **Key Isolation**: GitHub key separate from other SSH keys
✅ **No Passphrase Required**: Configured for automated access

## 🔄 Using SSH with Git

### Clone with SSH

```bash
git clone git@github.com:hancengiz/cc_calendar_skill.git
```

### Convert HTTPS to SSH

If you cloned with HTTPS and want to switch to SSH:

```bash
cd cc_calendar_skill
git remote set-url origin git@github.com:hancengiz/cc_calendar_skill.git
git remote -v  # Verify the change
```

### Push/Pull with SSH

Once SSH is configured, push and pull automatically use the SSH key:

```bash
git push origin master
git pull origin master
```

## 🛠️ Troubleshooting

### "Permission denied (publickey)"

**Cause**: SSH key not added to GitHub
**Solution**: Follow "Add SSH Key to GitHub" section above

### "Could not open a connection to your authentication agent"

**Cause**: SSH agent not running
**Solution**:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/claude_code_github
```

### "Key not being used even though configured"

**Cause**: Key permissions incorrect
**Solution**:
```bash
chmod 600 ~/.ssh/claude_code_github
chmod 644 ~/.ssh/claude_code_github.pub
chmod 600 ~/.ssh/config
```

### Test SSH key manually

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
ssh -i ~/.ssh/claude_code_github -T git@github.com
```

## 📁 Key Locations

- **Private Key**: `~/.ssh/claude_code_github`
- **Public Key**: `~/.ssh/claude_code_github.pub`
- **SSH Config**: `~/.ssh/config`
- **Known Hosts**: `~/.ssh/known_hosts`

## 🔗 Related Files

- Development Repo: `/Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill/`
- GitHub Repo: `https://github.com/hancengiz/cc_calendar_skill`
- Installation: `install.sh` in project root

## ✅ Verification Checklist

- [ ] SSH key generated (`~/.ssh/claude_code_github` exists)
- [ ] Public key copied from `~/.ssh/claude_code_github.pub`
- [ ] SSH key added to GitHub account settings
- [ ] SSH connection verified with `ssh -T git@github.com`
- [ ] Repository cloned/configured with SSH URL
- [ ] Push/pull operations work with SSH

## 🎓 More Information

- [GitHub SSH Key Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [SSH Key Pair Generation Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [ED25519 Key Advantages](https://wiki.mozilla.org/Security/Guidelines/Key_Management#Algorithms)

---

**Created**: November 11, 2025
**For**: Claude Code macOS Calendar Skill
**Scope**: GitHub SSH authentication setup
