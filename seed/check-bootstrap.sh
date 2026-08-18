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

for unit in lex meta send collect async borrow utf8-pass lower emit; do
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
test -x "$work/out/borrow-example"
"$work/out/borrow-example"
test "$("$work/out/utf8-stream")" = "utf8 stream ok"

"$root/seed/compose.sh" "$work/out/lex" "$root/seed/compose.manifest" \
    "$work/compose.tokens"
"$work/out/lex" "$root/seed/compose-main.pir" > "$work/compose.expected"
"$work/out/lex" "$root/seed/compose-library.pir" >> "$work/compose.expected"
cmp "$work/compose.expected" "$work/compose.tokens"
test "$("$work/out/meta" 3< "$work/compose.tokens" < \
    "$root/seed/atoms.manifest")" = send
"$root/seed/run-atoms.sh" "$work/out/meta" "$root/seed/atoms.manifest" \
    "$work/out" "$work/compose.tokens" "$work/compose.planned"
"$work/out/lower" < "$work/compose.planned" |
    "$work/out/emit" > "$work/compose.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" \
    "$work/compose.s" -o "$work/compose"
"$work/compose"

for manifest in compose-invalid-budget compose-invalid-duplicate \
    compose-invalid-root; do
    printf '%s\n' sentinel > "$work/rejected.tokens"
    set +e
    error=$("$root/seed/compose.sh" "$work/out/lex" \
        "$root/seed/$manifest.manifest" "$work/rejected.tokens" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    test "$error" = "plang0: source manifest rejected"
    test "$(cat "$work/rejected.tokens")" = sentinel
done

for fixture in utf8-helper-collision utf8-helper-missing-channel; do
    "$work/out/lex" "$root/seed/$fixture.pir" |
        "$work/out/utf8-pass" |
        "$work/out/lower" |
        "$work/out/emit" > "$work/$fixture.s"

    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" \
        "$work/$fixture.s" -o "$work/$fixture" 2>&1)
    status=$?
    set -e

    test "$status" -ne 0
    case "$fixture:$error" in
        utf8-helper-collision:*_pir___utf8_stream_recv*) ;;
        utf8-helper-missing-channel:*_pir_channel_recv__arity_2*) ;;
        *)
            printf '%s\n' "unexpected $fixture diagnostic: $error" >&2
            exit 1
            ;;
    esac
done
