#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);

# Purpose: Transcribe & translate DNA into its corresponding protein.

sub translation {
	
	# input sequence
	my $sequence = shift;
	
	# Translation table
	my %translation_table = (
						"UUU" => "F",	"UCU" => "S",	"UAU" => "Y",		"UGU" => "C",
						"UUC" => "F",	"UCC" => "S",	"UAC" => "Y",		"UGC" => "C",
						"UUA" => "L",	"UCA" => "S",	"UAA" => "STOP",	"UGA" => "W",
						"UUG" => "L",	"UCG" => "S",	"UAG" => "STOP",	"UGG" => "W",
						"CUU" => "L",	"CCU" => "P",	"CAU" => "H",		"CGU" => "R",
						"CUC" => "L",	"CCC" => "P",	"CAC" => "H",		"CGC" => "R",
 						"CUA" => "L",	"CCA" => "P",	"CAA" => "Q",		"CGA" => "R",
						"CUG" => "L",	"CCG" => "P",	"CAG" => "Q",		"CGG" => "R",
						"AUU" => "I",	"ACU" => "T",	"AAU" => "N",		"AGU" => "S",
						"AUC" => "I",	"ACC" => "T",	"AAC" => "N",		"AGC" => "S",
						"AUA" => "M",	"ACA" => "T",	"AAA" => "K",		"AGA" => "STOP",
						"AUG" => "M",	"ACG" => "T",	"AAG" => "K",		"AGG" => "STOP",
						"GUU" => "V",	"GCU" => "A",	"GAU" => "D",		"GGU" => "G",
						"GUC" => "V",	"GCC" => "A",	"GAC" => "D",		"GGC" => "G",
						"GUA" => "V",	"GCA" => "A",	"GAA" => "E",		"GGA" => "G",
						"GUG" => "V",	"GCG" => "A",	"GAG" => "E",		"GGG" => "G"
						);

	# transcribe the $sequence to an RNA sequence.
	$sequence =~ s/T/U/g;
	my $rna_seq = $sequence;

	# Split into an array containing sequence in 3 letter elements.
	my @codons;
	
	# for loop designed to go to every third letter and stop at a number thats
	# divisible by 3. Assign each codon to the @codon array.
	for (my $i = 0; $i < length($sequence) - 2; $i += 3) {
		my $codon = substr($rna_seq, $i, 3);
		push @codons, $codon;
		$codon = "";
	}
	
	# Loop thru the array (as you would the keys) and grab the according values.
	my @protein;
	foreach my $i (@codons) {
		push @protein, $translation_table{$i};
		last if $translation_table{$i} eq "STOP";
	}
	my $final = join('', @protein);
	return $final;
}

my $seq = "AAAAUUUTTT";

my $fin = translation($seq);
say $fin;
