#!/usr/bin/env bash
set -euo pipefail

#Directories and stuff
PROJECT_ROOT="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
CONFIG_ROOT="$PROJECT_ROOT/configs"

TEST="/Documents/TEST"

QS_SRC="$CONFIG_ROOT/quickshell"
HYPR_SRC="$CONFIG_ROOT/hyprland"

QS_DST="$HOME/.config/quickshell/ii"
HYPR_DST="$HOME/.config/hypr/hyprland"

BACKUP_ROOT="$HOME/plug-backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$BACKUP_ROOT/$TIMESTAMP"

REQUIRES=(
  cp
  rsync
  mkdir
  hyprland
  hyprctl
  quickshell
  fc-list
)

#Utilities
die() {
  echo "[] $1"
  exit 1
}

info() {
  echo "[] $1"
}

warn() {
  echo "[!] $1"
}

ok() {
  echo "[] $1"
}

confirm() {
  read -rp "$1 [y/N]: " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

check() {
  info "Checking prerequisites..."
  for cmd in "${REQUIRES[@]}"; do
    command -v "$cmd" &>/dev/null || die "You seem to be missing some required command(s): $cmd"
  done

  if ! fc-list | grep -qi "Nerd Font"; then
    warn "Didn't find any NerdFonts, highly recommended that you install one! As some icons rely on it."
  fi
}

banner() {
  cat <<'EOF'
                                                               
                             █                               █ 
 ▄▄▄▄   ▄   ▄  ▄ ▄▄    ▄▄▄   █ ▄▄    ▄▄▄    ▄▄▄    ▄ ▄▄   ▄▄▄█ 
 █▀ ▀█  █   █  █▀  █  █▀  ▀  █▀  █  █▀  ▀  ▀   █   █▀  ▀ █▀ ▀█ 
 █   █  █   █  █   █  █      █   █  █      ▄▀▀▀█   █     █   █ 
 ██▄█▀  ▀▄▄▀█  █   █  ▀█▄▄▀  █   █  ▀█▄▄▀  ▀▄▄▀█   █     ▀█▄██ 
 █                                                             
 ▀ 
Thing that copies my End-4/illogical-impulse tweaks to yours..
https://github.com/stormy-soul/punchcard                  v1.0

EOF
}

#Main
backup_and_patch() {
  local src="$1"
  local dst="$2"
  local name="$3"

  [[ -d "$src" ]] || {
    info "No $name config found, skipping it!"
    return
  }

  echo "" && info "Gonna patch $name..."
  mkdir -p "$dst"

  while IFS= read -r -d '' file; do
    rel="${file#$src/}"
    target="$dst/$rel"
    backup="$BACKUP/$name/$rel"

    mkdir -p "$(dirname "$backup")"
    mkdir -p "$(dirname "$target")"

    if [[ -f "$target" ]]; then
      cp -a "$target" "$backup"
      info "Backed up $target."
    fi

    cp -a "$file" "$target"
    ok "Patched $target!"
  done < <(find "$src" -type f -print0)
}

restore_dir() {
  local name="$1"
  local backup_src="$BACKUP_ROOT/latest/$name"
  local dst="$2"

  [[ -d "$backup_src" ]] || die "Couldn't find a backup for $name!"

  info "Trying to restore $name..."
  rsync -a --delete "$backup_src/" "$dst/"
  ok "$name was restored!"
}

#Commands
apply() {
  banner
  check

  info "This will patch:"
  [[ -d "$QS_SRC" ]] && echo "   Quickshell"
  [[ -d "$HYPR_SRC" ]] && echo "   Hyprland (Only general.conf & rules.conf :D)"

  echo "" && confirm "Continue?" || exit 0

  mkdir -p "$BACKUP"

  backup_and_patch "$QS_SRC" "$QS_DST" "quickshell"
  backup_and_patch "$HYPR_SRC" "$HYPR_DST" "hypr"

  mkdir -p "$BACKUP_ROOT"
  rm -f "$BACKUP_ROOT/latest"
  ln -s "$BACKUP" "$BACKUP_ROOT/latest"

  echo "" && ok "Patch complete!!"
  echo "   Backup saved to $BACKUP"
  echo "  󰁯 Restore it anytime with './patcher.sh restore'"
}

restore() {
  banner
  check

  restore_dir "quickshell" "$QS_DST"
  restore_dir "hypr" "$HYPR_DST"

  echo "" && ok "Restore complete!!"
}

help() {
  cat <<'EOF'
Usage: ./patcher.sh <command>

Commands:
  apply     Backup and apply configs(Only what's needed)
  restore   Restore last backup
  help      Show this help message

Notes:
- Don't worry about backing up, as this'll backup whatever it touches.
- You can find the backups in ~/plug-backup
- Hyprland will be patched too (only the windowrules and general configs)
- If the script errors, you can just copy the configs yourself too :D
EOF
}

#Entry
case "${1:-help}" in
apply) apply ;;
restore) restore ;;
help | --help | -h) help ;;
*) die "'$1' is an unknown command!" ;;
esac
