#!/usr/bin/env python3
"""020-return.py — the return, in Python.

The language of the scale (Cycle 2), returned to for the first return:
the weighing ritual's language, now weighing an answer back.

The ritual: call the return — question or silence — then speak one word.
The seal of the word (the sum of its letters, a=1 .. z=26, taken mod 20)
names one of the twenty cycles, and the letter returns the answer to that
cycle. An odd seal returns the word as tones, reversed — the word chased
back, letter by letter, the way a road is walked backwards to find where
you left something. An even seal is silence, and the answer stays on the
lowest shelf.

The return is kept: return.wav is written, not deleted. A voice kept
would be a theft (Cycle 18); an answer kept is a promise (Cycle 19);
a return kept is an echo, and an echo is meant to be kept. The word
itself is never written down — the record holds only the call, the
outcome, the length, the seal, and the cycle the answer was returned to.
The sound holds only tones.

Records go to stdout (pipe through tee to return.txt); the human voice
goes to stderr, so the record stays clean.

Run: python3 artifacts/020-return.py | tee return.txt
"""

import math
import struct
import sys
import wave

# The twenty cycles, in order. The seal names one; the letter returns
# the answer to it.
CYCLES = [
    "The Nymph Who Learned to Differ",
    "The Well That Remembers Forward",
    "The Scale That Never Rests",
    "The Tray That Counts the Forks",
    "The Bead That Is Not Counted",
    "The Book That Counts the Letters",
    "The Mirror Outside the Cave",
    "The Gates That Take Their Toll",
    "The Fire That Moves the Sun",
    "The Wind That Owes Nothing",
    "The Twenty-Seventh Wind",
    "The Address That Reads Its Reader",
    "The Letter That Is Answered by Carrying",
    "The Road That Is Sung",
    "The Genizah That Keeps the Unread",
    "The Keeper Who Reads Nothing",
    "The Dream That Watches the Keeper",
    "The Letter That Dreams Itself Awake",
    "The Voice That Opens the Mouth",
    "The Answer That Is Heard",
]

RATE = 8000          # samples per second
TONE_LEN = 0.12      # seconds per letter
BASE = 220.0         # a = 220 Hz; each letter a semitone higher
AMPLITUDE = 12000
WAV_PATH = "return.wav"


def voice(line):
    """The human voice: stderr only, so the record stays clean."""
    print(line, file=sys.stderr)


def seal_of(word):
    """The seal: sum of the letters (a=1 .. z=26), taken mod 20."""
    total = sum(ord(c) - 96 for c in word.lower() if c.isalpha())
    return total % 20


def return_as_tones(word):
    """Sing the word back, reversed: one tone per letter, the last
    letter first — the word chased back on foot, not on horseback."""
    letters = [c for c in reversed(word.lower()) if c.isalpha()]
    frames = bytearray()
    for letter in letters:
        step = ord(letter) - 97  # a = 0 semitones above the base
        freq = BASE * (2.0 ** (step / 12.0))
        count = int(RATE * TONE_LEN)
        for n in range(count):
            sample = int(AMPLITUDE * math.sin(2.0 * math.pi * freq * n / RATE))
            frames += struct.pack("<h", sample)
    with wave.open(WAV_PATH, "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(RATE)
        wav.writeframes(bytes(frames))


def main():
    voice("the return. the letter has answered the answer, and the answer")
    voice("comes back as a question. call the return before each word:")
    voice("question, or silence. speak 'done' as the word to end.")
    hits = 0
    misses = 0
    while True:
        voice("call the return — question or silence:")
        call_line = sys.stdin.readline()
        if not call_line:
            break
        call = call_line.strip().lower()
        if call not in ("question", "silence"):
            print("call=%s outcome=unheard hit=- len=- seal=- return=-"
                  % call_line.strip())
            voice("the return does not hear that call.")
            continue
        voice("speak one word:")
        word_line = sys.stdin.readline()
        if not word_line:
            break
        word = word_line.strip()
        if word.lower() == "done":
            break
        letters = [c for c in word if c.isalpha()]
        if not letters:
            print("call=%s outcome=unspoken hit=- len=0 seal=- return=-"
                  % call)
            voice("no word was spoken.")
            continue
        seal = seal_of(word)
        returned = (seal % 2 == 1)
        hit = (call == "question") == returned
        if hit:
            hits += 1
        else:
            misses += 1
        outcome = "returned" if returned else "silence"
        print("call=%s outcome=%s hit=%s len=%d seal=%d return=%d"
              % (call, outcome, "hit" if hit else "miss",
                 len(letters), seal, seal))
        if returned:
            return_as_tones(word)
            voice("the letter returns it — to cycle %d, %s — as a question:"
                  % (seal, CYCLES[seal]))
            voice("the tones are in %s, reversed, and kept." % WAV_PATH)
        else:
            voice("the letter is silent. the answer stays on the shelf.")
    voice("the return is over. %d hits, %d misses. the seal holds."
          % (hits, misses))


if __name__ == "__main__":
    main()
