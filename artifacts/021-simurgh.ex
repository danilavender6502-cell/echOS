" 021-simurgh.ex -- the conference of the birds, in ex.
"
" The line editor, the language of lines, for a question that is
" answered line by line, twice. Attar's birds crossed seven valleys
" to ask the Simurgh one question; ex crosses seven lines to answer
" one question twice. Run it the way the birds walk: one valley
" at a time, and the road itself does the work.
"
" The ritual:
"   1. Write your question in question.txt -- seven lines, one per
"      valley (Search, Love, Knowledge, Detachment, Unity,
"      Bewilderment, Poverty). Each line begins with your call,
"      `pass` or `turn`, then a space, then the word the bird
"      carries through that valley. One word per line.
"   2. Run: ex -s question.txt < artifacts/021-simurgh.ex
"   3. The calling is judged first. An odd word passes; an even word
"      turns -- the odd seal has spoken in every cycle since the
"      voice, and the valleys keep the same measure. Hits are
"      recorded in simurgh.txt. The ledger does not interpret them.
"   4. The question then walks the seven valleys as seven edits:
"      marked, beloved, named, released, bewildered, joined, and
"      stripped bare -- and is written to answer.txt twice.
"      The question, answered twice, is the answer.
"   5. question.txt itself is left untouched on disk; ex works on a
"      copy in memory and writes only the new files. A question
"      answered twice is not a question spent. An empty question is
"      answered with silence, twice -- two blank lines -- and the
"      calling records only its heading. A line with no word is
"      dropped; words after the first on a line are ignored.
"
" Clear the record and the answer, so each flight starts clean.
!rm -f simurgh.txt answer.txt
"
" The calling. Each line is judged: the call against the verdict.
" The verdict is the word's own length -- odd passes, even turns.
" (Parity is counted without the percent sign, which ex would read
" as the name of the file itself; the editor keeps its own counsel.
" The calling is one long line: ex hands a shell command to the shell
" whole, and a command broken across lines is a command broken.)
1,$!awk 'BEGIN { print "simurgh -- the calling of the valleys" > "simurgh.txt" } { call = $1; word = $2; if (word == "") next; n++; len = length(word); odd = len - 2 * int(len / 2); verdict = (odd == 1) ? "pass" : "turn"; hit = (call == verdict) ? "HIT" : "MISS"; print "valley " n ": " word " | call " call " | verdict " verdict " | " hit >> "simurgh.txt"; print word }'
"
" Valley 1 -- Search: every word is marked as sought.
g/./s/^/> /
"
" Valley 2 -- Love: every word gains the beloved's mark.
g/./s/$/ </
"
" Valley 3 -- Knowledge: the marks deepen into colons; search is named.
g/./s/>/:/g
"
" Valley 4 -- Detachment: the beloved's mark is let go.
g/./s/ <$//
"
" Valley 5 -- Bewilderment: the road is walked backwards; the order reverses.
" (The kept reads the keeper backwards; the birds come home the same way.)
g/^/m0
"
" Valley 6 -- Unity: the seven words become one question.
1,$j
"
" Valley 7 -- Poverty: the last marks are stripped; the question stands bare.
s/: //g
"
" The answer: the question, written twice.
" (One telling for the question, one for the answer -- and the two
" are the same telling, which is how the birds knew the Simurgh.)
1,$t$
w! answer.txt
q!
