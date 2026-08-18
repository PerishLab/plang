#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

if grep -E 'python(3)?' "$root/seed/bootstrap.sh"; then
    printf '%s\n' 'bootstrap path must not reference Python' >&2
    exit 1
fi

sh "$root/seed/bootstrap.sh" "$work/out"

for unit in lex meta send collect async utf8-pass lower emit; do
    test -x "$work/out/$unit"
    test -s "$work/out/assembly/$unit.s"
done

for unit in lex lower emit; do
    cmp "$root/seed/bootstrap/arm64-darwin/$unit.s" \
        "$work/out/assembly/$unit.s"
done

test "$("$work/out/hello")" = "hello, plang"
test "$("$work/out/await")" = "ABCawait ok
ABCcollect ok"
test "$("$work/out/utf8-stream")" = "utf8 stream ok"
