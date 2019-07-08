package Routes::Welcome::Controller;

use parent 'Caravan::Base::Controller';

sub new 
{
	
	return bless { view => $_[0]->view( 'welcome','index.tpl' )->slurp_utf8, data => { title => 'Welcome!', heading => 'Hello there', body => 'lorem goodness'} }, shift;
}


1;