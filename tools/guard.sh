#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

fail=0
say() { printf '%s\n' "$1" >&2; fail=1; }

# Rule 1: the bootstrap host lives in boot/ and nowhere else.
stray=$(git ls-files -- '*.py' | grep -v '^boot/' || true)
if [ -n "$stray" ]; then
    say "host language outside boot/:"
    printf '%s\n' "$stray" >&2
fi

# Rule 2: nothing outside boot/ may reference the host language.
refs=$(git ls-files -- ':!boot/' ':!tools/guard.sh' \
       | xargs -r grep -l -E 'python|\.py\b' 2>/dev/null || true)
if [ -n "$refs" ]; then
    say "reference to the host language outside boot/:"
    printf '%s\n' "$refs" >&2
fi

# Rule 3: once the language hosts itself, boot/ must be gone.
if [ -f .selfhosted ]; then
    if [ -n "$(git ls-files -- 'boot/')" ]; then
        say "self-hosting is declared but boot/ still has files"
    fi
fi

if [ "$fail" -eq 0 ]; then
    printf 'guard: clean\n'
fi
exit "$fail"
