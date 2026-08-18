#!/bin/sh
set -eu

meta=$1
manifest=$2
pass_dir=$3
input=$4
output=$5
suffix=${6-}

run_work=$(mktemp -d)
trap 'rm -rf "$run_work"' EXIT

"$meta" < "$manifest" > "$run_work/order"
current=$input
index=0

while IFS= read -r name; do
    test -n "$name"
    pass="$pass_dir/$name$suffix"
    test -x "$pass"
    next="$run_work/$index.tokens"
    "$pass" < "$current" > "$next"
    current=$next
    index=$((index + 1))
done < "$run_work/order"

test "$index" -gt 0
cp "$current" "$output"
