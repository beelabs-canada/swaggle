package Caravan::Response::HTTP;

use HTTP::Date;


my $headers = [
		[ 'Status', 200 ],
		[ 'Content-Type', 'text\html' ],
		[ 'Last-Modified', time2str( time ) ]
	];

my $body = '<html><head><title>Welcome :: Caravan</title></head><body><h1>Welcome! to Caravan</h1></body></html>';

sub new
{
	my ($class, $args) = ( shift, { @_ } );
	
	if ( exists $args->{'content-type'} ) 
	{
	 $headers->[1]->[0] = $args->{'content-type'} ;
 	}
	
	if ( exists $args->{'charset'} ) 
	{
	 $headers->[1]->[1] = 'charset='.uc( $args->{'charset'} );
 	}
	
	if ( exists $args->{'last-modified'} ) 
	{
	 $headers->[2] = time2str( $args->{'last-modified'} );
 	}
	
	
	return bless $args, $class;
}


sub status
{
	if ( scalar( @_ ) > 1 )
	{
		$headers->[0]->[1] =  $_[1];
	}
	return $headers->[0]->[1];
}

sub content_type
{
	if ( scalar( @_ ) > 1 )
	{
		$headers->[1]->[1] =  $_[1];
	}
	return $headers->[1]->[1];
}

sub last_modified
{
	if ( scalar( @_ ) > 1 )
	{
		$headers->[2]->[1] =  $_[1];
	}
	return $headers->[2]->[1];
}

sub body
{
	if ( scalar( @_ ) > 1 )
	{
		$body = $_[1];
	}
	
	return $body;
}



sub generate
{
	my $response = "";
	
	for (my $hdr = 0; $hdr < scalar( @{$headers} ); $hdr++) {
		
		$response .= join(': ', @{ $headers->[$hdr] } );
		
		$response .= "\n";
	}	
	
	$response .= "\n\n".$body;
	
	return $response;
}


1;