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
python3 "$root/seed/boot.py" "$root/seed/lower.pir" "$work/lower.s"
python3 "$root/seed/boot.py" "$root/seed/emit.pir" "$work/emit.s"

/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.s" -o "$work/hello"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/exhaust.s" -o "$work/exhaust"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/overflow.s" -o "$work/overflow"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/scan.s" -o "$work/scan"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lex.s" -o "$work/lex"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/decode.s" -o "$work/decode"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lower.s" -o "$work/lower"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.s" -o "$work/emit"

hello=$($work/hello)
test "$hello" = "hello, plang"

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

$work/lex "$root/seed/emit.pir" | $work/lower | $work/emit > "$work/emit.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.self.s" -o "$work/emit.self"

$work/lex "$root/seed/lower.pir" | $work/lower.self | $work/emit.self > "$work/lower.fixed.s"
cmp "$work/lower.self.s" "$work/lower.fixed.s"
$work/lex "$root/seed/emit.pir" | $work/lower.self | $work/emit.self > "$work/emit.fixed.s"
cmp "$work/emit.self.s" "$work/emit.fixed.s"

$work/lex "$root/seed/hello.pir" | $work/lower.self | $work/emit.self > "$work/hello.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.fixed.s" -o "$work/hello.fixed"
test "$($work/hello.fixed)" = "hello, plang"
