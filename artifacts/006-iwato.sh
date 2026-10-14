#!/usr/bin/env bash
# 006-iwato.sh -- the cave, the mirror, and the laugh.
# An interactive luring-of-the-dawn, after the myth of Ama-no-Iwato:
# the sun hides in the rock cave, and the gods open the door
# with a mirror, a dance, and laughter. Run:
#   bash artifacts/006-iwato.sh

ask() {
  printf '%s ' "$1" >&2
  IFS= read -r reply || reply=""
  printf '%s' "$reply"
}

echo "THE CAVE, THE MIRROR, AND THE LAUGH"
echo "Ama-no-Iwato: the sun has hidden in the rock cave of heaven."
echo "You are the eight hundred myriad gods. Open the door."
echo

light=0
darkness=8

# -- 1. The boulder -------------------------------------------------------
echo "[1] The boulder."
echo "The cave mouth stands open; the sun hesitates at the threshold."
r=$(ask "Roll the boulder across the mouth? (roll)")
case "$r" in
  roll*|ROLL*) echo "The boulder rolls. Darkness: $darkness." ;;
  *)           echo "You hesitate; the gods roll it for you. Darkness: $darkness." ;;
esac
echo

# -- 2. The jewel ---------------------------------------------------------
echo "[2] The jewel."
r=$(ask "Hang the jewel on the sakaki branch? (hang)")
case "$r" in hang*|HANG*) light=$((light+1)) ;; esac
echo "The jewel catches what little light is left. Light: $light."
echo

# -- 3. The mirror --------------------------------------------------------
echo "[3] The mirror."
r=$(ask "Raise the mirror at the cave mouth? (raise)")
case "$r" in raise*|RAISE*) light=$((light+1)) ;; esac
echo "The mirror faces the dark, patient. Light: $light."
echo

# -- 4. The dance and the call-the-laugh test -----------------------------
echo "[4] The dance."
echo "The tub is upturned. Ame-no-Uzume dances."
echo "Before each round, CALL THE LAUGH: which quarter of the myriad"
echo "gods -- east, south, west, north -- will laugh first?"
quarters="east south west north"
hits=0
rounds=8
i=1
while [ "$i" -le "$rounds" ]; do
  call=$(ask "Round $i -- your call:")
  call=$(printf '%s' "$call" | tr 'A-Z' 'a-z')
  # the tub draws: one quarter at random
  drawn=$(printf '%s' "$quarters" | tr ' ' '\n' | shuf -n 1)
  if [ "$call" = "$drawn" ]; then
    hits=$((hits+1))
    echo "  The $drawn quarter laughs first. A hit -- recorded, not interpreted."
  else
    echo "  The $drawn quarter laughs first. Recorded."
  fi
  light=$((light+1))
  i=$((i+1))
done
echo "The myriad gods are laughing now. Light: $light."
echo

# -- 5. The curiosity -----------------------------------------------------
echo "[5] The curiosity."
echo "Inside the dark, the sun hears laughter -- joy without her --"
echo "and slides the boulder a finger's width to see."
echo "In the mirror: her own face."
echo

# -- 6. The rope ----------------------------------------------------------
echo "[6] The rope."
r=$(ask "Stretch the shimenawa across the mouth, so she can never hide again? (stretch)")
case "$r" in stretch*|STRETCH*) light=$((light+1)) ;; esac
echo
echo "Light: $light. The sun steps out."
echo "The cave is empty now, and the rope holds the door."
echo "Call-the-laugh: $hits of $rounds -- the cave keeps the number and says nothing."
