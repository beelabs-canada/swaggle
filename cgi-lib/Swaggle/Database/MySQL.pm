package Swaggle::Database::MySQL;

use DBI;

sub new
{
	my ($self, $args) = ( shift, { @_ } );
	
	my @dsn = ( 'DBI', 'mysql' );
	my @db = ( 
		join ( "=" , 'database', $args->{'database'} ),
		join ( "=" , 'host', $args->{'host'} ),
		join ( "=" , 'port', $args->{'port'} )
	);
	
	my $dsn = join(":", join(":",@dsn), join(";", @db));
	
	print $dsn;
	
	return DBI->connect( $dsn, $username, $password, {
	   PrintError       => 1,
	   RaiseError       => 1,
	   AutoCommit       => 1
	});
}

1;