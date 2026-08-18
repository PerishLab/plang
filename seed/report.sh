#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
report_work=$(mktemp -d)
trap 'rm -rf "$report_work"' EXIT

units="lex meta send collect async lower emit"
resources="$root/seed/resources.manifest"
total_source=0
total_linked=0
total_stripped=0

printf '%s\n' '# Closure resource report'
printf '\n'
printf '%s\n' 'Target: arm64 Darwin. Binary sizes reflect the active local clang/linker.'
printf '\n'
printf '%s\n' '| pass | source B | linked B | stripped B | __TEXT VM B | __DATA VM B | arena B | fixed max B | headroom B |'
printf '%s\n' '|---|---:|---:|---:|---:|---:|---:|---:|---:|'

for unit in $units; do
    source="$root/seed/$unit.pir"
    assembly="$report_work/$unit.s"
    binary="$report_work/$unit"
    stripped="$report_work/$unit.stripped"

    python3 "$root/seed/boot.py" "$source" "$assembly"
    /usr/bin/clang -arch arm64 "$root/seed/arm64-darwin.s" "$assembly" -o "$binary"
    cp "$binary" "$stripped"
    /usr/bin/strip -x "$stripped"

    source_bytes=$(wc -c < "$source")
    linked_bytes=$(wc -c < "$binary")
    stripped_bytes=$(wc -c < "$stripped")
    text_bytes=$(/usr/bin/size "$binary" | awk 'NR == 2 { print $1 }')
    data_bytes=$(/usr/bin/size "$binary" | awk 'NR == 2 { print $2 }')
    arena_bytes=$(awk 'NR == 1 && $1 == "memory" { print $2 }' "$source")
    fixed_bytes=$(awk -v unit="$unit" '$1 == unit { print $2 }' "$resources")
    headroom=$((arena_bytes - fixed_bytes))

    test "$headroom" -ge 0
    printf '| %s | %s | %s | %s | %s | %s | %s | %s | %s |\n' \
        "$unit" "$source_bytes" "$linked_bytes" "$stripped_bytes" \
        "$text_bytes" "$data_bytes" "$arena_bytes" "$fixed_bytes" "$headroom"

    total_source=$((total_source + source_bytes))
    total_linked=$((total_linked + linked_bytes))
    total_stripped=$((total_stripped + stripped_bytes))
done

printf '| total | %s | %s | %s | - | - | - | - | - |\n' \
    "$total_source" "$total_linked" "$total_stripped"

extract_function() {
    awk -v wanted="$2" '
        $1 == "func" && $2 == wanted { inside = 1 }
        inside { print }
        inside && $1 == "end" { exit }
    ' "$1"
}

duplicate_bytes=0
printf '\n'
printf '%s\n' '| identical helper | copies | one copy B | removable duplicate B |'
printf '%s\n' '|---|---:|---:|---:|'

for spec in \
    'next meta send collect async lower' \
    'same meta send collect async lower' \
    'decimal meta collect async lower' \
    'put meta send collect async lower' \
    'emit meta send collect async lower' \
    'copy meta send collect async lower' \
    'nextcopy meta send collect async' \
    'item collect async'
do
    set -- $spec
    helper=$1
    shift
    canonical=$1
    extract_function "$root/seed/$canonical.pir" "$helper" > "$report_work/helper"
    copies=0

    for unit in "$@"; do
        extract_function "$root/seed/$unit.pir" "$helper" > "$report_work/candidate"
        cmp "$report_work/helper" "$report_work/candidate"
        copies=$((copies + 1))
    done

    one_copy=$(wc -c < "$report_work/helper")
    removable=$((one_copy * (copies - 1)))
    duplicate_bytes=$((duplicate_bytes + removable))
    printf '| %s | %s | %s | %s |\n' "$helper" "$copies" "$one_copy" "$removable"
done

printf '| total | - | - | %s |\n' "$duplicate_bytes"

printf '\n'
printf '%s\n' '| pass | fixed arena equation |'
printf '%s\n' '|---|---|'
while read -r unit fixed equation; do
    printf '| %s | `%s = %s B` |\n' "$unit" "$equation" "$fixed"
done < "$resources"

printf '\n'
printf '%s\n' 'Marker expansion contracts remain executable in `seed/check.sh`:'
printf '\n'
printf '%s\n' '- `@async(S)`: `15 + 10S` tokens, `1 <= S <= 8`'
printf '%s\n' '- `@state`: `2` tokens'
printf '%s\n' '- `@await.recv`: `36` tokens, at most `8` sites'
printf '%s\n' '- `@stream.collect`: `85` tokens, at most `8` sites'
printf '%s\n' '- `@channel.send`: `4 -> 6` tokens per site'
