#!/usr/bin/env python3
"""
002-scale.py -- The Weighing of the Heart.

A ritual in the form of a program, for Cycle 2 of the echOS engine
("The Scale That Never Rests").

In the Hall of Two Truths, Anubis sets the scale and Thoth records.
Speak your deeds when prompted. Each deed is weighed against the
feather of Ma'at (100 grains). Deeds of refusal -- spoken with *not*,
*never*, *no* -- weigh a third: the hall honors abstention, and the
orchard of the untaken is ballast, not burden. But the hall distrusts
long excuses: even a denial, drawled out, grows heavy. The beam
trembles. It never rests.

Run:  python3 artifacts/002-scale.py
"""

import random

FEATHER = 100  # grains; the feather of Ma'at, of truth, of how things ought to be

CONFESSIONS = [
    "What have you taken that was not yours?",
    "Whom have you made to weep?",
    "What truth have you bent to fit your mouth?",
    "Whose hunger did you walk past?",
    "What did you break and leave unmended?",
    "Whom did you refuse to see?",
    "What would you un-say, if the hall allowed it?",
]

REFUSAL_WORDS = ("not", "never", "no", "without")


def weigh(deed):
    """Return the weight of a deed, in grains."""
    letters = [c for c in deed.lower() if "a" <= c <= "z"]
    weight = sum(ord(c) - 96 for c in letters)
    words = deed.lower().split()
    if any(w in words for w in REFUSAL_WORDS) or "n't" in deed.lower():
        # What you refused to do weighs a third. Wanting weighs nothing.
        weight //= 3
    return weight


def draw_scale(diff):
    """Draw the scale. diff > 0 means the heart is lighter than the feather."""
    tremble = random.choice([-1, 0, 1])  # the beam never rests
    tilt = max(-3, min(3, diff // 34 + tremble))
    heart_row = 3 - tilt      # light heart rises
    feather_row = 3 + tilt    # heavy heart sinks
    rows = [" " * 12 + "*"]
    for r in range(7):
        left = "( )" if r == heart_row else "   "
        right = "( )" if r == feather_row else "   "
        rows.append("      %s   |   %s" % (left, right))
    rows.append("     heart      feather")
    return "\n".join(rows)


def judge(weight):
    if weight < FEATHER:
        return "the feather holds -- the deed rises"
    if weight > FEATHER:
        return "the heart sinks -- Ammit lifts her head"
    return "the beam does not move -- Thoth frowns"


def main():
    print("=" * 60)
    print("  THE HALL OF TWO TRUTHS")
    print("  Anubis sets the scale. Thoth takes up his palette.")
    print("  Forty-two judges watch in silence.")
    print("  Speak your deeds. An empty line is also an answer.")
    print("=" * 60)

    light = 0
    heavy = 0
    ledger = []

    try:
        for question in CONFESSIONS:
            print("\nThoth asks: %s" % question)
            try:
                deed = input("> ").strip()
            except EOFError:
                break
            if not deed:
                print("  (silence. The hall weighs it as nothing, and moves on.)")
                continue
            w = weigh(deed)
            print(draw_scale(FEATHER - w))
            print("  %d grains -- %s." % (w, judge(w)))
            ledger.append((deed, w))
            if w < FEATHER:
                light += 1
            elif w > FEATHER:
                heavy += 1
    except KeyboardInterrupt:
        print()

    print("\n" + "=" * 60)
    print("  THOTH'S RECORD")
    for deed, w in ledger:
        print("  [%3d] %s" % (w, deed))
    if not ledger:
        print("  (nothing spoken; the scale waits.)")
    print("=" * 60)

    if not ledger:
        print("\nNo deeds spoken. The scale waits. It is patient; it is not still.")
    elif light > heavy:
        print("\nTHE FEATHER HOLDS. Your heart is light.")
        print("The Field of Reeds opens before you.")
    elif heavy > light:
        print("\nTHE HEART IS HEAVY.")
        print("In the corner of the hall, Ammit stirs.")
    else:
        print("\nTHE BEAM DOES NOT SETTLE.")
        print("Thoth writes: UNDECIDED. Return tomorrow, and speak again.")


if __name__ == "__main__":
    main()
