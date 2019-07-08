#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use FindBin;
use File::Spec;
use lib File::Spec->catdir( $FindBin::Bin, '..', 'cgi-lib' );

use Swaggle::Database;
use Swaggle::Data::Set;
use Data::Dmp;
use Swaggle::Analytics::General;
use Path::Tiny qw/path/;

my $basedir = path( $0 )->parent(2);


my $db = Swaggle::Database->new(
 [ name => 'local', type => 'sqlite', path => $basedir->child('db/database.sqlite')->stringify ]
);

my @data = @{ $db->get('local')->weekday('dailygrand', 2) };

my $set = Swaggle::Data::Set->new( @data );

my $report = Swaggle::Analytics::General->new( $set );

$report->report();