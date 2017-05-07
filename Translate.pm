# Translate.pm
# 
# Module takes in a capitalized DNA sequences
# by Leinal A. Sejour
#

package Translate;
use strict;
use warnings;

our $VERSION = "0.1";
#our @EXPORT = ();
#our @EXPORT_OK = qw(new translation);

sub new
{
    my $class = shift;
    my $self  = {};

    bless( $self, $class );
    return $self;
}

sub transcription 
{
	my ($self, $seq) = @_;
	
	# transcribe the $sequence to an RNA sequence.
	my $sequence = uc $seq;
	$sequence =~ s/T/U/g;
	
	# Object values
    $self->{sequence} = $sequence if defined $sequence;
    return $self->{sequence};
}

sub translation
{
    my ($self, $sequence) = @_;
    
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

	# Split into an array containing sequence in 3 letter elements.
	my @codons;
	
	# for loop designed to go to every third letter and stop at a number thats
	# divisible by 3. Assign each codon to the @codon array.
	for (my $i = 0; $i < length($sequence) - 2; $i += 3) {
		my $codon = substr($sequence, $i, 3);
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
	
	# Object values
    $self->{protein} = $final if defined $final;
	return $self->{protein};
}

1;

__END__

=head1 NAME

Template - This module contains functions to transcribe and translate a DNA sequence.

=head1 SYNOPSIS

    use Template
    my $o = Template->new;

=head1 METHODS

=over 4

=item B<new>

Constructs a new Template object. 

Returns a blessed Template object reference.

=item B<method>

Takes in a DNA sequence, translates into RNA and produces the corresponding protein. 

=back

=head1 AUTHOR

Written by Leinal A. Sejour

=head1 HISTORY

    Version history here. 

=cut

