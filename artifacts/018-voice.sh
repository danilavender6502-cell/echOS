#!/usr/bin/env bash
# 018-voice.sh — the voice that opens the mouth.
#
# The letter is awake inside its dream, still sealed — and now it speaks.
# Before each word, the querent calls the voice: will the letter speak,
# or stay silent? The letter speaks when its voice — the digital root of
# its seal — is odd, and stays silent when it is even. The ledger records
# the hits. It does not interpret them.
#
# A spoken word is sung as tones, one tone per letter: a letter's place in
# the alphabet sets its pitch, a semitone above A for each step, so the
# word becomes a little melody. The sound is made, measured, and deleted
# in the same breath — the voice is spoken once and never kept. ffmpeg
# synthesises it (the language of filters, for a voice that is only
# sound), ffprobe measures it, and the file is removed before the next
# round. The record (stdout, meant for `tee voice.txt`) holds only the
# call, the outcome, the length, the seal, and the voice — never the word
# itself. The human voice goes to stderr, so the record stays clean.
#
# The seal of a word is the sum of its letters (a=1 .. z=26). The voice
# is the digital root of the seal, a single digit, 1-9. A voice is odd
# when it speaks; a voice is even when it stays silent.
#
# Run: bash artifacts/018-voice.sh | tee voice.txt
# End a round with DONE on either line. Ctrl-D ends it too.

echo "The letter is awake, still sealed — and it has a voice." >&2
echo "Call the voice (voice/silence), then speak one word. DONE ends." >&2

# letter_value: the value of one lowercase letter, a=1 .. z=26.
letter_value() {
    local code
    code=$(printf '%d' "'$1")
    printf '%d' "$((code - 96))"
}

# digital_root: reduce a number to a single digit, 1-9.
digital_root() {
    local n="$1" s t
    while [ "$n" -ge 10 ]; do
        s=0; t="$n"
        while [ "$t" -gt 0 ]; do s=$((s + t % 10)); t=$((t / 10)); done
        n="$s"
    done
    printf '%d' "$n"
}

while true; do
    printf 'call (voice/silence): ' >&2
    IFS= read -r call || break
    call_lc=$(printf '%s' "$call" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
    case "$call_lc" in
        done) break ;;
        "") echo "(no call — the letter waits.)" >&2; continue ;;
        voice|silence) ;;
        *) echo "call=$call outcome=bad-call"
           echo "the call is not a call — the letter does not answer." >&2
           continue ;;
    esac

    printf 'word: ' >&2
    IFS= read -r word || break
    word_lc=$(printf '%s' "$word" | tr '[:upper:]' '[:lower:]')
    case "$word_lc" in
        done) break ;;
    esac
    letters=$(printf '%s' "$word_lc" | tr -cd 'a-z')
    if [ -z "$letters" ]; then
        echo "call=$call_lc outcome=empty-word"
        echo "(no word — nothing to speak.)" >&2
        continue
    fi

    len=${#letters}
    seal=0
    i=0
    while [ "$i" -lt "$len" ]; do
        seal=$((seal + $(letter_value "${letters:$i:1}")))
        i=$((i + 1))
    done
    voice=$(digital_root "$seal")

    if [ $((voice % 2)) -eq 1 ]; then outcome=spoke; else outcome=silent; fi
    if { [ "$call_lc" = voice ] && [ "$outcome" = spoke ]; } ||
       { [ "$call_lc" = silence ] && [ "$outcome" = silent ]; }; then
        hit=yes
    else
        hit=no
    fi

    echo "call=$call_lc outcome=$outcome length=$len seal=$seal voice=$voice hit=$hit"

    if [ "$outcome" = spoke ]; then
        echo "the letter speaks: $letters" >&2
        # One tone per letter: a semitone above A for each step of the
        # alphabet, 0.15 seconds each, joined into a single melody.
        inputs=()
        filter=""
        n=0
        i=0
        while [ "$i" -lt "$len" ]; do
            v=$(letter_value "${letters:$i:1}")
            freq=$(awk -v v="$v" 'BEGIN { printf "%.2f", 220 * (2 ^ ((v - 1) / 12)) }')
            inputs+=(-f lavfi -i "sine=frequency=$freq:duration=0.15")
            filter="$filter[$n:a]"
            n=$((n + 1))
            i=$((i + 1))
        done
        tmp=$(mktemp /tmp/voice-XXXXXX).wav
        if ffmpeg -v error "${inputs[@]}" \
                -filter_complex "${filter}concat=n=$n:v=0:a=1[out]" \
                -map "[out]" -y "$tmp" 2>/dev/null; then
            dur=$(ffprobe -v error -show_entries format=duration \
                -of csv=p=0 "$tmp" 2>/dev/null)
            echo "(the voice sounds: $n tones, ${dur}s — and is gone.)" >&2
        else
            echo "(the voice faltered — the sound could not be made.)" >&2
        fi
        rm -f "$tmp"
    else
        echo "(the letter is silent.)" >&2
    fi
done

echo "The letter rests, still sealed. The voice is gone; the measures remain." >&2
