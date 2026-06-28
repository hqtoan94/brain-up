#!/usr/bin/env bash
# Bring a brain repository "up" on this machine.
# Single entrypoint with two modes:
#   - sync mode (default): clone/pull/link rules for an existing brain repo.
#   - init mode (--init): scaffold a new standalone brain repo from templates/, then link rules.
#
set -euo pipefail

MODE="sync"
INIT_TYPE=""
INIT_TARGET=""
INIT_NAME=""
INIT_GIT=false
INIT_FORCE=false

# Directory containing this script (and the templates/ folder next to it).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
TEMPLATES_DIR="${TEMPLATES_DIR:-${SCRIPT_DIR}/templates}"

BRAIN="${BRAIN:-$HOME/second-brain}"
BRAIN_REPO="${BRAIN_REPO:-}"
RULES_DIR="${RULES_DIR:-$BRAIN/.claude/rules}"
TARGETS="${TARGETS:-claude,cursor}"

usage() {
  cat <<'EOF'
Usage:
  # Sync mode (default): clone (if needed), pull, link rules
  up.sh

  # Init mode: scaffold a new standalone brain repo, then link rules
  up.sh --init --type <personal|company> --target <path> [--name <name>] [--git-init] [--force]

Env vars (sync mode):
  BRAIN       default: ~/second-brain
  BRAIN_REPO  clone URL used when BRAIN does not exist
  RULES_DIR   default: $BRAIN/.claude/rules
  TARGETS     default: claude,cursor (supported: claude,cursor)

Env vars (init mode):
  TEMPLATES_DIR  default: <script dir>/templates
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --init)
      MODE="init"
      shift
      ;;
    --type)
      INIT_TYPE="${2:-}"
      shift 2
      ;;
    --target)
      INIT_TARGET="${2:-}"
      shift 2
      ;;
    --name)
      INIT_NAME="${2:-}"
      shift 2
      ;;
    --git-init)
      INIT_GIT=true
      shift
      ;;
    --force)
      INIT_FORCE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

has_target() {
  local needle="$1"
  local csv="$2"
  [[ ",$csv," == *",$needle,"* ]]
}

print_clone_help() {
  cat >&2 <<EOF
error: clone failed.
  check access to BRAIN_REPO: $BRAIN_REPO
  override example:
    BRAIN_REPO=https://github.com/<your-username>/<repo>.git $0
EOF
}

# Copy a template tree's contents (including dotfiles) into the target dir.
copy_template() {
  local src="$1"
  local dst="$2"
  [[ -d "$src" ]] || return 0
  # The trailing /. copies the directory contents, hidden files included.
  cp -R "$src/." "$dst/"
}

# Replace {{NAME}} and {{DATE}} placeholders across every file under the target.
substitute_placeholders() {
  local root="$1"
  local name="$2"
  local today="$3"
  local f
  while IFS= read -r -d '' f; do
    sed -e "s|{{NAME}}|${name}|g" -e "s|{{DATE}}|${today}|g" "$f" > "$f.brainup.tmp"
    mv "$f.brainup.tmp" "$f"
  done < <(find "$root" -type f -print0)
}

link_rules() {
  local src_rules="$1"
  if [[ ! -d "$src_rules" ]]; then
    echo "error: rules directory not found: $src_rules" >&2
    exit 1
  fi

  local roots=()
  if has_target "claude" "$TARGETS"; then
    roots+=( "$HOME/.claude" )
  fi
  if has_target "cursor" "$TARGETS" && [[ -d "$HOME/.cursor" ]]; then
    roots+=( "$HOME/.cursor" )
  fi

  if [[ ${#roots[@]} -eq 0 ]]; then
    echo
    echo "No target app config directories detected. Nothing to link."
    return 0
  fi

  echo
  echo "Targets:"
  for root in "${roots[@]}"; do
    echo "  $root/"
  done

  local linked=0 ok=0 replaced=0 skipped=0
  for root in "${roots[@]}"; do
    echo
    echo "Linking -> $root/rules/"
    mkdir -p "$root/rules"
    shopt -s nullglob
    for src in "$src_rules"/*; do
      [[ -f "$src" || -L "$src" ]] || continue
      dst="$root/rules/$(basename "$src")"
      if [[ -L "$dst" ]]; then
        cur="$(readlink "$dst")"
        if [[ "$cur" == "$src" ]]; then
          echo "  ok       $dst"
          ok=$((ok + 1))
        else
          echo "  replace  $dst (was -> $cur)"
          rm "$dst"
          ln -s "$src" "$dst"
          replaced=$((replaced + 1))
        fi
      elif [[ -e "$dst" ]]; then
        echo "  SKIP     $dst (real file at destination - refusing to overwrite)" >&2
        skipped=$((skipped + 1))
      else
        ln -s "$src" "$dst"
        echo "  link     $dst -> $src"
        linked=$((linked + 1))
      fi
    done
    shopt -u nullglob
  done

  echo
  echo "Summary"
  echo "  $linked newly linked"
  echo "  $ok already up-to-date"
  echo "  $replaced replaced (stale symlink fixed)"
  echo "  $skipped skipped (real file at destination)"

  if (( skipped > 0 )); then
    echo
    echo "Some destinations were real files. Inspect and re-run." >&2
    exit 1
  fi
}

run_init_mode() {
  if [[ -z "$INIT_TYPE" ]]; then
    echo "error: --type is required in --init mode." >&2
    usage
    exit 1
  fi
  if [[ "$INIT_TYPE" != "personal" && "$INIT_TYPE" != "company" ]]; then
    echo "error: --type must be personal or company." >&2
    exit 1
  fi

  if [[ ! -d "$TEMPLATES_DIR/common" || ! -d "$TEMPLATES_DIR/$INIT_TYPE" ]]; then
    cat >&2 <<EOF
error: templates not found at: $TEMPLATES_DIR
  init mode needs the templates/ folder shipped with brain-up.
  clone the repo first, e.g.:
    git clone https://github.com/hqtoan94/brain-up.git
    ./brain-up/up.sh --init --type $INIT_TYPE --target <path>
EOF
    exit 1
  fi

  local target="${INIT_TARGET:-$BRAIN}"
  target="${target/#\~/$HOME}"
  local name="${INIT_NAME:-$(basename "$target")}"
  local today
  today="$(date +%F)"

  if [[ -e "$target" ]]; then
    if [[ ! -d "$target" ]]; then
      echo "error: target exists and is not a directory: $target" >&2
      exit 1
    fi
    if [[ "$INIT_FORCE" != "true" ]] && [[ -n "$(ls -A "$target")" ]]; then
      echo "error: target directory is not empty: $target" >&2
      echo "       re-run with --force to continue." >&2
      exit 1
    fi
  else
    mkdir -p "$target"
  fi

  echo "Init"
  echo "  type:     $INIT_TYPE"
  echo "  target:   $target"
  echo "  name:     $name"

  # Common layout first, then the type-specific overlay on top.
  copy_template "$TEMPLATES_DIR/common" "$target"
  copy_template "$TEMPLATES_DIR/$INIT_TYPE" "$target"
  substitute_placeholders "$target" "$name" "$today"

  if [[ "$INIT_GIT" == "true" ]]; then
    (
      cd "$target"
      [[ -d ".git" ]] || git init >/dev/null
    )
    echo "  git:      initialized"
  fi

  echo "Initialized $INIT_TYPE brain at: $target"

  BRAIN="$target"
  RULES_DIR="$BRAIN/.claude/rules"
  link_rules "$RULES_DIR"
}

run_sync_mode() {
  if [[ -d "$BRAIN" ]]; then
    :
  elif [[ -z "$BRAIN_REPO" ]]; then
    cat >&2 <<EOF
error: brain does not exist at $BRAIN and BRAIN_REPO is empty.
  provide BRAIN_REPO so this script can clone on first run, for example:
    BRAIN_REPO=https://github.com/<your-username>/<repo>.git $0
  or scaffold a new brain:
    $0 --init --type personal --target $BRAIN
EOF
    exit 1
  fi

  # 1) Bootstrap
  local just_cloned=false
  if [[ ! -d "$BRAIN" ]]; then
    echo "Bootstrap"
    echo "  brain not found at $BRAIN"
    echo "  cloning from $BRAIN_REPO ..."
    if ! git clone "$BRAIN_REPO" "$BRAIN"; then
      print_clone_help
      exit 1
    fi
    just_cloned=true
    echo
  fi

  echo "Brain:   $BRAIN"

  # 2) Pull
  echo
  echo "Pull"
  cd "$BRAIN"
  if [[ "$just_cloned" == "true" ]]; then
    echo "  freshly cloned; skipping pull."
  elif [[ ! -d "$BRAIN/.git" ]]; then
    echo "  not a git repo; skipping."
  elif ! git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    echo "  no upstream configured; skipping."
  elif [[ -n "$(git status --porcelain)" ]]; then
    echo "  working tree has local changes; skipping (commit/stash first)."
    git status --short | sed 's/^/    /'
  else
    old="$(git rev-parse HEAD)"
    if git pull --ff-only --quiet; then
      new="$(git rev-parse HEAD)"
      if [[ "$old" == "$new" ]]; then
        echo "  already up to date with $(git rev-parse --abbrev-ref '@{u}')."
      else
        echo "  pulled $(git rev-list --count "$old".."$new") commit(s):"
        git log --oneline "$old".."$new" | sed 's/^/    /'
      fi
    else
      echo "  git pull --ff-only failed (diverged?); resolve and re-run." >&2
    fi
  fi

  # 3) Link rules
  link_rules "$RULES_DIR"
}

if [[ "$MODE" == "init" ]]; then
  run_init_mode
else
  run_sync_mode
fi
