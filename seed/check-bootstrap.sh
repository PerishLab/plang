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
