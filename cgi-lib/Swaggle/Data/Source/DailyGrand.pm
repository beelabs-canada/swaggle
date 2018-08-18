package Swaggle::Data::Source::DailyGrand;

use base 'Swaggle::Data::Source::Base';

use v5.10;
use Path::Tiny;
use LWP::Simple;
use IO::Uncompress::Unzip qw(unzip $UnzipError) ;


sub BUILD {
    my ($self, $args) = @_;
	
	$self->id( 'dailygrand' );
	$self->url( 'http://www.bclc.com/documents/DownloadableNumbers/CSV/DailyGrand.zip' );
	$self->input( Path::Tiny->tempfile( )->stringify().".zip" );
	$self->output( Path::Tiny->tempfile()->stringify().".csv" );
	$self->schema([
	{ text => 'dropping table', sql => 'DROP TABLE IF EXISTS dailygrand' },
	{ text => 'creating table' , sql => 'CREATE TABLE dailygrand( id INTEGER PRIMARY KEY, date INT NOT NULL, weekday TEXT NOT NULL, sequence INT NOT NULL DEFAULT 0, slot1 INT NOT NULL, slot2 INT NOT NULL, slot3 INT NOT NULL, slot4 INT NOT NULL, slot5 INT NOT NULL, bonus INT NOT NULL )' }
	]);
}

sub fetch
{
  my ( $self ) = @_;
  
  say "[source] preparing to download";
  
  getstore( $self->url,  $self->input  );
  
  say "[source] got source from origin proceeding to extract";
  
  unzip $self->input => $self->output  or die "unzip failed: $UnzipError\n";
  
  return path( $self->output )->lines_utf8({ chomp => 1});
  
}

1;