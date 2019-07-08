#!/usr/bin/env perl

use strict;
use warnings;
use v5.12;

use Path::Tiny qw/path/;
use Config::Tiny;
use HTTP::Tiny;

use Mojo::SQlite;
use Archive::Extract;
use File::Basename;
use Text::CSV;
use URI;

use DateTime;

# ===================================== ->
# INITIAL VARIABLES
# ===================================== ->

# Base Path 
my $base = path($0)->parent(2)->absolute;

# Config
my $config = Config::Tiny->read( $base->child('config.ini')->stringify, 'utf8' );

# Database
my $sql = Mojo::SQLite->new->from_filename( $base->child( $config->{'database'}->{'path'} )->stringify );
# ===================================== ->
# PREPROSESSING
# ===================================== ->

# lets clear the database tables
$sql->migrations->from_data->migrate(0)->migrate;

my $db = $sql->db;


my $data = fetch( $config->{'sources'}->{'lottomax'} );

my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });

my $fh = $data->openr_raw;

$csv->column_names ( $csv->getline($fh) ); 

while (my $row = $csv->getline_hr($fh) )
{
	# lets add the row
	# need the weekday;
	my @segments = split(/-/, $row->{'DRAW DATE'} );
	my $dt = DateTime->new(
		year => $segments[0],
		month => $segments[1],
		day => $segments[2],
		time_zone => 'America/Toronto'
	);
	$db->insert('draws',{
				'type'=>$row->{'PRODUCT'},
				'date' => $dt->epoch(),
				'weekday' => $dt->day_of_week(),
				'sequence' => $row->{'SEQUENCE NUMBER'},
				'slot1' => $row->{'NUMBER DRAWN 1'},
				'slot2' => $row->{'NUMBER DRAWN 2'},
				'slot3' => $row->{'NUMBER DRAWN 3'},
				'slot4' => $row->{'NUMBER DRAWN 4'},
				'slot5' => $row->{'NUMBER DRAWN 5'},
				'slot6' => $row->{'NUMBER DRAWN 6'},
				'slot7' => $row->{'NUMBER DRAWN 7'},
				'bonus' => $row->{'BONUS NUMBER'}
			});
   
}

close $fh;


# ===================================== ->
# FUNCTIONS
# ===================================== ->

sub fetch
{
	my ( $url ) = ( URI->new( $_[0] ) );
	
	my @segments = fileparse( $url->canonical , qr/\.[^.]*/ );
	
	my $file = $base->child( '.cache', $segments[0].$segments[2] );
	
	my $response = HTTP::Tiny->new->mirror( $url->canonical,  $file->stringify );

	my $ae = Archive::Extract->new( archive => $file->stringify );
	
	$ae->extract( to =>  $base->child('.cache')->absolute->stringify );
	
	return $base->child( '.cache', $segments[0] . '.csv' );
	
}


__DATA__
@@ migrations
-- 1 up
create table draws (type VARCHAR(13), date INT,  weekday VARCHAR(3), sequence INT,slot1 INT, slot2 INT, slot3 INT, slot4 INT, slot5 INT, slot6 INT, slot7 INT, bonus INT );
-- 1 down
drop table draws;
