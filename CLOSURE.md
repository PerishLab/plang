# Closure size and resource baseline

Run `seed/report.sh` on arm64 Darwin to rebuild the eight compiler passes through
the Python oracle and print the current measurement. Binary file and segment
sizes depend on the active clang/linker; source, arena, fixed allocation, marker
expansion, and identical-helper results are repository contracts.

The baseline after introducing per-program arenas is:

| pass | source B | linked B | strip -x B | __TEXT VM B | __DATA VM B | arena B | fixed max B | headroom B |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| lex | 2,057 | 50,576 | 50,608 | 16,384 | 16,384 | 8,192 | 4,096 | 4,096 |
| meta | 23,923 | 51,224 | 51,232 | 16,384 | 16,384 | 8,192 | 8,064 | 128 |
| send | 2,820 | 50,792 | 50,800 | 16,384 | 16,384 | 8,192 | 4,288 | 3,904 |
| collect | 7,327 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| async | 9,740 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| utf8-pass | 5,977 | 50,792 | 50,800 | 16,384 | 16,384 | 8,192 | 4,288 | 3,904 |
| lower | 9,460 | 51,128 | 51,136 | 16,384 | 16,384 | 8,192 | 6,208 | 1,984 |
| emit | 26,331 | 50,744 | 50,768 | 16,384 | 49,152 | 32,768 | 20,480 | 12,288 |
| total | 87,635 | 407,032 | 407,136 | — | — | 90,112 | 56,256 | 33,856 |

Before this measurement, every pass inherited a 16 MiB arena: 128 MiB of
declared capacity across the eight executables. The new profiles total 88 KiB,
a reduction of roughly 1,489 times, without changing any executable contract.
`seed/profile.pir` separately proves a 4 KiB declaration reaches both the Python
oracle and self-hosted emitter, permits one exact-capacity allocation, and
rejects the next allocation.

The linked files remain close to 50 KiB each and `strip -x` does not materially
reduce them. All eight text segments occupy the same 16 KiB VM page. At this
stage, file size is dominated by having eight Mach-O images and their load/page
floor, not by a demonstrated need for large generated code.

The report extracts and byte-compares identical PIR1 function bodies. Their
currently removable source duplication is:

| helper | copies | one copy B | duplicate B |
|---|---:|---:|---:|
| next | 5 | 418 | 1,672 |
| same | 5 | 338 | 1,352 |
| decimal | 4 | 477 | 1,431 |
| put | 5 | 95 | 380 |
| emit | 5 | 106 | 424 |
| copy | 5 | 327 | 1,308 |
| nextcopy | 4 | 309 | 927 |
| item | 2 | 643 | 643 |
| total | — | — | 8,137 |

This is meaningful but not yet a reason to fuse semantic passes. Separate
passes preserve local algebra, independent fixed points, and fault attribution.
The compile-time budget proof now lives in `meta.pir`: source marker counts,
exact primary framing, constant/affine auxiliary and extension transfer, emission
multiplicity, and cumulative token work can reject an unsafe plan before any
atom pass starts.
Runtime effect overlap is kept separate from compiler transform ordering.
Fusion should be reconsidered
only after measuring actual text bytes below the Mach-O page floor or after
process-image overhead becomes the dominant deployment constraint.
