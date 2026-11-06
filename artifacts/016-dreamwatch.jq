# 016-dreamwatch.jq — the dream-watch, in jq.
#
# The language of filters, for a dream that filters what the keeper is.
# The keeper sleeps. The kept watches. Each round the querent calls a gate
# — horn or ivory — then speaks one word. The kept dreams the word back:
# its length, its seal (the sum of its letters), its gate, and its mirror
# (the word read backwards, the way dreams read the waking).
#
# The gate of horn is the gate of true dreams; the gate of ivory, of false.
# Even seals arrive through horn; odd seals through ivory. A hit is a
# called gate the dream arrives through. Hits are recorded and never
# interpreted. The word itself is never written down — only its mirror,
# its measurements, and the gate it came through.
#
# Run:  jq -R -n -f artifacts/016-dreamwatch.jq | tee dreamwatch.jsonl
# Type a call (horn or ivory), then a word, call, word...; type "done"
# to wake the keeper and print the tally. End with Ctrl-D if you forget.
# An empty line is ignored. A call the dream does not know is ignored.
# Records go to stdout (and the record file); the human voice goes to
# stderr, so the record stays pure JSON.

def rev: explode | reverse | implode;

def dream($w):
  (($w | explode | add) // 0) as $seal
  | {
      length: ($w | length),
      seal: $seal,
      parity: (if $seal % 2 == 0 then "even" else "odd" end),
      gate: (if $seal % 2 == 0 then "horn" else "ivory" end),
      mirror: ($w | rev)
    };

# Prologue, to stderr, so the record file stays pure JSON.
("The dream-watch begins. The keeper sleeps; the kept watches."
  | debug | empty),
("Call a gate — horn or ivory — then speak one word. Type \"done\" to wake him."
  | debug | empty),

foreach inputs as $line (
  {call: null, round: 0, hits: 0, dreams: 0, asleep: false, last: null};
  if .asleep then .last = null
  elif $line == "done" then
    .asleep = true
    | .last = {waking: true, rounds: .round, hits: .hits, dreams: .dreams}
  elif .call == null then
    if $line == "horn" or $line == "ivory" then .call = $line | .last = null
    else .last = null end
  elif ($line | length) == 0 then .last = null
  else
    (.call) as $c
    | (dream($line)) as $d
    | .round += 1
    | .dreams += 1
    | .hits += (if $c == $d.gate then 1 else 0 end)
    | .last = ({round: .round, called: $c} + $d
               + {hit: ($c == $d.gate), hits: .hits, dreams: .dreams})
    | .call = null
  end;
  (.last // empty) as $r
  | (
      (if ($r | has("waking")) then
         "The keeper wakes. \($r.rounds) round\(if $r.rounds == 1 then "" else "s" end) dreamed, \($r.hits) gate\(if $r.hits == 1 then "" else "s" end) called true. The record stands; it is not read."
       else
         "Round \($r.round): the kept dreams \"\($r.mirror)\" — seal \($r.seal), gate of \($r.gate), called \($r.called)."
       end) | debug | empty
    ), $r
)
