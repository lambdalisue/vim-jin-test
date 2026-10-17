#!/bin/sh
# Make a jj repository to try vim-jin on, the same every time.
#
#   ./setup.sh [directory]    (default: ./playground)
#
# The directory holds:
#   repo/        the repository to open in the editor
#   second/      a second workspace of it
#   remote.git/  the remote it pushes to, as `origin`
set -eu

dir=${1:-playground}
if [ -e "$dir" ]; then
  echo "setup.sh: $dir exists; remove it, or name another directory" >&2
  exit 1
fi
command -v jj >/dev/null || {
  echo "setup.sh: jj is not on PATH" >&2
  exit 1
}

# Nothing of the user's own jj configuration takes part, so that the
# repository comes out the same for everyone.
export JJ_CONFIG=/dev/null
export JJ_USER="vim-jin tutorial"
export JJ_EMAIL="tutorial@example.com"
export JJ_TIMESTAMP="2026-01-01T00:00:00+00:00"

# Change IDs come from a seed jj takes per command; a new one each time
# gives the same IDs in every repository made, so that the tutorial can name
# them.
seed=0
jj() {
  seed=$((seed + 1))
  JJ_RANDOMNESS_SEED=$seed command jj "$@"
}

mkdir -p "$dir"
cd "$dir"
git init -q --bare remote.git
jj git init --colocate repo >/dev/null 2>&1
cd repo
jj git remote add origin ../remote.git

write() {
  printf '%s\n' "$2" >"$1"
}

# --- main: pushed, and so immutable -----------------------------------------
write hello.py 'def hello(name):
    return f"Hello, {name}"'
jj describe --quiet -m "feat: add hello module"
jj new --quiet
write README.md '# greeter

A tiny module to try vim-jin on.'
jj describe --quiet -m "docs: add a README"
jj new --quiet
jj bookmark create --quiet main -r @-
jj git push --quiet --bookmark main 2>/dev/null

# --- a line of changes on top of main ---------------------------------------
write hello.py 'def hello(name):
    return f"Hello, {name}"


def shout(name):
    return hello(name).upper() + "!"'
jj describe --quiet -m "feat: greet loudly"
jj new --quiet
write NOTES.md '# Notes

- Greetings should stay short.'
jj describe --quiet -m "docs: add notes about greetings"
jj new --quiet
write hello.py 'def hello(name):
    return f"Hello, {name}"


def shout(name):
    return hello(name).upper() + "!"


def bye(name):
    return f"Bye, {name}"'
# Described again and again: the evolog has versions to compare.
jj describe --quiet -m "feat: say good bye"
jj describe --quiet -m "feat: say goodbye"
write hello.py 'def hello(name):
    return f"Hello, {name}"


def shout(name):
    return hello(name).upper() + "!"


def goodbye(name):
    return f"Goodbye, {name}"'
jj describe --quiet -m "feat: say goodbye to a name"
jj bookmark create --quiet topic -r @
stack=$(jj log --no-graph -r @ -T change_id)

# --- two greetings in other languages, and a merge of them in conflict ------
jj new --quiet main
write hello.py 'def hello(name):
    return f"Bonjour, {name}"'
jj describe --quiet -m "feat: greet in French"
french=$(jj log --no-graph -r @ -T change_id)
jj new --quiet main
write hello.py 'def hello(name):
    return f"Konnichiwa, {name}"'
jj describe --quiet -m "feat: greet in Japanese"
japanese=$(jj log --no-graph -r @ -T change_id)
jj new --quiet -m "merge: both greetings" "$french" "$japanese"

# --- a second workspace, working on main ------------------------------------
jj workspace add --quiet --name second -r main ../second

# --- the working copy: a change in progress on the line ---------------------
jj new --quiet "$stack"
write hello.py 'def hello(name):
    return f"Hello, {name}"


def shout(name):
    return hello(name).upper() + "!"


def goodbye(name):
    return f"Goodbye, {name}"


def ask(name):
    return f"How are you, {name}?"'
write TODO.md '- greet in more languages'

# Taken into the working copy now, at the fixed time, not on the first jj
# command the user runs.
jj status >/dev/null

echo "setup.sh: made $(pwd)"
echo "setup.sh: open it with:  cd $(pwd) && vim +JinLog"
