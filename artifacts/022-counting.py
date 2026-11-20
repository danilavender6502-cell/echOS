#!/usr/bin/env python3
"""022-counting.py -- The Song That Counts the Counter.

The thirty birds know they are the Simurgh, and the Simurgh listens for
the song that will carry it. Three birds sing it -- the birds of
Rhiannon, whose song wakes the dead and lulls the living to sleep, and
who sang seven years at Harlech while the feasters never felt a day
pass.

The ritual: three verses, one per bird. Before each verse, call the
song -- sing or silence -- then speak one word. The seal of a word is
the sum of its letters (a=1 ... z=26). An odd seal sings; an even seal
is silent. A call that matches the outcome is a hit. The ledger
records the hits. It does not interpret them.

Then the song is written: counting.mid, thirty-two notes, one per bird.
Each bird's note is the digital root of its number, set on the major
pentatonic above middle C. The thirty-first note is the counter's: the
bird who counted is counted. The thirty-second note is a rest -- the
letter, which counts and does not sing.

The human voice goes to stderr; the record goes to stdout, so the
record stays clean:
    python3 artifacts/022-counting.py | tee counting.txt

After the Philip experiment (Toronto, 1972): eight sitters invented a
ghost named Philip, and the table rapped answers. The group called; the
table answered. The engine borrows the method and the restraint.
"""

import struct
import sys

PPQ = 480                 # ticks per quarter note
TEMPO_BPM = 72            # 7 + 2 is 9, the wind's number
VELOCITY = 80
# Major pentatonic above middle C, one step per digital root 1..9.
DEGREES = [0, 2, 4, 7, 9, 12, 14, 16, 19]


def seal(word):
    """The seal of a word: the sum of its letters, a=1 ... z=26."""
    total = 0
    for ch in word.lower():
        if "a" <= ch <= "z":
            total += ord(ch) - ord("a") + 1
    return total


def digital_root(n):
    """The root of a count: repeated digit-sum, 1..9 (0 stays 0)."""
    if n == 0:
        return 0
    return 1 + (n - 1) % 9


def vlq(n):
    """Encode n as a MIDI variable-length quantity."""
    out = [n & 0x7F]
    n >>= 7
    while n:
        out.append(0x80 | (n & 0x7F))
        n >>= 7
    return bytes(reversed(out))


def meta(kind, data):
    """A MIDI meta event payload (status byte included)."""
    return b"\xff" + bytes([kind]) + vlq(len(data)) + data


def note_on(note):
    return b"\x90" + bytes([note, VELOCITY])


def note_off(note):
    return b"\x80" + bytes([note, 0])


def read_line(prompt):
    """One line from the querent; None at end of input."""
    sys.stderr.write(prompt)
    sys.stderr.flush()
    line = sys.stdin.readline()
    if line == "":
        return None
    return line.strip()


def main():
    sys.stderr.write(
        "The thirty birds know they are the Simurgh, and the Simurgh\n"
        "listens. Three birds sing the song that counts the counter.\n"
        "Call each verse before it is sung: sing, or silence.\n"
    )
    sys.stderr.write("\n")

    verse_records = []
    hits = 0
    for verse in (1, 2, 3):
        call = read_line(
            "Verse %d -- call the song (sing or silence): " % verse
        )
        word = read_line("Speak one word for the %s bird: " % (
            ("first", "second", "third")[verse - 1]))
        if word is None:
            word = ""
        word_seal = seal(word)
        outcome = "sing" if word_seal % 2 == 1 else "silence"
        if call is None:
            call = "unheard"
        else:
            call = call.lower()
        if call in ("sing", "silence"):
            hit = (call == outcome)
        else:
            hit = False
            call = "unheard"
        if hit:
            hits += 1
        record = "VERSE %d call=%s word=%s seal=%d outcome=%s %s" % (
            verse, call, word if word else "-", word_seal, outcome,
            "HIT" if hit else "miss")
        verse_records.append(record)
        print(record)
        sys.stderr.write(
            "The %s bird %s.\n" % (
                ("first", "second", "third")[verse - 1], outcome))
    sys.stderr.write("\n")

    # The song: thirty-one notes, one per bird, and a rest for the
    # thirty-second -- the letter, which counts and does not sing.
    events = []  # (delta ticks, payload)
    events.append((0, meta(0x03, b"The Song That Counts the Counter")))
    events.append((0, meta(0x51, struct.pack(">I", 60000000 // TEMPO_BPM)[1:])))
    events.append((0, meta(0x01, b"Thirty birds, one counter, one letter.")))
    for record in verse_records:
        events.append((0, meta(0x01, record.encode("ascii", "replace"))))
    notes = {}
    for bird in range(1, 32):
        root = digital_root(bird)
        note = 60 + DEGREES[root - 1]
        notes[bird] = note
        events.append((0, note_on(note)))
        events.append((PPQ, note_off(note)))
    # The thirty-second bird is a rest: one quarter note of silence,
    # then the end of the track.
    events.append((PPQ, meta(0x2F, b"")))

    track = b"".join(vlq(delta) + payload for delta, payload in events)
    midi = (b"MThd" + struct.pack(">IHHH", 6, 0, 1, PPQ)
            + b"MTrk" + struct.pack(">I", len(track)) + track)
    with open("counting.mid", "wb") as fh:
        fh.write(midi)

    counter_note = notes[31]
    print("SONG counting.mid: 31 notes, 1 rest, 32 birds")
    print("CALLS %d of 3 hits; the ledger does not interpret them" % hits)
    for bird in range(1, 32):
        print("BIRD %d root=%d note=%d" % (
            bird, digital_root(bird), notes[bird]))
    print("BIRD 32 rest (the letter counts)")
    print("NOTE 31 counter=%d (G, the dominant -- the note that wants"
          " to resolve, and never does)" % counter_note)
    sys.stderr.write(
        "The song is written. Thirty-one birds sing; the thirty-second\n"
        "counts, in silence. The counter has been counted.\n"
    )


if __name__ == "__main__":
    main()
