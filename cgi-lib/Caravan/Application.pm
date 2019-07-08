package Caravan::Application;

use URI;
use Caravan::Response::HTTP;

use Module::Load;
use Module::Load::Conditional qw/can_load/;

use Path::Tiny qw/path/;

sub new
{
	my $base = path( __FILE__ )->parent(2);
	my $storage = $base->child( 'Storage' );
	my $routes = path( __FILE__ )->sibling('Routes');
	
	return bless { 
		base => $base,
		storage => $storage,
		database => $storage->child( 'database' ),
		sessions => $storage->child( 'sessions' ),
		views => $base->child('views'),
		routes => $routes
	}, shift;
}

sub storage
{
	return shift->{'storage'}->child( @_ );
}

sub database
{
	return shift->{'database'}->child( @_ );
}

sub sessions
{
	return shift->{'sessions'}->child( @_ );
}


sub handle
{
	
	my ( $self, $q ) = @_;
	# first lets check to see if the controller exists;
	
	my $route = $self->parse(  $ENV{'REQUEST_URI'} );
	
	load $route;
	
	my $controller = $route->new();
	
	my $body = $controller->respond( );
	
	my $response = Caravan::Response::HTTP->new();
	
	$response->body( $body );
	
	return $response->generate(); # lets pass the app **FIXME** there has to be a better way.
	
}

# --------------------------------------- >
# parse
# @desc - this is the route table engine
# @returns - always returns a route table
# --------------------------------------- >
sub parse
{
	my ($self, $url ) = ( shift, URI->new( shift ) );
	
	my @segs = $url->path_segments;
	
	if ( scalar( @segs ) < 2 )
	{
		return 'Caravan::Routes::Welcome::Controler';
	}
	
	my $routetable = $self->{'routes'};
	
	for (my $idx = 1; $idx < scalar( @segs ); $idx++)
	{
		
	}
	
	return 'Caravan::Routes::404::Controller';
	
}

1;