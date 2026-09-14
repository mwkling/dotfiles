# Git worktree helpers
#
#   wtn <branch>   create a worktree for a new branch based on origin/main
#                  at ~/workspace/worktrees/<repo>__<normalized-branch>
#   wtx            from inside a worktree: cd back to the primary repo and
#                  force-remove the worktree (branch is left intact)

WORKTREES_DIR="${WORKTREES_DIR:-$HOME/workspace/worktrees}"

# Print the root of the primary (non-worktree) checkout for the current repo.
_wt_primary_root() {
  local common
  common="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 1
  # common dir is <primary>/.git for a normal repo
  dirname "$common"
}

wtn() {
  if [ -z "$1" ]; then
    echo "usage: wtn <branch>" >&2
    return 1
  fi

  local branch="$1" primary repo normalized target
  primary="$(_wt_primary_root)" || { echo "wtn: not inside a git repo" >&2; return 1; }
  repo="$(basename "$primary")"
  normalized="$(printf '%s' "$branch" | sed -E 's#[^A-Za-z0-9._-]+#-#g')"
  target="$WORKTREES_DIR/${repo}__${normalized}"

  if [ -e "$target" ]; then
    echo "wtn: $target already exists" >&2
    return 1
  fi

  mkdir -p "$WORKTREES_DIR" || return 1

  echo "Fetching origin/main..."
  git -C "$primary" fetch origin main || return 1

  git -C "$primary" worktree add -b "$branch" "$target" origin/main || return 1

  cd "$target" || return 1

  if [ -f .gitmodules ]; then
    echo "Initializing submodules..."
    git submodule update --init --recursive
  fi

  echo "Worktree ready: $target"
}

wtx() {
  local here primary gitdir common
  here="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "wtx: not inside a git repo" >&2; return 1; }
  gitdir="$(git rev-parse --path-format=absolute --git-dir)"
  common="$(git rev-parse --path-format=absolute --git-common-dir)"

  if [ "$gitdir" = "$common" ]; then
    echo "wtx: this is the primary checkout, not a worktree; refusing" >&2
    return 1
  fi

  primary="$(dirname "$common")"

  cd "$primary" || return 1
  git worktree remove --force "$here" || return 1
  echo "Removed worktree: $here"
  echo "Now in: $primary"
}
