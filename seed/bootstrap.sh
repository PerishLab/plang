#!/bin/sh
set -eu
set -o pipefail

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
output=${1-"$root/build/bootstrap"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

seed="$root/seed/bootstrap/arm64-darwin"
runtime="$root/seed/arm64-darwin.s"
units="lex meta send collect async utf8-pass lower emit"

cd "$root"
shasum -a 256 -c "$seed/SHA256SUMS"

for unit in lex lower emit; do
    /usr/bin/clang -arch arm64 "$runtime" "$seed/$unit.s" -o "$work/$unit.0"
done

for unit in $units; do
    "$work/lex.0" "$root/seed/$unit.pir" |
        "$work/lower.0" |
        "$work/emit.0" > "$work/$unit.1.s"
    /usr/bin/clang -arch arm64 "$runtime" "$work/$unit.1.s" -o "$work/$unit.1"
done

for unit in $units; do
    "$work/lex.1" "$root/seed/$unit.pir" |
        "$work/lower.1" |
        "$work/emit.1" > "$work/$unit.2.s"
    cmp "$work/$unit.1.s" "$work/$unit.2.s"
done

"$work/lex.1" "$root/seed/hello.pir" |
    "$work/lower.1" |
    "$work/emit.1" > "$work/hello.s"
/usr/bin/clang -arch arm64 "$runtime" "$work/hello.s" -o "$work/hello"
test "$("$work/hello")" = "hello, plang"

"$work/lex.1" "$root/seed/await.pir" > "$work/await.source.tokens"
"$root/seed/run-atoms.sh" "$work/meta.1" "$root/seed/atoms.manifest" \
    "$work" "$work/await.source.tokens" "$work/await.tokens" .1
"$work/lower.1" < "$work/await.tokens" |
    "$work/emit.1" > "$work/await.s"
/usr/bin/clang -arch arm64 "$runtime" "$work/await.s" -o "$work/await"
test "$("$work/await")" = "ABCawait ok
ABCcollect ok"

"$work/lex.1" "$root/seed/utf8-stream-atom.pir" > "$work/utf8.source.tokens"
"$root/seed/run-atoms.sh" "$work/meta.1" "$root/seed/atoms-with-utf8.manifest" \
    "$work" "$work/utf8.source.tokens" "$work/utf8.tokens" .1
"$work/lower.1" < "$work/utf8.tokens" |
    "$work/emit.1" > "$work/utf8.s"
/usr/bin/clang -arch arm64 "$runtime" "$work/utf8.s" -o "$work/utf8"
test "$("$work/utf8")" = "utf8 stream ok"

mkdir -p "$output/assembly"
for unit in $units; do
    cp "$work/$unit.1" "$output/$unit"
    cp "$work/$unit.1.s" "$output/assembly/$unit.s"
done
cp "$work/hello" "$output/hello"
cp "$work/await" "$output/await"
cp "$work/utf8" "$output/utf8-stream"

printf '%s\n' "bootstrap ok: $output"
