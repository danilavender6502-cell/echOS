#!/usr/bin/awk -f
# 007-gates.awk -- the gatekeeper's ledger
#
# Cycle 7 of echOS: the descent of Inanna to the Kur.
# Seven gates. At each gate the querent CALLS THE GARMENT -- which of the
# seven me will this gate take? -- then surrenders a word to leave with it.
# The ledger strips the word bare (the vowels stay in the Kur) and hangs the
# whole word on the hook. At the seventh gate: death. Then Enki's creatures,
# pinched from the dirt under his fingernails, revive the dead with the food
# of life and the water of life, and the garments are walked back up the
# seven gates in reverse order.
#
# The Kur of the engine shuffles its tolls; the myth's order is not kept.
# The call-the-garment hits are recorded, never interpreted.
#
# Run: awk -f artifacts/007-gates.awk

function ask(prompt,    ans) {
    printf "%s", prompt > "/dev/stderr"
    if ((getline ans < "/dev/stdin") > 0) return ans
    return ""
}

function strip(s) {
    gsub(/[aeiouAEIOU]/, "", s)
    if (s == "") s = "(bare)"
    return s
}

function rev(s,    r, i) {
    r = ""
    for (i = length(s); i >= 1; i--) r = r substr(s, i, 1)
    return r
}

BEGIN {
    srand()

    g[1] = "the shugurra crown of the steppe"
    g[2] = "the lapis measuring rod and line"
    g[3] = "the lapis beads of the neck"
    g[4] = "the twin stones of the breast"
    g[5] = "the breastplate"
    g[6] = "the gold ring"
    g[7] = "the royal robe"

    n = 7
    for (i = 1; i <= 7; i++) rem[i] = i

    print ""
    print "  THE GATEKEEPER'S LEDGER"
    print "  seven gates of the Kur -- neti keeps the book"
    print ""
    print "  From the great above she opened her ear to the great below."
    print "  You go down in her place. The gates take their toll."
    print ""

    hits = 0
    for (gate = 1; gate <= 7; gate++) {
        print "  -- gate " gate " of seven --"
        print "  remaining me:"
        for (i = 1; i <= n; i++)
            printf "    %d. %s\n", i, g[rem[i]]

        call = ask("  Call the garment (1-" n ", or 0 to pass): ")
        called = 0
        if (call ~ /^[0-9]+$/ && call >= 1 && call <= n) called = call
        else if (call != "" && call != "0")
            print "  (the ledger notes the silence; no call recorded)"

        k = int(rand() * n) + 1
        taken = rem[k]
        if (called == k) {
            hits++
            print "  the gate nods. a hit -- recorded, never interpreted."
        } else if (called > 0) {
            print "  the gate takes no notice of your call."
        }
        for (i = k; i < n; i++) rem[i] = rem[i+1]
        n--

        word = ask("  The gate takes " g[taken] ".\n  Surrender a word to leave with it: ")
        if (word == "") word = "unsaid"
        toll[gate] = g[taken]
        bare[gate] = strip(word)
        hook[gate] = word
        print "  the gate opens. the vowels stay in the Kur."
        print ""
    }

    print "  -- the seventh gate is behind you --"
    print ""
    print "  Ereshkigal fastens on you the eye of death."
    print "  She speaks against you the word of wrath."
    print "  You are hung on a hook, a corpse, three days and three nights."
    print ""
    print "  THE HOOK:"
    for (gate = 1; gate <= 7; gate++)
        printf "    gate %d: %s\n", gate, rev(hook[gate])
    print "  (hung upside down, as is customary)"
    print ""

    print "  Above, your attendant counts the days and begs the gods."
    print "  Enki pinches the kurgarra and the galatur"
    print "  from the dirt under his fingernails and sends them down."
    food = ask("  Give them the food of life (a word): ")
    if (food == "") food = "bread"
    water = ask("  Give them the water of life (a word): ")
    if (water == "") water = "water"
    print ""
    print "  They slip past the gates. They offer " food " and " water "."
    print "  You sit up. The ascent begins -- garments returned in reverse."
    print ""
    for (gate = 7; gate >= 1; gate--) {
        printf "  gate %d gives back %s;\n", gate, toll[gate]
        printf "    beside it lies '%s' -- what the gates strip, the gates keep.\n", bare[gate]
    }
    print ""
    print "  THE LEDGER, CLOSED:"
    for (gate = 1; gate <= 7; gate++)
        printf "    gate %d took %-38s left: %s\n", gate, toll[gate], bare[gate]
    printf "  call-the-garment: %d of 7 hits -- recorded, never interpreted.\n", hits
    print ""
    print "  No lock returns its passer whole."
    print ""
    exit 0
}
