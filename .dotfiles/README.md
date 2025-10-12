# Dotfiles & Development Environment Bootstrap

Automated setup for macOS development environment with dotfiles management using bare Git repository.

## Features

- **Parallel package installation** via Homebrew (4 concurrent installs)
- **Bare repository dotfiles** management (no symlinks needed)
- **Idempotent** - safe to re-run
- **Modular** - install packages or dotfiles separately
- **Error recovery** - logs failed packages, continues installation

## Prerequisites

- macOS (Ubuntu/Arch/Alpine support coming)
- `curl` or `git` for initial clone
- Internet connection

## Quick Start

### One-line install (directly from GitHub)

```bash
curl -fsSL https://raw.githubusercontent.com/<<GITHUB_USERNAME>>/dotfiles/main/bootstrap.sh | bash
```

### Or clone first

```bash
git clone https://github.com/<<GITHUB_USERNAME>>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## Usage

```bash
# Full setup (packages + dotfiles)
./bootstrap.sh

# Install packages only
./bootstrap.sh --packages-only

# Setup dotfiles only
./bootstrap.sh --dotfiles-only

# Force reinstall everything
./bootstrap.sh --force

# Help
./bootstrap.sh --help
```

## Repository Structure

```
dotfiles/
├── bootstrap.sh              # Main entry point
├── install/
│   ├── detect.sh            # OS detection
│   ├── common.sh            # Shared functions
│   └── macos.sh             # Homebrew installer
├── packages.txt             # Package declarations
├── dotfiles-list.txt        # Reference: files to track
└── README.md
```

## Package Management

### Adding Packages

Edit `packages.txt`:

```
# Format: package_name|brew_formula|category
neovim|neovim|development
<<package-name>>|--cask docker|development
```

**Categories:** `essential`, `development`, `optional`

**For casks:** Prefix with `--cask `

### Package File Format

```
package_name|brew_formula|category
```

- **Column 1:** Human-readable name (for reference)
- **Column 2:** Homebrew formula/cask name
- **Column 3:** Category (used for filtering)

## Dotfiles Management

This setup uses the **bare repository method** - superior to submodules for dotfiles.

### Initial Setup (Automated)

The bootstrap script automatically:

1. Clones your dotfiles as bare repo to `~/.dotfiles/`
2. Backs up existing configs to `~/.dotfiles-backup/`
3. Checks out your dotfiles to `$HOME`

### Manual Management

Add this alias to your shell config:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### Common Operations

```bash
# Check status
config status

# Add new config file
config add ~/.zshrc

# Commit changes
config commit -m "Update zshrc"

# Push to remote
config push

# Pull latest changes
config pull

# View history
config log

# See differences
config diff
```

### First-Time Repository Setup

On your first machine (before using bootstrap):

```bash
# Initialize bare repo
git init --bare $HOME/.dotfiles

# Create alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Hide untracked files
config config --local status.showUntrackedFiles no

# Add your dotfiles
config add ~/.zshrc
config add ~/.gitconfig
config add ~/.config/nvim/init.vim

# Commit and push
config commit -m "Initial dotfiles"
config remote add origin https://github.com/<<GITHUB_USERNAME>>/dotfiles.git
config push -u origin main
```

### Important: .gitignore Setup

Create `~/.gitignore` in your dotfiles repo to avoid tracking entire `$HOME`:

```bash
# Ignore everything by default
*

# Explicitly track what you want
!.gitignore
!.zshrc
!.bashrc
!.gitconfig
!.config/nvim/**
```

**Or** use `config config --local status.showUntrackedFiles no` (recommended, already done by bootstrap).

## Configuration Placeholders

Replace these in your setup:

- `<<GITHUB_REPO_URL>>` → Your dotfiles repository URL
  - Example: `https://github.com/username/dotfiles.git`
- `<<GITHUB_USERNAME>>` → Your GitHub username
- `<<CONFIG_FILE>>` → Specific config file paths
- `<<package-name>>` → Package names in comments/examples

## Advanced Usage

### Parallel Installation Tuning

Edit `install/macos.sh`:

```bash
local concurrency=4  # Increase for faster installs (use 8-16 on fast connections)
```

### Selective Installation by Category

Modify `install/macos.sh` to filter packages:

```bash
local formulas=$(parse_packages "${packages_file}" "essential")
```

### Post-Install Hooks

Create `post-install.sh` for custom setup:

```bash
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Troubleshooting

### Failed Package Installations

Check `install_failures.log`:

```bash
cat install_failures.log
```

Manually install failed packages:

```bash
brew install <package-name>
```

### Dotfiles Checkout Conflicts

Existing files are backed up to `~/.dotfiles-backup/`. To restore:

```bash
cp -r ~/.dotfiles-backup/. ~/
```

### Homebrew Not in PATH (Apple Silicon)

Add to your shell config:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Permission Issues

Ensure bootstrap script is executable:

```bash
chmod +x bootstrap.sh
```

## Testing

Test in Docker container:

```bash
# macOS simulation (limited)
docker run -it --rm -v $(pwd):/dotfiles ubuntu:latest bash
cd /dotfiles && ./bootstrap.sh
```

## Extending to Other OS

1. Create `install/<os>.sh` (e.g., `install/ubuntu.sh`)
2. Implement `install_<os>_packages()` function
3. Update `install/detect.sh` if needed
4. Add OS case in `bootstrap.sh` main function
5. Update `packages.txt` with OS-specific columns

Example for Ubuntu:

```
# packages.txt
git|git|git|essential
```

Parse with column 3 instead of 2 for Ubuntu.

## Security Notes

- **Never commit secrets** to dotfiles repo
- Use `git-crypt` for encrypted files if needed
- Exclude sensitive files:
  - `.ssh/id_*` (private keys)
  - `.aws/credentials`
  - `.npmrc` with auth tokens
  - `.netrc`

## License

MIT

## Contributing

1. Fork repository
2. Create feature branch
3. Test on clean macOS install
4. Submit pull request

## Support

- Issues: https://github.com/<<GITHUB_USERNAME>>/dotfiles/issues
- Homebrew docs: https://docs.brew.sh
- Git bare repo method: https://www.atlassian.com/git/tutorials/dotfiles
