#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'cgi-lib');

use DBI;

use Path::Tiny qw/path/;
use Text::CSV_PP;
use SQL::Abstract;
use Swaggle::Data::Source::DailyGrand;
use DateTime;

# ==================================================================
# = INITIALIZE                                                     =
# ==================================================================
my ( $root, $csv, $sql, $dset ) = (
	path( $0 )->parent(2),
	Text::CSV_PP->new(),
	SQL::Abstract->new,
	Swaggle::Data::Source::DailyGrand->new()
);
	
# ==================================================================
# = DATABASE                                                       =
# ==================================================================
my $dbh = DBI->connect('dbi:SQLite:dbname='.$root->child('db/database.sqlite')->stringify, '', '', {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1
});

# ==================================================================
# = Migrate                                                        =
# ==================================================================
$dset->migrate( $dbh );

# ==================================================================
# = POPULATE DATA                                                  =
# ==================================================================
my @dataset = $dset->fetch();

for (my $idx = 1; $idx < scalar( @dataset ); $idx++) {
	
	my $status  = $csv->parse($dataset[$idx]);        # parse a CSV string into fields
	my @cols = $csv->fields();
	my $date = DateTime->new( _date( $cols[2] ) );
	
	my %data = ( 
		date => $date->epoch(),
		weekday => $date->local_day_of_week(),
		sequence=> $cols[4],
		slot1 => $cols[5],
		slot2 => $cols[6],
		slot3 => $cols[7],
		slot4 => $cols[8],
		slot5 => $cols[9],
		bonus => $cols[10]
	);
	
	my($stmt, @bind) = $sql->insert('dailygrand', \%data );
	
	my $sth = $dbh->prepare($stmt);
	$sth->execute(@bind);
}

say "[complete] generation of ".$dset->id." completed";


# ==================================================================
# = Functions                                                      =
# ==================================================================
sub _date
{
	my ($iso) = @_;
	my @dts = split(/-/, $iso);
	return ( year => $dts[0], month => $dts[1], day => $dts[2] );
}








