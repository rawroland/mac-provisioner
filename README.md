# mac-provisioner

Ansible-based macOS developer machine provisioning. Run once on a fresh Mac; re-run any time to keep it current.

## Prerequisites

- macOS (Apple Silicon or Intel)
- Internet connection
- Xcode Command Line Tools — Homebrew will prompt for these if missing

## Usage

```bash
git clone <this-repo>
cd mac-provisioner
make install
```

Open a new terminal window when complete.

## What Gets Installed

| Category | Tools |
|---|---|
| Shell | zsh, oh-my-zsh, pure prompt, zsh-autosuggestions, zsh-syntax-highlighting |
| Docker | Colima (runtime), docker CLI, docker-compose |
| Languages | Node.js (LTS), Python, Go, Rust — managed via mise |
| Kubernetes | kubectl, helm, k9s, kubectx |
| CLI utilities | git, gh, jq, yq, fzf, ripgrep, bat, fd, htop, neovim, tmux, wget, tree |
| macOS | Sensible Finder, Dock, keyboard, and screenshot defaults |

## Customization

Edit `vars/main.yml` to change package lists, runtime versions, Colima resources, or macOS settings. See [CLAUDE.md](CLAUDE.md) for the full reference.

## Re-running

The playbook is fully idempotent — run `make install` again at any time to apply new changes or repair drift.
