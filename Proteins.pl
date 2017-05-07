#!/usr/bin/perl

use strict;
use warnings;

use feature qw(say);
use Translate;

# test module
# create object with 2 functions: transcription and translation
my $sequence = Translate->new;
say $sequence->transcription("AAATACTTTCGGGCTCTCTCTAATCC");
say $sequence->translation("AAATACTTTCGGGCTCTCTCTAATCC");