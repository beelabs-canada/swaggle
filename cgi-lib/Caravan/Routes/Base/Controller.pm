package Caravan::Routes::Base::Controller;

use Mustache::Simple;
use Path::Tiny qw/path/;


sub respond
{
	my $stache = Mustache::Simple->new();
	return $stache->render( $_[0]->{'view'}, $_[0]->{'data'} );
}

sub view
{
	my ($self, @paths ) = @_; 
	return path( $ENV{DOCUMENT_ROOT} )->sibling('views')->child( @paths );
}

1;