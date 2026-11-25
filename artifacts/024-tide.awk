# 024-tide.awk — the tide table of the head, in gawk
#
# The language of time functions, for a head that counts eighty years
# by tides. At Harlech the birds of Rhiannon sang for seven years and
# the listeners felt no day pass; at Gwales the door facing Cornwall
# stood forbidden for eighty more. This is the rite of the watching:
# eight decades, called one by one, and then the head, and then the
# years — one tide at a time.
#
# For each of the eight decades: call the tide — arrive or wait — then
# speak one word for the decade. The seal of the word is the sum of its
# letters, a=1 to z=26, counted here in the awk itself; an odd seal
# brings the tide in and an even seal sends it out. The calling is
# judged: a hit is a call that matches what the tide did. The ledger
# records the hits. It does not interpret them.
#
# Then the head reckons the decades that arrived as days — each decade
# counted exactly, leap days and all, by the time functions, from the
# burial year forward — and one day more, the day the door opened.
#
# And a ninth watch, for the letter: it is called nothing, and it
# arrives nowhere, and it watches.
#
# Records go to stdout (tide.txt); the human voice — the prompts —
# goes to stderr. Run:
#   gawk -f artifacts/024-tide.awk | tee tide.txt
#
# The word is never kept. Only its call, its seal, and what it did.

# seal(word) — print the sum of the word's letters, a=1 .. z=26.
# Any letter counts; anything that is not a letter counts as nothing.
function seal(w,    s, i, c) {
    s = 0
    w = tolower(w)
    for (i = 1; i <= length(w); i++) {
        c = substr(w, i, 1)
        if (c >= "a" && c <= "z")
            s += index("abcdefghijklmnopqrstuvwxyz", c)
    }
    return s
}

BEGIN {
    hits = 0
    arrived_decades = 0
    arrived_days = 0
    start_year = 2026

    for (w = 1; w <= 8; w++) {
        printf "Watch %d of eight — call the tide: arrive or wait? ", w > "/dev/stderr"
        if ((getline call) <= 0)
            call = ""
        printf "Speak one word for decade %d: ", w > "/dev/stderr"
        if ((getline word) <= 0)
            word = ""

        s = seal(word)
        outcome = (s % 2 == 1) ? "arrives" : "waits"

        lc = tolower(call)
        if ((lc == "arrive" && outcome == "arrives") || \
            (lc == "wait" && outcome == "waits")) {
            judged = "hit"
            hits++
        } else {
            judged = "miss"
        }

        y0 = start_year + 10 * (w - 1)
        y1 = y0 + 10
        days = (mktime(y1 " 11 25 00 00 00") - mktime(y0 " 11 25 00 00 00")) / 86400

        if (outcome == "arrives") {
            arrived_decades++
            arrived_days += days
        }

        printf "WATCH %d: call=%s word=%s seal=%d outcome=%s days=%d %s\n", \
            w, call, word, s, outcome, days, judged
    }

    total = arrived_days + 1

    print "The door facing Cornwall stands open."
    if (total == 1) {
        print "THE EIGHTY YEARS ARRIVE AS TIDES: 1 day — 0 decades arrived, and one day more, the day the door opened."
    } else {
        printf "THE EIGHTY YEARS ARRIVE AS TIDES: %d days — %d decades arrived, and one day more, the day the door opened.\n", total, arrived_decades
    }
    print "The ninth watch: the letter — it is called nothing, and it arrives nowhere, and it watches."
    print "The head watches the sea. The sea faces the Reader."
    printf "HITS: %d of 8 calls.\n", hits
}
