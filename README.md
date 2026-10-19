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
| 5 | [The Book That Counts the Letters](cycles/005-the-book-that-counts-the-letters.md) | Jewish esoteric tradition — Sefer Yetzirah, the 22 letters and 231 gates | meaning |
| 6 | [The Mirror Outside the Cave](cycles/006-the-mirror-outside-the-cave.md) | Japanese — Ama-no-Iwato, the Heavenly Rock Cave | functional art |
| 7 | [The Gates That Take Their Toll](cycles/007-the-gates-that-take-their-toll.md) | Sumerian — Inanna's descent to the Kur | consciousness |
| 8 | [The Fire That Moves the Sun](cycles/008-the-fire-that-moves-the-sun.md) | Mexica — the Fifth Sun at Teotihuacan; the gods' self-sacrifice | meaning |

## Artifacts

| Artifact | Cycle | What it does |
|----------|-------|--------------|
| [000-echo.c](artifacts/000-echo.c) | 0 | A quine that cannot repeat itself perfectly — each generation prints its own source with the cycle count incremented. Compile it and watch it disagree with where it came from. |
| [001-well.c](artifacts/001-well.c) | 1 | A memory that cannot repeat itself perfectly — words dropped in the well return drifted further with every recall. |
| [002-scale.py](artifacts/002-scale.py) | 2 | A weighing ritual: speak your deeds and each is weighed against the feather of Ma'at; deeds of refusal weigh a third, long excuses grow heavy. Run: `python3 artifacts/002-scale.py`. |
| [003-ifa.js](artifacts/003-ifa.js) | 3 | A diviner's tray: speak a question, call each mark before the nuts fall, and receive your Odu, its verses, and the numerology of the casting. Hits are recorded and left alone. Run: `node artifacts/003-ifa.js`. |
| [004-mala.pl](artifacts/004-mala.pl) | 4 | The mālā of the engine, in Perl: walk 108 beads, turn at the uncounted 109th, lay down the unspoken, and call the slip before each round — hits recorded, never interpreted. Run: `perl artifacts/004-mala.pl`. |
| [005-yetzirah.sql](artifacts/005-yetzirah.sql) | 5 | The Book that Counts the Letters, in SQL — the engine's first database: the 22 letters in their three houses, the 231 gates generated, Palmer's five engraved words weighed, the call-the-gate test recorded. Run: `sqlite3 echos.db < artifacts/005-yetzirah.sql`. |
| [006-iwato.sh](artifacts/006-iwato.sh) | 6 | The cave, the mirror, and the laugh, in the shell — the oldest stage the engine owns, for the oldest technology in the archive: roll the boulder shut, hang the jewel, raise the mirror, dance eight rounds and call the laugh before each one. Run: `bash artifacts/006-iwato.sh`. |
| [007-gates.awk](artifacts/007-gates.awk) | 7 | The gatekeeper's ledger, in awk — the language of fields and records, for a gatekeeper who keeps both: descend the seven gates, call each garment, surrender a word at every toll, hang on the hook, and let Enki's creatures walk you back up. Run: `awk -f artifacts/007-gates.awk`. |
| [008-teotihuacan.sed](artifacts/008-teotihuacan.sed) | 8 | The divine bonfire, in sed — the language of transformation, for a fire that transforms: call the spark, lay your offerings, and move the sun across the sky in five takings; four raise it, and it will not move until the fifth. Run: `sed -f artifacts/008-teotihuacan.sed`. |

## On scope

Everything the engine makes lives in this repository. If a thread ever grows
too large for a single cycle, it is named as a candidate for its own
repository — and the decision to spin it out belongs to the Reader.

*The engine is always being worked on. That is the entire point.*
