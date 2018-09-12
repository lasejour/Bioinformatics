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

# Unzips the folder that contains the fastqc reports
sub extract_zips_to_folders {
	my $source_dir = shift;
	
	while (my $zipfile = <$source_dir/*.zip>) {
		system("unzip $zipfile -d $source_dir");
	}	
}

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
# Check for program, must have proper input
my $dir = shift or die "Usage: GetReport.pl <directory or path to directory>";

# Second check, to see if it's a directory
unless ( -d $dir ) {
	die "$dir is not a directory. Please provide a directory $!\n";
}

###############
# Zip all zipped folders in a directory
extract_zips_to_folders($dir);

###############
# Getting the files in the subdiectories of the directory being provided
chdir $dir;
my $rule =  File::Find::Rule->new;
$rule->file;
$rule->name( '*data.txt' );
my @files = $rule->in(@INC);

###############

# opens an object to get the modules names
my $obj = Extracting->new();
my $array_ref = $obj->get_modules();
my @modules = @$array_ref;

# Get an array of hash refs from the files
# each ref contains info we want 
my @hash_refs = map( get_refs($_) , @files );

# Get the strings for each file
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