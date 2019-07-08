package Caravan::Routes::404::Controller;

use parent 'Caravan::Routes::Base::Controller'; 

sub new 
{
	return bless { view => $_[0]->view( '404.tpl' )->slurp_utf8, data => {} }, shift;
}

1;