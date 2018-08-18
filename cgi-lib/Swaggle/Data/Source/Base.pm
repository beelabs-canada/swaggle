package Swaggle::Data::Source::Base;

use strict;
use warnings;
use v5.10;

use Class::Tiny qw/id schema input output url/;


sub migrate
{
	my ( $self, $dbh ) = @_;
	
	foreach my $sql ( @{ $self->schema() } ) {
		say "[migrate] (".$self->{id}.") ".$sql->{text};
		$dbh->do( $sql->{sql} );	
	}
	return 1;
}

sub data
{
  my ( $self ) = @_;
  
  return $self->fetch();
}

1;
