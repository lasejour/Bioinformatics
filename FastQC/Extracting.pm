package Extracting;

use strict;
use warnings;

# This module creates object that can:
# 1. Take in a fastQC file, 1st property
# 2. Parse out key module names, from the 2nd property

sub new {
	my $class = shift;
	my $self = {};
	
	# 1st property, a filename
	$self->{filename} = shift or die "There were no fastQC files.";
	
	# 2nd property, an array of modules
	# Will use these to search for these later
	$self->{modules} = [
		"Filename", "Total Sequences", "%GC", "Total Deduplicated Percentage", 
		"Poly A", "Poly G", "Basic Statistics",
		"Per base sequence quality", "Per tile sequence quality", "Per sequence quality scores", 
		"Per base sequence content", "Per sequence GC content", "Per base N content", 
		"Sequence Length Distribution", "Sequence Duplication Levels", 
		"Overrepresented sequences", "Adapter Content"
	];

	bless($self, $class);
	return $self;
}

# Getter for the modules
sub get_modules {
	my $self = shift;
	return $self->{modules};
}

# function to open a fastQC file
# extract the elements from the input file
sub extract_module {
	# Takes in a module name to look for and the filename
	my $self = shift;
	
	# hash reference that is returned
	# these variables when house the matches from the file
	my %qc;
	my $polyA_value;
	my $polyG_value;
	
	# Go thru it line by line
	# looking for matches and saving them to variables
	
	# Open the fastQC file
	open (my $fh, '<:encoding(UTF-8)', $self->{filename})
		or die "Could not open file $self->{filename} $!";
	
	# While looping through the file line by line
	# look for each element
	while (my $line = <$fh>) {
		chomp $line;
		foreach my $module (@{$self->{modules}}) {
			
			if($line =~ /($module)\s+(\w.+|\d+)/) {
				$qc{$1} = uc($2);
			}
			elsif($line =~ /(AA{20})\s(\d+)\s(\d\.?\d*+)/) {
				$polyA_value = $3;
				$qc{"Poly A"} = sprintf("%.2f", $polyA_value);
			}
			elsif($line =~ /(GG{20})\s(\d+)\s(\d\.?\d*+)/) {
				$polyG_value = $3;
				$qc{"Poly G"} = sprintf("%.2f", $polyG_value);
			}
		}
	}
	close $fh;
	# return a hash reference containing all the matches
	return \%qc;
}

1;

