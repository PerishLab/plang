#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

sh "$root/seed/check-opcodes.sh"

python3 "$root/seed/boot.py" "$root/seed/hello.pir" "$work/hello.s"
python3 "$root/seed/boot.py" "$root/seed/profile.pir" "$work/profile.s"
python3 "$root/seed/boot.py" "$root/seed/exhaust.pir" "$work/exhaust.s"
python3 "$root/seed/boot.py" "$root/seed/overflow.pir" "$work/overflow.s"
python3 "$root/seed/boot.py" "$root/seed/scan.pir" "$work/scan.s"
python3 "$root/seed/boot.py" "$root/seed/lex.pir" "$work/lex.s"
python3 "$root/seed/boot.py" "$root/seed/decode.pir" "$work/decode.s"
python3 "$root/seed/boot.py" "$root/seed/meta.pir" "$work/meta.s"
python3 "$root/seed/boot.py" "$root/seed/send.pir" "$work/send.s"
python3 "$root/seed/boot.py" "$root/seed/collect.pir" "$work/collect.s"
python3 "$root/seed/boot.py" "$root/seed/async.pir" "$work/async.s"
python3 "$root/seed/boot.py" "$root/seed/lower.pir" "$work/lower.s"
python3 "$root/seed/boot.py" "$root/seed/emit.pir" "$work/emit.s"
python3 "$root/seed/boot.py" "$root/seed/channel.pir" "$work/channel.s"
python3 "$root/seed/boot.py" "$root/seed/bitwise.pir" "$work/bitwise.s"
python3 "$root/seed/boot.py" "$root/seed/capability.pir" "$work/capability.s"

/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.s" -o "$work/hello"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/profile.s" -o "$work/profile"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/exhaust.s" -o "$work/exhaust"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/overflow.s" -o "$work/overflow"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/scan.s" -o "$work/scan"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lex.s" -o "$work/lex"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/decode.s" -o "$work/decode"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/meta.s" -o "$work/meta"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/send.s" -o "$work/send"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/collect.s" -o "$work/collect"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async.s" -o "$work/async"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lower.s" -o "$work/lower"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.s" -o "$work/emit"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/channel.s" -o "$work/channel"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/bitwise.s" -o "$work/bitwise"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/capability.s" -o "$work/capability"

$work/lex "$root/seed/await.pir" > "$work/await.source.tokens"
"$root/seed/run-atoms.sh" "$work/meta" "$root/seed/atoms.manifest" "$work" "$work/await.source.tokens" "$work/await.atoms.tokens"
test "$(wc -l < "$work/await.atoms.tokens")" -eq 3100
$work/lower < "$work/await.atoms.tokens" | $work/emit > "$work/await.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/await.s" -o "$work/await"

hello=$($work/hello)
test "$hello" = "hello, plang"
test "$($work/bitwise)" = "bitwise ok"
test "$($work/capability)" = "capability ok"
test "$($work/profile)" = "profile ok"
test "$($work/channel)" = "channel ok"
test "$($work/await)" = "ABCawait ok
ABCcollect ok"

$work/lex "$root/seed/async-max.pir" | $work/async > "$work/async-max.tokens"
test "$(wc -l < "$work/async-max.tokens")" -eq 399
test "$(grep -c '^__async_state_7$' "$work/async-max.tokens")" = 2
test "$(grep -c '^__async_waiting_7$' "$work/async-max.tokens")" = 2

$work/lex "$root/seed/hello.pir" > "$work/async-identity.tokens"
$work/async < "$work/async-identity.tokens" > "$work/async-identity.out"
cmp "$work/async-identity.tokens" "$work/async-identity.out"

$work/lex "$root/seed/await.pir" | $work/send | $work/collect | $work/async > "$work/async-once.tokens"
$work/async < "$work/async-once.tokens" > "$work/async-twice.tokens"
cmp "$work/async-once.tokens" "$work/async-twice.tokens"

$work/lex "$root/seed/async-frames.pir" | $work/async > "$work/async-frames.tokens"
test "$(grep -c '^__async_state_0$' "$work/async-frames.tokens")" = 4
test "$(grep -c '^__async_waiting_0$' "$work/async-frames.tokens")" = 4
! grep -q '^__async_waiting_1$' "$work/async-frames.tokens"
$work/lower < "$work/async-frames.tokens" | $work/emit > "$work/async-frames.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async-frames.s" -o "$work/async-frames"
$work/async-frames

test "$($work/meta 3< "$work/await.source.tokens" < "$root/seed/atoms.manifest")" = "send
collect
async"
test "$($work/meta 3< "$root/seed/hello.tokens" < "$root/seed/atoms-pure.manifest")" = "pure"
test "$($work/meta 3< "$root/seed/hello.tokens" < "$root/seed/atoms-runtime-overlap.manifest")" = "left
right"

set +e
error=$($work/meta 3< "$root/seed/affine-exact.tokens" < "$root/seed/atoms-aux-overflow.manifest" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: atom manifest rejected"
test "$($work/meta 3< "$root/seed/affine-exact.tokens" < "$root/seed/atoms-affine-exact.manifest")" = "async"
test "$($work/meta 3< "$root/seed/send-await.tokens" < "$root/seed/atoms-extension-exact.manifest")" = "async"

set +e
error=$($work/meta 3< "$root/seed/send-await.tokens" < "$root/seed/atoms-extension-overflow.manifest" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: atom manifest rejected"

set +e
error=$($work/meta 3< "$root/seed/affine-incomplete.tokens" < "$root/seed/atoms-affine-exact.manifest" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: atom manifest rejected"

for manifest in "$root"/seed/atoms-invalid-*.manifest; do
    set +e
    error=$($work/meta 3< "$root/seed/hello.tokens" < "$manifest" 2>&1 > "$work/meta-invalid.order")
    status=$?
    set -e

    test "$status" = 1
    test "$error" = "plang0: atom manifest rejected"
done

$work/lex "$root/seed/collect-max.pir" | $work/collect > "$work/collect-max.tokens"
test "$(wc -l < "$work/collect-max.tokens")" -eq 684
$work/collect < "$work/collect-max.tokens" > "$work/collect-max-twice.tokens"
cmp "$work/collect-max.tokens" "$work/collect-max-twice.tokens"
$work/async < "$work/collect-max.tokens" > "$work/collect-max.normal"
test "$(wc -l < "$work/collect-max.normal")" -eq 945
! grep -q '^@' "$work/collect-max.normal"

$work/lex "$root/seed/collect-order.pir" > "$work/collect-order.source"
$work/send < "$work/collect-order.source" | $work/collect | $work/async > "$work/collect-order.manual"
"$root/seed/run-atoms.sh" "$work/meta" "$root/seed/atoms.manifest" "$work" "$work/collect-order.source" "$work/collect-order.meta"
cmp "$work/collect-order.manual" "$work/collect-order.meta"
! grep -q '^@' "$work/collect-order.meta"
$work/lower < "$work/collect-order.meta" | $work/emit > "$work/collect-order.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/collect-order.s" -o "$work/collect-order"
$work/collect-order

set +e
error=$($work/lex "$root/seed/collect-order.pir" | $work/async | $work/collect | $work/lower 2>&1 > "$work/collect-order.wrong")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: lowering rejected token stream"

set +e
error=$($work/emit < "$root/seed/invalid.tokens" 2>&1 > "$work/invalid.emit.s")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: emitter rejected token stream"

for source in "$root"/seed/collect-invalid-*.pir; do
    set +e
    $work/lex "$source" | $work/collect > "$work/collect-invalid.tokens" 2> "$work/collect-invalid.error"
    status=$?
    set -e

    test "$status" = 1
    test "$(cat "$work/collect-invalid.error")" = "plang0: collect lowering rejected token stream"
done

for source in "$root"/seed/async-invalid-*.pir; do
    set +e
    $work/lex "$source" | $work/async > "$work/async-invalid.tokens" 2> "$work/async-invalid.error"
    status=$?
    set -e

    test "$status" = 1
    test "$(cat "$work/async-invalid.error")" = "plang0: async lowering rejected token stream"
done

$work/lex "$root/seed/hello.pir" > "$work/send-identity.tokens"
$work/send < "$work/send-identity.tokens" > "$work/send-identity.out"
cmp "$work/send-identity.tokens" "$work/send-identity.out"
$work/send < "$work/await.source.tokens" > "$work/send-once.tokens"
test "$(wc -l < "$work/send-once.tokens")" -eq 2658
$work/send < "$work/send-once.tokens" > "$work/send-twice.tokens"
cmp "$work/send-once.tokens" "$work/send-twice.tokens"
$work/send < "$work/await.source.tokens" | $work/async > "$work/send-async.tokens"
$work/async < "$work/await.source.tokens" | $work/send > "$work/async-send.tokens"
cmp "$work/send-async.tokens" "$work/async-send.tokens"
$work/send < "$work/await.source.tokens" | $work/collect > "$work/send-collect.tokens"
$work/collect < "$work/await.source.tokens" | $work/send > "$work/collect-send.tokens"
cmp "$work/send-collect.tokens" "$work/collect-send.tokens"

set +e
$work/lex "$root/seed/send-invalid-empty.pir" | $work/send > "$work/send-invalid.tokens" 2> "$work/send-invalid.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/send-invalid.error")" = "plang0: send lowering rejected token stream"

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
error=$($work/scan 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source path required"

set +e
error=$($work/scan "$work/missing.pir" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source open failed"

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
$work/lex "$root/seed/await.pir" | $work/send | $work/collect | $work/async | $work/decode > "$work/await.decode.out"
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

$work/lex "$root/seed/bitwise.pir" | $work/lower | $work/emit > "$work/bitwise.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/bitwise.self.s" -o "$work/bitwise.self"
test "$($work/bitwise.self)" = "bitwise ok"

$work/lex "$root/seed/capability.pir" | $work/lower | $work/emit > "$work/capability.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/capability.self.s" -o "$work/capability.self"
test "$($work/capability.self)" = "capability ok"

$work/lex "$root/seed/invalid-arg-index.pir" | $work/lower | $work/emit > "$work/invalid-arg-index.self.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-arg-index.self.s" -o "$work/invalid-arg-index.self" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "error: plang0: arg index"

$work/lex "$root/seed/invalid-call-arity.pir" | $work/lower | $work/emit > "$work/invalid-call-arity.self.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-call-arity.self.s" -o "$work/invalid-call-arity.self" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "_pir_one__arity_0"

for source in "$root"/seed/invalid-memory-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    $work/lex "$source" | $work/lower | $work/emit > "$work/$name.self.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.self.s" -o "$work/$name.self" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "error: plang0: memory"
done

for source in "$root"/seed/invalid-top-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    case "$name" in
        invalid-top-main-*) symbol=_main ;;
        invalid-top-memory-*) symbol=_plang_memory_limit ;;
    esac
    $work/lex "$source" | $work/lower | $work/emit > "$work/$name.self.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.self.s" -o "$work/$name.self" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "$symbol"
done

for source in "$root"/seed/invalid-symbol-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    case "$name" in
        invalid-symbol-data-*) symbol=L_data_ ;;
        invalid-symbol-function-*) symbol=_pir_same ;;
        invalid-symbol-funcptr-*) symbol=_pir_missing ;;
        invalid-symbol-label-*) symbol=L_main_here ;;
    esac
    $work/lex "$source" | $work/lower | $work/emit > "$work/$name.self.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.self.s" -o "$work/$name.self" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "$symbol"
done

set +e
$work/lex "$root/seed/invalid-u64-negative.pir" | $work/lower | $work/emit > "$work/invalid-u64-negative.self.s" 2> "$work/invalid-u64-negative.self.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid-u64-negative.self.error")" = "plang0: emitter rejected token stream"

$work/lex "$root/seed/invalid-u64-overflow.pir" | $work/lower | $work/emit > "$work/invalid-u64-overflow.self.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-u64-overflow.self.s" -o "$work/invalid-u64-overflow.self" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "literal value out of range"

$work/lex "$root/seed/invalid-exit-status.pir" | $work/lower | $work/emit > "$work/invalid-exit-status.self.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-exit-status.self.s" -o "$work/invalid-exit-status.self" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "error: plang0: exit"

for source in "$root"/seed/invalid-top-*.pir; do
    set +e
    python3 "$root/seed/boot.py" "$source" "$work/invalid.py.s" >/dev/null 2>&1
    status=$?
    set -e
    test "$status" = 1
done

for source in "$root"/seed/invalid-symbol-*.pir; do
    set +e
    python3 "$root/seed/boot.py" "$source" "$work/invalid.py.s" >/dev/null 2>&1
    status=$?
    set -e
    test "$status" = 1
done

for source in "$root"/seed/invalid-register-count.pir "$root"/seed/invalid-u64-negative.pir "$root"/seed/invalid-u64-overflow.pir "$root"/seed/invalid-exit-status.pir; do
    set +e
    python3 "$root/seed/boot.py" "$source" "$work/invalid.py.s" >/dev/null 2>&1
    status=$?
    set -e
    test "$status" = 1
done

$work/lex "$root/seed/scan.pir" | $work/lower | $work/emit > "$work/scan.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/scan.self.s" -o "$work/scan.self"
test "$($work/scan.self "$root/seed/hello.pir")" = "scan ok"
set +e
error=$($work/scan.self 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source path required"
set +e
error=$($work/scan.self "$work/missing.pir" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source open failed"

set +e
error=$($work/lower < "$root/seed/invalid.tokens" 2>&1 > "$work/invalid.lower.tokens")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: lowering rejected token stream"

set +e
python3 "$root/seed/boot.py" "$root/seed/invalid-func-arity.pir" "$work/invalid.py.s" >/dev/null 2>&1
status=$?
set -e
test "$status" = 1

set +e
python3 "$root/seed/boot.py" "$root/seed/invalid-arg-index.pir" "$work/invalid.py.s" >/dev/null 2>&1
status=$?
set -e
test "$status" = 1

set +e
python3 "$root/seed/boot.py" "$root/seed/invalid-call-arity.pir" "$work/invalid.py.s" >/dev/null 2>&1
status=$?
set -e
test "$status" = 1

for source in "$root"/seed/invalid-memory-*.pir; do
    set +e
    python3 "$root/seed/boot.py" "$source" "$work/invalid.py.s" >/dev/null 2>&1
    status=$?
    set -e
    test "$status" = 1
done


set +e
$work/lex "$root/seed/invalid-func-arity.pir" | $work/lower > "$work/invalid.semantic.tokens" 2> "$work/invalid.semantic.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid.semantic.error")" = "plang0: lowering rejected token stream"

set +e
$work/lex "$root/seed/invalid-register-count.pir" | $work/lower > "$work/invalid.register.tokens" 2> "$work/invalid.register.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid.register.error")" = "plang0: lowering rejected token stream"

$work/lex "$root/seed/lower.pir" | $work/lower | $work/emit > "$work/lower.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/lower.self.s" -o "$work/lower.self"

set +e
$work/lex "$root/seed/invalid-func-arity.pir" | $work/lower.self > "$work/invalid.semantic.self.tokens" 2> "$work/invalid.semantic.self.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid.semantic.self.error")" = "plang0: lowering rejected token stream"

set +e
$work/lex "$root/seed/invalid-register-count.pir" | $work/lower.self > "$work/invalid.register.self.tokens" 2> "$work/invalid.register.self.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid.register.self.error")" = "plang0: lowering rejected token stream"

$work/lex "$root/seed/async.pir" | $work/lower | $work/emit > "$work/async.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/async.self.s" -o "$work/async.self"

$work/lex "$root/seed/collect.pir" | $work/lower | $work/emit > "$work/collect.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/collect.self.s" -o "$work/collect.self"

$work/lex "$root/seed/send.pir" | $work/lower | $work/emit > "$work/send.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/send.self.s" -o "$work/send.self"

$work/lex "$root/seed/meta.pir" | $work/lower | $work/emit > "$work/meta.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/meta.self.s" -o "$work/meta.self"
test "$($work/meta.self 3< "$work/await.source.tokens" < "$root/seed/atoms.manifest")" = "send
collect
async"

$work/lex "$root/seed/emit.pir" | $work/lower | $work/emit > "$work/emit.self.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/emit.self.s" -o "$work/emit.self"

set +e
error=$($work/emit.self < "$root/seed/invalid.tokens" 2>&1 > "$work/invalid.emit.self.s")
status=$?
set -e

test "$status" = 1
test "$error" = "plang0: emitter rejected token stream"

$work/lex "$root/seed/lower.pir" | $work/lower.self | $work/emit.self > "$work/lower.fixed.s"
cmp "$work/lower.self.s" "$work/lower.fixed.s"
$work/lex "$root/seed/async.pir" | $work/lower.self | $work/emit.self > "$work/async.fixed.s"
cmp "$work/async.self.s" "$work/async.fixed.s"
$work/lex "$root/seed/collect.pir" | $work/lower.self | $work/emit.self > "$work/collect.fixed.s"
cmp "$work/collect.self.s" "$work/collect.fixed.s"
$work/lex "$root/seed/send.pir" | $work/lower.self | $work/emit.self > "$work/send.fixed.s"
cmp "$work/send.self.s" "$work/send.fixed.s"
$work/lex "$root/seed/meta.pir" | $work/lower.self | $work/emit.self > "$work/meta.fixed.s"
cmp "$work/meta.self.s" "$work/meta.fixed.s"
$work/lex "$root/seed/emit.pir" | $work/lower.self | $work/emit.self > "$work/emit.fixed.s"
cmp "$work/emit.self.s" "$work/emit.fixed.s"

$work/lex "$root/seed/hello.pir" | $work/lower.self | $work/emit.self > "$work/hello.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/hello.fixed.s" -o "$work/hello.fixed"
test "$($work/hello.fixed)" = "hello, plang"

$work/lex "$root/seed/bitwise.pir" | $work/lower.self | $work/emit.self > "$work/bitwise.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/bitwise.fixed.s" -o "$work/bitwise.fixed"
test "$($work/bitwise.fixed)" = "bitwise ok"

$work/lex "$root/seed/capability.pir" | $work/lower.self | $work/emit.self > "$work/capability.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/capability.fixed.s" -o "$work/capability.fixed"
test "$($work/capability.fixed)" = "capability ok"

$work/lex "$root/seed/invalid-arg-index.pir" | $work/lower.self | $work/emit.self > "$work/invalid-arg-index.fixed.s"
cmp "$work/invalid-arg-index.self.s" "$work/invalid-arg-index.fixed.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-arg-index.fixed.s" -o "$work/invalid-arg-index.fixed" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "error: plang0: arg index"

$work/lex "$root/seed/invalid-call-arity.pir" | $work/lower.self | $work/emit.self > "$work/invalid-call-arity.fixed.s"
cmp "$work/invalid-call-arity.self.s" "$work/invalid-call-arity.fixed.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-call-arity.fixed.s" -o "$work/invalid-call-arity.fixed" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "_pir_one__arity_0"

for source in "$root"/seed/invalid-memory-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    $work/lex "$source" | $work/lower.self | $work/emit.self > "$work/$name.fixed.s"
    cmp "$work/$name.self.s" "$work/$name.fixed.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.fixed.s" -o "$work/$name.fixed" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "error: plang0: memory"
done

for source in "$root"/seed/invalid-top-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    case "$name" in
        invalid-top-main-*) symbol=_main ;;
        invalid-top-memory-*) symbol=_plang_memory_limit ;;
    esac
    $work/lex "$source" | $work/lower.self | $work/emit.self > "$work/$name.fixed.s"
    cmp "$work/$name.self.s" "$work/$name.fixed.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.fixed.s" -o "$work/$name.fixed" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "$symbol"
done

for source in "$root"/seed/invalid-symbol-*.pir; do
    name=${source##*/}
    name=${name%.pir}
    case "$name" in
        invalid-symbol-data-*) symbol=L_data_ ;;
        invalid-symbol-function-*) symbol=_pir_same ;;
        invalid-symbol-funcptr-*) symbol=_pir_missing ;;
        invalid-symbol-label-*) symbol=L_main_here ;;
    esac
    $work/lex "$source" | $work/lower.self | $work/emit.self > "$work/$name.fixed.s"
    cmp "$work/$name.self.s" "$work/$name.fixed.s"
    set +e
    error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/$name.fixed.s" -o "$work/$name.fixed" 2>&1)
    status=$?
    set -e
    test "$status" = 1
    echo "$error" | grep -q "$symbol"
done

set +e
$work/lex "$root/seed/invalid-u64-negative.pir" | $work/lower.self | $work/emit.self > "$work/invalid-u64-negative.fixed.s" 2> "$work/invalid-u64-negative.fixed.error"
status=$?
set -e
test "$status" = 1
test "$(cat "$work/invalid-u64-negative.fixed.error")" = "plang0: emitter rejected token stream"

$work/lex "$root/seed/invalid-u64-overflow.pir" | $work/lower.self | $work/emit.self > "$work/invalid-u64-overflow.fixed.s"
cmp "$work/invalid-u64-overflow.self.s" "$work/invalid-u64-overflow.fixed.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-u64-overflow.fixed.s" -o "$work/invalid-u64-overflow.fixed" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "literal value out of range"

$work/lex "$root/seed/invalid-exit-status.pir" | $work/lower.self | $work/emit.self > "$work/invalid-exit-status.fixed.s"
cmp "$work/invalid-exit-status.self.s" "$work/invalid-exit-status.fixed.s"
set +e
error=$(/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/invalid-exit-status.fixed.s" -o "$work/invalid-exit-status.fixed" 2>&1)
status=$?
set -e
test "$status" = 1
echo "$error" | grep -q "error: plang0: exit"

$work/lex "$root/seed/scan.pir" | $work/lower.self | $work/emit.self > "$work/scan.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/scan.fixed.s" -o "$work/scan.fixed"
test "$($work/scan.fixed "$root/seed/hello.pir")" = "scan ok"
set +e
error=$($work/scan.fixed 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source path required"
set +e
error=$($work/scan.fixed "$work/missing.pir" 2>&1)
status=$?
set -e
test "$status" = 1
test "$error" = "plang0: source open failed"

$work/lex "$root/seed/profile.pir" | $work/lower.self | $work/emit.self > "$work/profile.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/profile.fixed.s" -o "$work/profile.fixed"
test "$($work/profile.fixed)" = "profile ok"

$work/lex "$root/seed/channel.pir" | $work/lower.self | $work/emit.self > "$work/channel.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/channel.fixed.s" -o "$work/channel.fixed"
test "$($work/channel.fixed)" = "channel ok"

$work/lex "$root/seed/await.pir" > "$work/await.fixed.source"
"$root/seed/run-atoms.sh" "$work/meta.self" "$root/seed/atoms.manifest" "$work" "$work/await.fixed.source" "$work/await.fixed.atoms" .self
$work/lower.self < "$work/await.fixed.atoms" | $work/emit.self > "$work/await.fixed.s"
/usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$work/await.fixed.s" -o "$work/await.fixed"
test "$($work/await.fixed)" = "ABCawait ok
ABCcollect ok"

"$root/seed/report.sh" > /dev/null
