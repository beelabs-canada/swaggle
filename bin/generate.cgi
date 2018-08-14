#!/usr/bin/env perl

use strict;
use warnings;
use v5.18;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'cgi-lib');

use Path::Tiny qw/path/;
use Dataset::DailyGrand;

my $root = path( $0 )->parent(2);

my $dset = Dataset::DailyGrand->new();

my @dataset = $dset->fetch();

for (my $idx = 1; $idx < scalar( @dataset ); $idx++) {
   say "Row -> $dataset[$idx]";
}








