# Closure size and resource baseline

Run `seed/report.sh` on arm64 Darwin to rebuild the six compiler passes through
the Python oracle and print the current measurement. Binary file and segment
sizes depend on the active clang/linker; source, arena, fixed allocation, marker
expansion, and identical-helper results are repository contracts.

The baseline after introducing per-program arenas is:

| pass | source B | linked B | strip -x B | __TEXT VM B | __DATA VM B | arena B | fixed max B | headroom B |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| lex | 2,057 | 50,576 | 50,608 | 16,384 | 16,384 | 8,192 | 4,096 | 4,096 |
| meta | 12,751 | 51,176 | 51,200 | 16,384 | 16,384 | 8,192 | 6,848 | 1,344 |
| collect | 7,327 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| async | 7,939 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| lower | 9,281 | 51,128 | 51,136 | 16,384 | 16,384 | 8,192 | 6,208 | 1,984 |
| emit | 20,689 | 50,744 | 50,768 | 16,384 | 49,152 | 32,768 | 20,480 | 12,288 |
| total | 60,044 | 305,400 | 305,504 | — | — | 73,728 | 46,464 | 27,264 |

Before this measurement, every pass inherited a 16 MiB arena: 96 MiB of
declared capacity across the six executables. The new profiles total 72 KiB, a
reduction of roughly 1,365 times, without changing any executable contract.
`seed/profile.pir` separately proves a 4 KiB declaration reaches both the Python
oracle and self-hosted emitter, permits one exact-capacity allocation, and
rejects the next allocation.

The linked files remain close to 50 KiB each and `strip -x` does not materially
reduce them. All six text segments occupy the same 16 KiB VM page. At this
stage, file size is dominated by having six Mach-O images and their load/page
floor, not by a demonstrated need for large generated code.

The report extracts and byte-compares identical PIR1 function bodies. Their
currently removable source duplication is:

| helper | copies | one copy B | duplicate B |
|---|---:|---:|---:|
| next | 4 | 418 | 1,254 |
| same | 4 | 338 | 1,014 |
| decimal | 4 | 477 | 1,431 |
| put | 4 | 95 | 285 |
| emit | 4 | 106 | 318 |
| copy | 4 | 327 | 981 |
| nextcopy | 3 | 309 | 618 |
| item | 2 | 643 | 643 |
| total | — | — | 6,544 |

This is meaningful but not yet a reason to fuse semantic passes. Separate
passes preserve local algebra, independent fixed points, and fault attribution.
The compile-time budget proof now lives in `meta.pir`: source marker counts,
declared expansion, cumulative token work, and overlapping write effects can
reject an unsafe plan before any atom pass starts. Fusion should be reconsidered
only after measuring actual text bytes below the Mach-O page floor or after
process-image overhead becomes the dominant deployment constraint.
