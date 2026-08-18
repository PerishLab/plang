#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

python3 "$root/seed/boot.py" "$root/seed/hello.pir" "$work/hello.s"
python3 "$root/seed/boot.py" "$root/seed/exhaust.pir" "$work/exhaust.s"
python3 "$root/seed/boot.py" "$root/seed/overflow.pir" "$work/overflow.s"
python3 "$root/seed/boot.py" "$root/seed/scan.pir" "$work/scan.s"
python3 "$root/seed/boot.py" "$root/seed/lex.pir" "$work/lex.s"
python3 "$root/seed/boot.py" "$root/seed/decode.pir" "$work/decode.s"
python3 "$root/seed/boot.py" "$root/seed/async.pir" "$work/async.s"
python3 "$root/seed/boot.py" "$root/seed/lower.pir" "$work/lower.s"
python3 "$root/seed/boot.py" "$root/seed/emit.pir" "$work/emit.s"
python3 "$root/seed/boot.py" "$root/seed/channel.pir" "$work/channel.s"

/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.s" -o "$work/hello"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/exhaust.s" -o "$work/exhaust"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/overflow.s" -o "$work/overflow"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/scan.s" -o "$work/scan"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lex.s" -o "$work/lex"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/decode.s" -o "$work/decode"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async.s" -o "$work/async"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lower.s" -o "$work/lower"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.s" -o "$work/emit"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/channel.s" -o "$work/channel"

$work/lex "$root/seed/await.pir" | $work/async | $work/lower | $work/emit > "$work/await.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/await.s" -o "$work/await"

hello=$($work/hello)
test "$hello" = "hello, plang"
test "$($work/channel)" = "channel ok"
test "$($work/await)" = "ABCawait ok"

$work/lex "$root/seed/async-max.pir" | $work/async > "$work/async-max.tokens"
test "$(wc -l < "$work/async-max.tokens")" -eq 399
test "$(grep -c '^__async_state_7$' "$work/async-max.tokens")" = 2
test "$(grep -c '^__async_waiting_7$' "$work/async-max.tokens")" = 2

$work/lex "$root/seed/hello.pir" > "$work/async-identity.tokens"
$work/async < "$work/async-identity.tokens" > "$work/async-identity.out"
cmp "$work/async-identity.tokens" "$work/async-identity.out"

$work/lex "$root/seed/await.pir" | $work/async > "$work/async-once.tokens"
$work/async < "$work/async-once.tokens" > "$work/async-twice.tokens"
cmp "$work/async-once.tokens" "$work/async-twice.tokens"

$work/lex "$root/seed/async-frames.pir" | $work/async > "$work/async-frames.tokens"
test "$(grep -c '^__async_state_0$' "$work/async-frames.tokens")" = 4
test "$(grep -c '^__async_waiting_0$' "$work/async-frames.tokens")" = 4
! grep -q '^__async_waiting_1$' "$work/async-frames.tokens"
$work/lower < "$work/async-frames.tokens" | $work/emit > "$work/async-frames.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async-frames.s" -o "$work/async-frames"
$work/async-frames

for source in "$root"/seed/async-invalid-*.pir; do
    set +e
    $work/lex "$source" | $work/async > "$work/async-invalid.tokens" 2> "$work/async-invalid.error"
    status=$?
    set -e

    test "$status" = 1
    test "$(cat "$work/async-invalid.error")" = "plang0: async lowering rejected token stream"
done

set +e
error=$($work/exhaust 2>&1)
status=$?
set -e

test "$status" = 1
test "$error" = "plang: memory limit"

set +e
error=$($work/overflow 2>&1)
status=$?
set -e

test "$status" = 1
test "$error" = "plang: memory limit"

scan=$($work/scan "$root/seed/hello.pir")
test "$scan" = "scan ok"

set +e
error=$($work/scan "$root/seed/nonascii.txt" 2>&1)
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: invalid source byte"

$work/lex "$root/seed/hello.pir" > "$work/hello.tokens"
cmp "$root/seed/hello.tokens" "$work/hello.tokens"

$work/lex "$root/seed/lex.pir" > "$work/lex.tokens.1"
$work/lex "$work/lex.tokens.1" > "$work/lex.tokens.2"
cmp "$work/lex.tokens.1" "$work/lex.tokens.2"

set +e
error=$($work/lex "$root/seed/unterminated.txt" 2>&1 > "$work/unterminated.tokens")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: unterminated string"
test "$(sed -n '1p' "$work/unterminated.tokens")" = "bytes"

$work/lex "$root/seed/decode.pir" | $work/decode > "$work/decode.out"
test "$(sed -n '1p' "$work/decode.out")" = "decode ok"
$work/lex "$root/seed/await.pir" | $work/async | $work/decode > "$work/await.decode.out"
test "$(sed -n '1p' "$work/await.decode.out")" = "decode ok"

set +e
error=$($work/decode < "$root/seed/invalid.tokens" 2>&1)
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: invalid token stream"

$work/lex "$root/seed/hello.pir" | $work/lower | $work/emit > "$work/hello.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.self.s" -o "$work/hello.self"
test "$($work/hello.self)" = "hello, plang"

set +e
error=$($work/lower < "$root/seed/invalid.tokens" 2>&1 > "$work/invalid.lower.tokens")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: lowering rejected token stream"

$work/lex "$root/seed/lower.pir" | $work/lower | $work/emit > "$work/lower.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lower.self.s" -o "$work/lower.self"

$work/lex "$root/seed/async.pir" | $work/lower | $work/emit > "$work/async.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async.self.s" -o "$work/async.self"

$work/lex "$root/seed/emit.pir" | $work/lower | $work/emit > "$work/emit.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.self.s" -o "$work/emit.self"

$work/lex "$root/seed/lower.pir" | $work/lower.self | $work/emit.self > "$work/lower.fixed.s"
cmp "$work/lower.self.s" "$work/lower.fixed.s"
$work/lex "$root/seed/async.pir" | $work/lower.self | $work/emit.self > "$work/async.fixed.s"
cmp "$work/async.self.s" "$work/async.fixed.s"
$work/lex "$root/seed/emit.pir" | $work/lower.self | $work/emit.self > "$work/emit.fixed.s"
cmp "$work/emit.self.s" "$work/emit.fixed.s"

$work/lex "$root/seed/hello.pir" | $work/lower.self | $work/emit.self > "$work/hello.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.fixed.s" -o "$work/hello.fixed"
test "$($work/hello.fixed)" = "hello, plang"

$work/lex "$root/seed/channel.pir" | $work/lower.self | $work/emit.self > "$work/channel.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/channel.fixed.s" -o "$work/channel.fixed"
test "$($work/channel.fixed)" = "channel ok"

$work/lex "$root/seed/await.pir" | $work/async.self | $work/lower.self | $work/emit.self > "$work/await.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/await.fixed.s" -o "$work/await.fixed"
test "$($work/await.fixed)" = "ABCawait ok"
