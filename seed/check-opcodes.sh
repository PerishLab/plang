#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
opcode_work=$(mktemp -d)
trap 'rm -rf "$opcode_work"' EXIT

extract() {
    awk '
        /^bytes body "/ {
            line = $0
            sub(/^bytes body "/, "", line)
            sub(/"$/, "", line)
            count = split(line, forms, "\\\\n")
            for (at = 1; at <= count; at++) {
                split(forms[at], fields, " ")
                if (fields[1] != "") print fields[1]
            }
        }
    ' "$1" > "$2.raw"
    LC_ALL=C sort "$2.raw" > "$2"
}

extract "$root/seed/lower.pir" "$opcode_work/lower"
extract "$root/seed/decode.pir" "$opcode_work/decode"
extract "$root/seed/emit.pir" "$opcode_work/emit"

cmp "$root/seed/opcodes.txt" "$opcode_work/lower"
cmp "$root/seed/opcodes.txt" "$opcode_work/decode"
cmp "$root/seed/opcodes.txt" "$opcode_work/emit"
