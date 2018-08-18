package Swaggle::Database;

use Swaggle::Database::MySQL;
use Swaggle::Database::SQLite;
use Swaggle::Database::Query;

sub new
{
	my $self = bless( { connections => {} }, shift );
	
	foreach my $con (@_) {
		$self->connection( @$con );
	}
	
	return $self;
}

sub connection
{
	my ($self, $args ) = ( shift, { @_ } );
	
	my $name = ( $args->{ name } ) ? $args->{ name } : 'local';
		
	if ( lc( $args->{ 'type' } ) eq 'sqlite')
	{
		$self->{connections}->{ $name } = Swaggle::Database::SQLite->new(
		    path => $args->{path},
			username => $args->{username},
			password => $args->{password}
		);
		
		return $self;
	}
	
	$self->{connections}->{ $name } = Swaggle::Database::MySQL->new(
	    host => ( $args->{host} ) ? $args->{host} : '127.0.0.1',
		port => ( $args->{port} ) ? $args->{port} : '3306',
		database => ( $args->{database} ) ? $args->{database} : 'swaggle',
		username => $args->{username} ? $args->{username} : 'root',
		password => $args->{password} ? $args->{password} : 'secret'
	);
	
	return $self;
}

sub get
{
	my ( $self, $conn ) = @_;
	
	my $label = ( $self->{connections}->{ $conn } ) ? $conn : 'local';

	return Swaggle::Database::Query->new( db => $self->{connections}->{ $label } );
}



1;