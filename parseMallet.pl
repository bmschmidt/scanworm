#!/usr/bin/perl

use strict;


#This file opens a zipped MALLET state file, pulls out the relevant information for a Bookworm, and 
#Writes it to 

my $file = "models/large-state.gz";

open (MODEL, "gunzip -c $file|") or die $!;

#It's a fifo, so nothing will actually exist here until mysql tries to read it in.
system("rm /tmp/wordcounts.txt") or print "";
system("mkfifo -m 0666 /tmp/wordcounts.txt");
open (WORDCOUNTS, "> /tmp/wordcounts.txt");


my $lineno = 1;
my $lasttext = "";
my %thiscounts;

open(DICT,'Presidio/files/texts/wordlist/wordlist.txt');
my %wordids;
my $i = 1;
while (my $dictEntry = <DICT>) {
    my @splat = split(/\t/,$dictEntry);
    $wordids{$splat[1]} = $splat[0];
}

open(DICT,'Presidio/files/texts/textids/new');
my %textids;
my $i = 1;
while (my $dictEntry = <DICT>) {
    chomp $dictEntry;
    my @splat = split(/\t/,$dictEntry);
    $textids{$splat[1]} = $splat[0];
}





while (my $line = <MODEL>) {
    if ($line =~ m/^[^#]/) {
	my ($doc, $source, $pos, $typeindex, $type,$topic) = split (" ",$line);
	if ($lasttext ne $doc) {
	    $textids{$doc} = $source;
	    while ( my ($key,$value) = each (%thiscounts) ) {
		print WORDCOUNTS $key . "\t" . $value . "\n" if $value > 0;
	    }
	    %thiscounts = {};
	}
	$wordids{$typeindex} = $type;
	$source =~ s/.*texts\/(.*).txt/$1/g;
	$thiscounts{$textids{$source} . "\t" . $wordids{$type} . "\t" . $topic} += 1;
	$lasttext = $doc;
    }
    $lineno++;
}


