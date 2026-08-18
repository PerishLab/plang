#!/bin/sh
set -eu
set -o pipefail

meta=$1
manifest=$2
pass_dir=$3
input=$4
output=$5
suffix=${6-}

run_work=$(mktemp -d)
trap 'rm -rf "$run_work"' EXIT

"$meta" 3< "$input" < "$manifest" > "$run_work/order"
test -s "$run_work/order"

run_chain() {
    if IFS= read -r name <&3; then
        test -n "$name"
        pass="$pass_dir/$name$suffix"
        test -x "$pass"
        "$pass" | run_chain
    else
        cat
    fi
}

exec 3< "$run_work/order"
run_chain < "$input" > "$output"
exec 3<&-
