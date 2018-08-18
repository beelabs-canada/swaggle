package Swaggle::Database::Query;

use SQL::Abstract;
use DBI;

use constant { 
	DB => 0,
	SQL => 1
};


sub new
{
	my( $class, $args ) = ( shift, { @_ } );
	return bless [ $args->{'db'}, SQL::Abstract->new ], $class;
}


sub all
{
	my ( $self, $table ) = @_ ;
	my ( $stmt, @bind ) = $self->[SQL]->select( $table );
	
    my $sth = $self->[DB]->prepare($stmt);
		 
    $sth->execute( @bind );
	
	return $sth->fetchall_arrayref({});

	
}

sub every
{
	my ( $self, $table, $every ) = @_ ;
	
    my $sth = $self->[DB]->prepare('SELECT * FROM '.$table.' WHERE ( id % '.$every.' = 0 )');
		 
    $sth->execute;
	
	return $sth->fetchall_arrayref({});

}


sub weekday
{
   my ( $self, $table, $weekday ) = @_ ;
		
   my ( $stmt, @bind ) = $self->[SQL]->select( $table, undef, { weekday => $weekday } );
   
   my $sth = $self->[DB]->prepare($stmt);		 
   
   $sth->execute(@bind);
	
   return $sth->fetchall_arrayref({});

}



1;