package Swaggle::Data::Set;


sub new
{
    my ( $class, @data ) = ( shift, @_ );
	
	my @cols = $class->_slots( $data[0] );
	
	my @matrix = ();
	push @matrix, [] for scalar( @cols );
	
	foreach my $row (@data) {
		for (my $idx = 0; $idx < scalar(@cols); $idx++) {
			push @{ $matrix[$idx] }, $row->{ $cols[$idx] };
		}
	}
	
	
	
	my $self = {
		cols => \@cols,
		total => scalar(@data),
		data => \@matrix
	};
	
	return bless( $self, $class );
}


sub _slots
{
	my( $self, $row, @names ) = @_;
	
	foreach my $ky (sort keys %$row) {
		if ( $self->_startswith( $ky, 'slot' ) )
		{
			push @names, $ky;
		}
	}
	
	return @names;
}

sub _startswith
{
	my ( $self, $text, $needle ) = @_;
    return substr( lc($text), 0, length( $needle )) eq $needle;
}

sub data
{
	return $_[0]->{data};
}

sub cols
{
	return $_[0]->{cols};
}

sub total
{
	return $_[0]->{total};
}

1;