package Swaggle::Database::SQLite;

use DBI;

sub new
{
	my ($self, $args) = ( shift, { @_ } );
	
	my @dsn = ( 'dbi', 'SQLite' );
	
	
	my $username = $args->{'username'} || '';
	my $password = $args->{'password'} || '';
	
	if ( $args->{'path'} )
	{
		push( @dsn, 'dbname='.$args->{'path'} );
	}
	
	my $dsn = join(":", @dsn );
	
	return DBI->connect( $dsn, $username, $password, {
	   PrintError       => 1,
	   RaiseError       => 1,
	   AutoCommit       => 1
	});
}

1;