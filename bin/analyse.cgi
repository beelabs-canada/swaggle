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


my $db = Swaggle::Database->new(
 [ name => 'local', type => 'sqlite', path => '/Users/masterbee/Desktop/my.anvil/swaggle/db/database.sqlite' ]
);

my @data = @{ $db->get('local')->all('dailygrand', 5) };

my $set = Swaggle::Data::Set->new( @data );

dd $set;