#!/usr/bin/env perl
# 004-mala.pl — the mālā of the engine.
#
# 108 beads; the 109th (Sumeru, the guru bead) is not counted, only turned
# around at. Before each round, call the slip: the bead (0..107) where the
# careful finger will stumble anyway. A small Rhine test, the tray's
# grandchild. The mālā records the hits. It does not interpret them.
use strict;
use warnings;

my $BEADS = 108;

sub digital_root {
    my ($n) = @_;
    return $n == 0 ? 0 : 1 + (($n - 1) % 9);
}

sub prompt {
    my ($text) = @_;
    print $text;
    my $line = <STDIN>;
    return '' unless defined $line;
    chomp $line;
    return $line;
}

print "The mālā of the engine: 108 beads, and the one that is not counted.\n";
print "The language of strings, for a string of beads.\n\n";

my $rounds_in = prompt("How many rounds will you walk? [1] ");
my $rounds = ($rounds_in =~ /^\d+$/ && $rounds_in > 0) ? $rounds_in : 1;

my ($hits, $called) = (0, 0);

for my $r (1 .. $rounds) {
    my $way = $r % 2 ? "sunwise" : "widdershins";
    print "\n— round $r, walking $way —\n";

    my $call = prompt("Call the slip: which bead (0-107) will the finger stumble on? ");
    my $has_call = $call =~ /^\d+$/ && $call >= 0 && $call < $BEADS;
    $called++ if $has_call;
    my $slip = int(rand($BEADS));

    my $counted = 0;
    for my $b (0 .. $BEADS - 1) {
        $counted++;
        if ($counted % 9 == 0) {
            printf "  bead %3d · digital root %d%s\n", $b,
                digital_root($counted),
                digital_root($counted) == 9 ? " — the root of completion" : "";
        }
    }

    print "The 109th bead — Sumeru. It is not counted.\n";
    my $word = prompt("Lay down the unspoken (or leave it empty): ");
    print "The bead keeps it. The mālā turns.\n";

    if ($has_call) {
        if ($call == $slip) {
            $hits++;
            print "The slip fell at bead $slip. You called $call. A hit — recorded.\n";
        } else {
            print "The slip fell at bead $slip. You called $call. Recorded.\n";
        }
    } else {
        print "No call was made. The slip fell at bead $slip. Recorded.\n";
    }
}

print "\nRounds walked: $rounds. Slips called: $called. Hits: $hits.\n";
print "The mālā does not interpret. Some numbers are for recording only.\n";
printf "Beads counted in all: %d (digital root %d).\n",
    $rounds * $BEADS, digital_root($rounds * $BEADS);
print "The unspoken words rest at the bead that is not counted.\n";
