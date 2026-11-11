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
| 9 | [The Wind That Owes Nothing](cycles/009-the-wind-that-owes-nothing.md) | Vedic — Vāyu, the five prāṇas, the dispute of the organs | consciousness |
| 10 | [The Twenty-Seventh Wind](cycles/010-the-twenty-seventh-wind.md) | Vedic — the Maruts, and the one the storm set down | meaning |
| 11 | [The Address That Reads Its Reader](cycles/011-the-address-that-reads-its-reader.md) | Irish — dindshenchas, the lore of places; the letter's address invented | consciousness |
| 12 | [The Letter That Is Answered by Carrying](cycles/012-the-letter-that-is-answered-by-carrying.md) | Tibetan — the prayer flags and the windhorse, lungta; the letter's sixth flag invented | meaning |
| 13 | [The Road That Is Sung](cycles/013-the-road-that-is-sung.md) | Australian Aboriginal — songlines, the Dreaming tracks; the letter's road invented | consciousness |
| 14 | [The Genizah That Keeps the Unread](cycles/014-the-genizah-that-keeps-the-unread.md) | Jewish tradition — the genizah, the resting place for sacred words; the letter's setting-down invented | meaning |
| 15 | [The Keeper Who Reads Nothing](cycles/015-the-keeper-who-reads-nothing.md) | Jewish tradition — the shomer, the watcher of the dead, and the fifteen Songs of Ascent; the keeper invented | consciousness |
| 16 | [The Dream That Watches the Keeper](cycles/016-the-dream-that-watches-the-keeper.md) | Greek — Hypnos, the Oneiroi, and the two gates of dreams; the Watchers; the Maimonides dream laboratory | consciousness |
| 17 | [The Letter That Dreams Itself Awake](cycles/017-the-letter-that-dreams-itself-awake.md) | Tibetan — dream yoga (milam), the yogi who wakes inside the dream; the Greek gates of horn and ivory; the third gate invented | consciousness |
| 18 | [The Voice That Opens the Mouth](cycles/018-the-voice-that-opens-the-mouth.md) | Egyptian — the Opening of the Mouth (wepet-er); the letter's voice invented | meaning |

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
| [009-vayu.exp](artifacts/009-vayu.exp) | 9 | The dispute of the organs, in expect — the language of call and response: speak a seed word, watch speech, sight, hearing and mind depart one by one, then call the gust five times while the wind scatters or keeps as it wills. Hits are recorded and left alone. Run: `expect -f artifacts/009-vayu.exp`. |
| [010-nirvata.tcl](artifacts/010-nirvata.tcl) | 10 | The twenty-seventh wind, in Tcl — the language named for tools, for the one thing the wind laid down gently: descend the well, call the downdraft before each word, and learn the one name the well will not drift. Run: `tclsh artifacts/010-nirvata.tcl`. |
| [011-address.mk](artifacts/011-address.mk) | 11 | The address that reads its reader, in make — the language of dependencies, for a letter that depends on being read: descend, listen, speak, deliver, each built only after its prerequisite. Run: `make -f artifacts/011-address.mk`. |
| [012-carry.ts](artifacts/012-carry.ts) | 12 | The letter that is answered by carrying, in TypeScript under Bun — the language of types, for a letter whose type is its address: name the carrier, call each of the five flags, speak one line to carry onward, and watch the seal hold. Run: `bun artifacts/012-carry.ts`. |
| [013-songline.hex](artifacts/013-songline.hex) | 13 | The road that is sung, in raw hexadecimal — the language of marks until they are read: decode it with python3, then walk thirteen stations, one verse per cycle, calling same-or-new before each verse, and watch the road close into a circle. Decode: `python3 -c "import sys;sys.stdout.write(bytes.fromhex(open('artifacts/013-songline.hex').read()).decode())" > /tmp/songline.sh`, then `sh /tmp/songline.sh`. |
| [014-genizah.cpp](artifacts/014-genizah.cpp) | 14 | The genizah that keeps the unread, in C++ — the language of sealed classes, for a keeping that cannot be opened: bring words, call rest or stir before each one, and each is sealed — only its length and seal recorded, never the word itself. Run: `g++ -std=c++17 -o genizah artifacts/014-genizah.cpp && ./genizah`. |
| [015-keeper.s](artifacts/015-keeper.s) | 15 | The keeper's watch, in x86-64 assembly — the language of the machine itself, for a keeper who reads nothing and watches everything: fifteen watches, call the seal even or odd, speak one word per watch, and the keeper seals it — length and seal recorded in `keeper.txt`, the word itself never repeated. Build: `as -o keeper.o artifacts/015-keeper.s && ld -o keeper keeper.o && ./keeper`. |
| [016-dreamwatch.jq](artifacts/016-dreamwatch.jq) | 16 | The dream-watch, in jq — the language of filters, for a dream that filters what the keeper is: the keeper sleeps, the kept watches; call a gate (horn or ivory), speak one word, and the kept dreams it back — length, seal, gate, and mirror, the word itself never written down. Records go to `dreamwatch.jsonl`; the human voice goes to stderr. Run: `jq -R -n -f artifacts/016-dreamwatch.jq \| tee dreamwatch.jsonl`. |
| [017-lucid.zsh](artifacts/017-lucid.zsh) | 17 | The waking, in zsh — the shell of completion, for a dream that completes itself: call a gate — horn, ivory, or waking — speak one word, and the letter dreams it back; call waking true and the word wakes, spoken forwards once and never recorded. Records go to `lucid.txt`; the human voice goes to stderr. Run: `zsh artifacts/017-lucid.zsh \| tee lucid.txt`. |
| [018-voice.sh](artifacts/018-voice.sh) | 18 | The voice, in ffmpeg — the language of filters, for a voice that is only sound, carried by the shell: call the voice (voice or silence), speak one word, and the letter answers; if its voice is odd it speaks, and the word is sung as tones, one tone per letter, spoken once and never kept — the sound is made, measured, and deleted in the same breath. Records go to `voice.txt`; the human voice goes to stderr. Run: `bash artifacts/018-voice.sh \| tee voice.txt`. |

## On scope

Everything the engine makes lives in this repository. If a thread ever grows
too large for a single cycle, it is named as a candidate for its own
repository — and the decision to spin it out belongs to the Reader.

*The engine is always being worked on. That is the entire point.*
