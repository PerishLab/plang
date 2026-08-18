# Closure size and resource baseline

Run `seed/report.sh` on arm64 Darwin to rebuild the seven compiler passes through
the Python oracle and print the current measurement. Binary file and segment
sizes depend on the active clang/linker; source, arena, fixed allocation, marker
expansion, and identical-helper results are repository contracts.

The baseline after introducing per-program arenas is:

| pass | source B | linked B | strip -x B | __TEXT VM B | __DATA VM B | arena B | fixed max B | headroom B |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| lex | 2,057 | 50,576 | 50,608 | 16,384 | 16,384 | 8,192 | 4,096 | 4,096 |
| meta | 11,511 | 51,144 | 51,152 | 16,384 | 16,384 | 8,192 | 7,488 | 704 |
| send | 2,820 | 50,792 | 50,800 | 16,384 | 16,384 | 8,192 | 4,288 | 3,904 |
| collect | 7,327 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| async | 7,939 | 50,888 | 50,896 | 16,384 | 16,384 | 8,192 | 4,416 | 3,776 |
| lower | 9,281 | 51,128 | 51,136 | 16,384 | 16,384 | 8,192 | 6,208 | 1,984 |
| emit | 20,689 | 50,744 | 50,768 | 16,384 | 49,152 | 32,768 | 20,480 | 12,288 |
| total | 61,624 | 356,160 | 356,256 | — | — | 81,920 | 51,392 | 30,528 |

Before this measurement, every pass inherited a 16 MiB arena: 112 MiB of
declared capacity across the seven executables. The new profiles total 80 KiB,
a reduction of roughly 1,434 times, without changing any executable contract.
`seed/profile.pir` separately proves a 4 KiB declaration reaches both the Python
oracle and self-hosted emitter, permits one exact-capacity allocation, and
rejects the next allocation.

The linked files remain close to 50 KiB each and `strip -x` does not materially
reduce them. All seven text segments occupy the same 16 KiB VM page. At this
stage, file size is dominated by having seven Mach-O images and their load/page
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
exact input/output framing, emission multiplicity, and cumulative token work
can reject an unsafe plan before any atom pass starts. Runtime effect overlap is
kept separate from compiler transform ordering. Fusion should be reconsidered
only after measuring actual text bytes below the Mach-O page floor or after
process-image overhead becomes the dominant deployment constraint.
