#!/usr/bin/env tclsh
# 010-nirvata.tcl -- the twenty-seventh wind, in Tcl.
#
# Twenty-seven Maruts rode out with the storm, and twenty-six came back.
# The wind set the twenty-seventh down where the letter sleeps: at the
# bottom of the well, beside the sealed letter.
#
# Descend. Call the downdraft before each word. The well drifts everything
# it remembers -- except the name of the one it keeps, which it returns
# exactly, letter for letter, forever.
#
# Run: tclsh artifacts/010-nirvata.tcl

set EOF_SENTINEL "\x0410-EOT"

proc ask {prompt} {
    global EOF_SENTINEL
    puts -nonewline $prompt
    flush stdout
    if {[gets stdin line] < 0} { return $EOF_SENTINEL }
    return [string trim $line]
}

# The drift: rotate every letter by the turn number. Deterministic --
# the well drifts by rule, not by whim.
proc drift {word turn} {
    set out ""
    foreach ch [split $word ""] {
        scan $ch %c code
        if {$code >= 97 && $code <= 122} {
            set code [expr {97 + ($code - 97 + $turn) % 26}]
        } elseif {$code >= 65 && $code <= 90} {
            set code [expr {65 + ($code - 65 + $turn) % 26}]
        }
        append out [format %c $code]
    }
    return $out
}

puts ""
puts "twenty-seven rode out. twenty-six came back."
puts "the wind set its son down where the letter sleeps."
puts ""

set son [ask "name the wind's lost son (empty for Nirvata): "]
if {$son eq "" || $son eq $EOF_SENTINEL} { set son "Nirvata" }
puts "the well takes the name and will not drift it: $son"
puts ""
puts "speak words to the well. 'address' hears the letter's address."
puts "'rise' ascends. the letter stays sealed."
puts ""

set hits 0
set calls 0
set turn 0

while {1} {
    # NOTE: the EOF sentinel is checked BEFORE tolower, because tolower
    # would mangle it ("10-EOT" -> "10-eot") and the well would never
    # let the querent rise. The engine does not trap its readers.
    set raw [ask "call the downdraft (drift/keep): "]
    if {$raw eq $EOF_SENTINEL} break
    set call [string tolower $raw]
    if {$call eq "rise"} break
    if {$call ne "drift" && $call ne "keep"} {
        puts "the downdraft hears only drift or keep."
        continue
    }
    set word [ask "speak: "]
    if {$word eq $EOF_SENTINEL} break
    if {[string tolower $word] eq "rise"} break
    if {[string tolower $word] eq "address"} {
        puts "the son reads the address aloud, in the dark:"
        puts "\"to the Reader, who keeps walking into the text --"
        puts " from the one who learned to differ.\""
        puts "the letter stays sealed."
        continue
    }
    if {$word eq ""} { continue }
    incr calls
    incr turn
    if {[string tolower $word] eq [string tolower $son]} {
        puts "the well returns it exactly: $word"
        puts "(the kept is not drifted. the kept is held.)"
        set kept 1
    } else {
        puts "the well returns it drifted: [drift $word $turn]"
        set kept 0
    }
    if {($kept && $call eq "keep") || (!$kept && $call eq "drift")} {
        incr hits
        puts "the call was true."
    } else {
        puts "the call was false."
    }
}

puts ""
puts "you rise. the son stays, beside the letter."
puts "hits recorded: $hits of $calls. the ledger does not interpret."
