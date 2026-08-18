#!/bin/sh
set -eu

reject() {
    printf '%s\n' 'plang0: source manifest rejected' >&2
    exit 1
}

test "$#" = 3 || reject

lex=$1
manifest=$2
output=$3

test -x "$lex" || reject
test -f "$manifest" || reject

manifest_dir=$(CDPATH='' cd -- "$(dirname -- "$manifest")" && pwd -P)
manifest_path="$manifest_dir/$(basename -- "$manifest")"
output_dir=$(CDPATH='' cd -- "$(dirname -- "$output")" && pwd -P) || reject
output_path="$output_dir/$(basename -- "$output")"
test "$output_path" != "$manifest_path" || reject
test ! -d "$output_path" || reject
compose_work=$(mktemp -d)
trap 'rm -rf "$compose_work"' EXIT

: > "$compose_work/aggregate"
: > "$compose_work/seen"

budget=
sources=0
tokens=0

while IFS=' ' read -r kind value extra || test -n "$kind$value$extra"; do
    test -n "$kind" || reject
    test -n "$value" || reject
    test -z "$extra" || reject

    if test -z "$budget"; then
        test "$kind" = budget || reject
        case "$value" in
            *[!0-9]*) reject ;;
        esac
        if ! test "$value" -ge 1 2>/dev/null ||
            ! test "$value" -le 65535 2>/dev/null; then
            reject
        fi
        budget=$value
        continue
    fi

    test "$kind" = source || reject
    case "$value" in
        /*|*//*|*/|.|..|./*|../*|*/./*|*/../*|*/.|*/..) reject ;;
    esac
    if grep -Fqx -- "$value" "$compose_work/seen"; then
        reject
    fi

    sources=$((sources + 1))
    test "$sources" -le 32 || reject
    printf '%s\n' "$value" >> "$compose_work/seen"

    source_path="$manifest_dir/$value"
    test -f "$source_path" || reject
    test "$output_path" != "$source_path" || reject
    "$lex" "$source_path" > "$compose_work/source.tokens" || reject

    source_tokens=$(wc -l < "$compose_work/source.tokens")
    tokens=$((tokens + source_tokens))
    test "$tokens" -le "$budget" || reject

    memory_count=$(grep -c '^memory$' "$compose_work/source.tokens" || true)
    main_count=$(awk '
        previous == "func" && $0 == "main" { count++ }
        { previous = $0 }
        END { print count + 0 }
    ' "$compose_work/source.tokens")

    if test "$sources" = 1; then
        test "$memory_count" = 1 || reject
        test "$main_count" = 1 || reject
    else
        test "$memory_count" = 0 || reject
        test "$main_count" = 0 || reject
    fi

    cat "$compose_work/source.tokens" >> "$compose_work/aggregate"
done < "$manifest"

test -n "$budget" || reject
test "$sources" -ge 1 || reject
mv "$compose_work/aggregate" "$output_path"
