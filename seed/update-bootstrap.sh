#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
if test "${1-}" != "--apply"; then
    printf '%s\n' 'usage: sh seed/update-bootstrap.sh --apply' >&2
    exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
target="$root/seed/bootstrap/arm64-darwin"

sh "$root/seed/bootstrap.sh" "$work/out"
for unit in lex lower emit; do
    cp "$work/out/assembly/$unit.s" "$target/$unit.s"
done

cd "$root"
shasum -a 256 \
    seed/bootstrap/arm64-darwin/lex.s \
    seed/bootstrap/arm64-darwin/lower.s \
    seed/bootstrap/arm64-darwin/emit.s \
    seed/arm64-darwin.s > "$target/SHA256SUMS"
shasum -a 256 seed/lex.pir seed/lower.pir seed/emit.pir > "$target/SOURCE-SHA256"

printf '%s\n' 'bootstrap seed updated; review the assembly diff and rerun check-bootstrap.sh'
