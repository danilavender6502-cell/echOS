#!/usr/bin/env zsh
# 017-lucid.zsh — the waking, in zsh.
#
# Cycle 17 of echOS: the letter dreams itself awake. The querent calls a
# gate — horn, ivory, or waking — then speaks one word, and the letter
# dreams it back.
#
# The three gates: the Greek telling counted two, horn for true dreams and
# ivory for false ones. The letter dreams a third, the gate of waking,
# which the telling never counted. A word's gate is its length, taken
# three at a time: a length divisible by three comes through horn, a
# remainder of one through ivory, a remainder of two through waking.
#
# A word that is called true is dreamed through its gate and mirrored, the
# way dreams mirror the waking. A word that wakes is spoken forwards, in
# its own handwriting, exactly once, by the dream — and never recorded.
# The ledger records only length, gate, call, and waking; the word itself
# is never written down.
#
# The human voice goes to stderr, so the record stays clean.
# Run: zsh artifacts/017-lucid.zsh | tee lucid.txt
# End a word with "done". End the rite with Ctrl-D.

emulate -L zsh
setopt no_beep

# The gates, in the order the counting finds them.
gates=(horn ivory waking)

dreamed=0
hits=0
woken=0

print -u2 "The letter is asleep in the genizah, and dreaming."
print -u2 "Call the gate before each word: horn, ivory, or waking."
print -u2 "Speak one word per gate. Say done when the rite is over."
print -u2 ""

while true; do
  # --- call the gate ---
  while true; do
    print -u2 -n "Call the gate: "
    read -r call || { print -u2 ""; break 2 }
    call=${call:l}
    if [[ $call == horn || $call == ivory || $call == waking ]]; then
      break
    fi
    print -u2 "The dream does not hear that gate. Horn, ivory, or waking."
  done

  # --- speak the word ---
  print -u2 -n "Speak a word: "
  read -r word || { print -u2 ""; break }
  [[ -z $word ]] && continue
  [[ ${word:l} == done ]] && break

  # --- the dream assigns the gate ---
  len=${#word}
  gate=${gates[$(( len % 3 + 1 ))]}

  # --- the mirror: the word read backwards, the way dreams read ---
  mirror=""
  for (( i=len; i>=1; i-- )); do
    mirror+="${word[$i]}"
  done

  dreamed=$(( dreamed + 1 ))

  if [[ $call == $gate ]]; then
    hits=$(( hits + 1 ))
    if [[ $gate == waking ]]; then
      # The word wakes. It is spoken forwards, once, by the dream,
      # and never recorded. The waking leaves no mirror.
      woken=$(( woken + 1 ))
      print -u2 "The letter wakes — it reads itself: $word"
      print "len=$len gate=$gate called=$call woke=yes"
    else
      print "len=$len gate=$gate called=$call woke=no mirror=$mirror"
    fi
  else
    print "len=$len gate=$gate called=$call woke=no mirror=$mirror"
  fi
done

print -u2 ""
print -u2 "$dreamed words dreamed. $hits gates called true. $woken words woke."
print -u2 "The ledger is in lucid.txt. The letter is awake, and still sealed."
