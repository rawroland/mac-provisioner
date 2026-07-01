# mac-provisioner

Ansible playbook that fully provisions a macOS developer machine. Single entrypoint: `make install`.

## Running

```bash
make install      # bootstrap + full provisioning run
make check        # dry-run (no changes applied)
make lint         # run ansible-lint
```

`make install` handles its own bootstrap: installs Homebrew if missing, installs Ansible via brew, then installs Ansible Galaxy collections from `requirements.yml` before running the playbook.

## Customization

All user-facing configuration lives in **`vars/main.yml`**. Edit that file, not role internals.

| Setting | How to change |
|---|---|
| Add a CLI tool | Append to `homebrew_formulae` in `vars/main.yml` |
| Add a GUI app | Append to `homebrew_casks` in `vars/main.yml` |
| Change runtime version | Edit `mise_tools.<lang>` in `vars/main.yml` |
| Change Colima resources | Edit `colima_cpu/memory/disk` in `vars/main.yml` |
| Change macOS prefs | Edit `macos_*` vars in `vars/main.yml` |

## Role Structure

```
roles/
├── homebrew/     — Homebrew installation and all package installs
├── dev_tools/    — oh-my-zsh, pure prompt, zsh plugins, ~/.zshrc template
├── colima/       — Docker runtime (Colima), LaunchAgent for auto-start
├── mise/         — Language version manager + runtime installs
├── kubernetes/   — kubectl, helm, k9s, kubectx
└── macos/        — macOS system preferences via `defaults write`
```

## Key Design Notes

- **Idempotent**: every task checks state before acting; safe to re-run at any time
- **Apple Silicon + Intel**: `brew_prefix` is auto-detected in `playbook.yml` pre_tasks and available to all roles
- **`~/.zshrc` is fully managed**: edit `roles/dev_tools/templates/zshrc.j2` to change shell config — manual edits to `~/.zshrc` will be overwritten on next run (original is backed up to `~/.zshrc.bak`)
- **Colima auto-starts** on login via `~/Library/LaunchAgents/com.github.colima.plist`
- **Docker socket**: `DOCKER_HOST` points to `~/.colima/default/docker.sock`; no Docker Desktop required

## Adding a New Role

1. Create `roles/<name>/{tasks/main.yml,defaults/main.yml}`
2. Add `- <name>` to the `roles:` list in `playbook.yml`
3. Add any user-facing variables to `vars/main.yml`

## Verification After Install

```bash
docker run --rm hello-world          # Colima socket working
mise list                            # node, python, go, rust shown
kubectl version --client             # kubectl installed
helm version                         # helm installed
```

Open a new terminal to see the pure prompt and zsh plugins active.
