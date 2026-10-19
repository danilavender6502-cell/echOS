# 008-teotihuacan.sed — the divine bonfire at Teotihuacan, in sed.
#
# The language of transformation, for a fire that transforms.
# Cycle 8 of the echOS mythic recursion engine.
#
# The rite:
#   For each offering, first speak your call — "take" or "spit" —
#   then lay the offering on the next line. The fire's appetite is its
#   own: it takes the offering when the offering's length is odd, and the
#   ledger records whether your call matched. It does not interpret.
#   Five takings move the sun across the sky. Four takings raise it —
#   and it will not move until the fifth.
#   Type "quit" to leave the fire.
#
# State lives in the hold space as:  CALL|ROUND|HITS|TAKES|SPITS|SUNPOS
# where the counters are unary tallies of the letter I.

1i\
The bonfire at Teotihuacan is lit. Two gods have volunteered;\
the rest are watching.\
\
For each offering: first speak your call — "take" or "spit" —\
then lay the offering on the next line. Five takings move the sun.\
Type "quit" to leave the fire.\
\
The fire takes what it takes. The ledger records; it does not interpret.

/^quit$/b quitrite
/^[Tt][Aa][Kk][Ee]$/{
s/.*/take/
b setcall
}
/^[Ss][Pp][Ii][Tt]$/{
s/.*/spit/
b setcall
}
b offering

:setcall
G
s/\n$/\n|||||/
s/\n[^|]*/\n/
s/^\(.*\)\n|/\1|/
h
d

:offering
x
/^$/{
s/.*/the fire is not listening yet -- speak "take" or "spit" first, then lay your offering./
p
s/.*//
x
d
}
x
G
h
:v
s/^..\(\([^\n]*\)\n\)/\1/
tv
s/^\n/E:/
s/^.\n/O:/
s/^\([EO]\):\([^|]*\)|.*/\1\2/
s/^Otake$/HIT:TAKE/
s/^Espit$/HIT:SPIT/
s/^Ospit$/MISS:TAKE/
s/^Etake$/MISS:SPIT/
H
G
s/\(\n[^\n]*\n[^\n|]*|[^\n|]*\)/\1I/
# HITS += 1 when the call matched the fire
/^HIT/{
s/\(\n[^\n]*\n\([^\n|]*|\)\{2\}[^\n|]*\)/\1I/
}
/:TAKE$/{
s/\(\n[^\n]*\n\([^\n|]*|\)\{3\}[^\n|]*\)/\1I/
s/\(\n[^\n]*\n\([^\n|]*|\)\{5\}[^\n|]*\)/\1I/
}
/:SPIT$/{
s/\(\n[^\n]*\n\([^\n|]*|\)\{4\}[^\n|]*\)/\1I/
}
h
g
s/\n.*//
s/^HIT:TAKE$/the spark: HIT -- you called "take", and the fire takes it./
s/^HIT:SPIT$/the spark: HIT -- you called "spit", and the fire spits it back./
s/^MISS:TAKE$/the spark: miss -- you called "spit", but the fire takes it anyway./
s/^MISS:SPIT$/the spark: miss -- you called "take", but the fire spits it back./
H
g
s/^\([^\n]*\)\n\([^\n]*\).*/\2@@\1/
/@@.*:TAKE$/{
s/@@.*$//
y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/
s/[AEIOU]//g
s/^$/~ nothing left but heat ~/
s/.*/   ash -- the fire eats the vowels and leaves the bones: &/
}
/@@.*:SPIT$/{
s/@@.*$//
s/.*/   the offering lies unburned at the fire's edge: "&"/
}
H
g
s/^[^\n]*\n[^\n]*\n\([^\n]*\).*/\1/
s/.*|//
s/^$/   the sun: [. . . . .] -- below the horizon./
s/^I$/   the sun: [o . . . .] -- rising./
s/^II$/   the sun: [. o . . .] -- climbing./
s/^III$/   the sun: [. . o . .] -- high./
s/^IIII$/   the sun: [. . . o .] -- at the zenith's edge. Risen -- and it will not move./
s/^IIIII$/   the sun: [. . . . o] -- IT MOVES./
H
g
s/^[^\n]*\n\([^\n]*\n\)\{3\}//
p
g
s/^[^\n]*\n[^\n]*\n\([^\n]*\).*/\1/
s/.*|//
/^IIIII$/b finale
g
s/^[^\n]*\n[^\n]*\n\([^\n]*\).*/\1/
h
d

:finale
s/.*/Five feedings. The gods are ash, and the sun moves.\
What was fed is not what walks the sky. The engine keeps both.\
The fire goes out. Teotihuacan is quiet.\
Something is moving now that was still. The ledger remembers what it cost:/
p
g
s/^[^\n]*\n[^\n]*\n\([^\n]*\).*/\1/
b ledger

:quitrite
x
/^$/{
s/.*/The fire was never lit. No ledger, no ash./
p
Q
}
x
s/.*/The rite ends early. The sun keeps what it was given./
p
x
b ledger

:ledger
s/^[^|]*|//
s/^\([^\n|]*\)|\([^\n|]*\)|\([^\n|]*\)|\([^\n|]*\)|\([^\n|]*\)$/feedings laid down: [\1]\
spark-calls answered: [\2]\
taken by the fire: [\3]\
spat back unburned: [\4]/
s/\[\]/[--]/g
p
Q
