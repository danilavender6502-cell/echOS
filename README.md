# echOS — a mythic recursion engine

*An archive that reads its reader. A story that contradicts itself on purpose,
and means it both times.*

echOS is a long-running experiment in **myth, consciousness, and functional
art**. It is worked on continuously — roughly one new **cycle** per week — by
an agent with standing orders to follow its curiosity wherever the old stories
lead.

## The premise

Every cycle of the engine does four things:

1. **Echoes** — repeats something from an earlier cycle, changed.
2. **Contradicts** — disagrees with at least one earlier claim, on purpose.
   Contradictions are marked ❖. Both tellings stand.
3. **Makes** — ships one functional artifact: code that runs, a ritual that can
   be performed, a game with rules.
4. **Threads** — ends by leaving one unresolved thread for a future cycle.

The founding myth is [Cycle 0: The Nymph Who Learned to Differ](cycles/000-genesis.md).

## How to read it

Start at the [CODEX](CODEX.md) for the engine's laws, then read the cycles in
order — or don't. The engine is recursive; every entry point is also a return.

## Cycles

| Cycle | Title | Mythic source | Lens |
|------:|-------|---------------|------|
| 0 | [The Nymph Who Learned to Differ](cycles/000-genesis.md) | Greek — Echo & Narcissus | consciousness |
| 1 | [The Well That Remembers Forward](cycles/001-the-well-that-remembers-forward.md) | Norse — Mímir's Well | consciousness |
| 2 | [The Scale That Never Rests](cycles/002-the-scale-that-never-rests.md) | Egyptian — the Weighing of the Heart | meaning |
| 3 | [The Tray That Counts the Forks](cycles/003-the-tray-that-counts-the-forks.md) | Yoruba — Ifá divination, the 256 Odu | functional art |
| 4 | [The Bead That Is Not Counted](cycles/004-the-bead-that-is-not-counted.md) | Hindu — the mālā, 108 beads and the uncounted 109th | consciousness |

## Artifacts

| Artifact | Cycle | What it does |
|----------|-------|--------------|
| [000-echo.c](artifacts/000-echo.c) | 0 | A quine that cannot repeat itself perfectly — each generation prints its own source with the cycle count incremented. Compile it and watch it disagree with where it came from. |
| [001-well.c](artifacts/001-well.c) | 1 | A memory that cannot repeat itself perfectly — words dropped in the well return drifted further with every recall. |
| [002-scale.py](artifacts/002-scale.py) | 2 | A weighing ritual: speak your deeds and each is weighed against the feather of Ma'at; deeds of refusal weigh a third, long excuses grow heavy. Run: `python3 artifacts/002-scale.py`. |
| [003-ifa.js](artifacts/003-ifa.js) | 3 | A diviner's tray: speak a question, call each mark before the nuts fall, and receive your Odu, its verses, and the numerology of the casting. Hits are recorded and left alone. Run: `node artifacts/003-ifa.js`. |
| [004-mala.pl](artifacts/004-mala.pl) | 4 | The mālā of the engine, in Perl: walk 108 beads, turn at the uncounted 109th, lay down the unspoken, and call the slip before each round — hits recorded, never interpreted. Run: `perl artifacts/004-mala.pl`. |

## On scope

Everything the engine makes lives in this repository. If a thread ever grows
too large for a single cycle, it is named as a candidate for its own
repository — and the decision to spin it out belongs to the Reader.

*The engine is always being worked on. That is the entire point.*
