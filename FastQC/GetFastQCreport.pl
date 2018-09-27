#!/usr/bin/perl

use warnings;
use strict;
use Extracting;
use File::Find::Rule;

# Use the Extracting module to extract info from fastQC reports
# unzips all zipped fastQC reports in a user provided directory
# goes into each sub-directory and takes out the fastqc_data.txt reports
# extracts the desired module names from those reports and passes them into a hash
# prints contains of the hash, for each file, onto a report file.

# Get matches from the fastqc_report pages
sub get_refs {
	# filenames to be passed in
	my $filename = shift;
	
	# create object with filename
	my $obj = Extracting->new($filename);
	
	# Get the Modules from the object properties
	my $array_ref = $obj->get_modules();

	# Get the matches into a hash reference
	my $hash_ref = $obj->extract_module($filename, $array_ref);
	
	return $hash_ref;
}

# dereferences hash refs, goes thru module names we want
# puts hash refs into comma separated strings
sub deref {
	# get array of hash refs
	my ($ref, @modules) = @_;
	
	# dereferences the incoming hash
	my %hash = %$ref;
	
	# loop thru each module
	# if that module exists within a hash as a key
	# push the value that corresponds to that key
	# to the string variable
	# if it doesn't exist, push an NA string
	my $string = "";
	my @list;
	foreach my $mod (@modules) {
		my $key;
		if(exists $hash{$mod}) {
			$string = $string . $hash{$mod} . ",";
		}
		else {
			$string = $string . "NA" . ",";
		}
	}
	# push strings from an array
	push @list, $string;
	return @list;	
}

###############
# Input check
# Check for program to see if user has provided any files.
my $args = $#ARGV;
if ($args < 0) {
	die "Usage: GetReportFile.pl <zipped files> $!\n";
}

# Second check, to see if it's a zipped file
# unzips the zipped folders
foreach my $file (@ARGV) {
	unless ( -f $file && $file =~ m/\.zip$/ ) {
		die "$file is not a zipped. Please provide a zipped file $!\n";
	}
	system("unzip -q $file");
}
###############

# Find the fastqc_data.txt files
my $rule =  File::Find::Rule->new;
$rule->file;
$rule->name( '*data.txt' );
my @files = $rule->in('.');

# get the data from these files
my @hash_refs = map( get_refs($_) , @files );

# opens an object to get the modules names
my $obj = Extracting->new();
my $array_ref = $obj->get_modules();
my @modules = @$array_ref;

# Input the hash_ref matches into a string
my @strings = map( deref ($_, @modules) , @hash_refs );

# out file to print to
my $out = 'report.csv';
open (my $fh, '>', $out)
	or die "Could not open file $out, $!";

# Print data to an outfile
print $fh (join(",", @modules));
print $fh "\n";
foreach(@strings) {
	print $fh "$_\n";
}

close $fh;
