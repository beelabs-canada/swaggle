#
#  General.pm
#  swaggle
#
#  Created by Mario Bonito on 2018-08-18.
#
package Swaggle::Analytics::General;

use Statistics::Descriptive;
use Data::Dmp;
use Algorithm::NaiveBayes;
use POSIX qw(ceil);
use v5.10;


sub new
{
	my ( $class, $set, @self ) = @_;
	
	foreach my $sets ( $set->data() ) {
		my $stat = Statistics::Descriptive::Full->new();
		$stat->add_data( @{ $sets });
		push @self, $stat;
	}
	
	return bless( [ @self ] , $class );
}


sub report
{
	my ($self) = @_;
	my @engines = @{ $self };
	
	for (my $idx = 0; $idx < @engines; $idx++) {
		$self->_output( 
			col => $idx+1,
			count => $engines[$idx]->count(),
			min => $engines[$idx]->quantile(0),
			max => $engines[$idx]->quantile(4),
			freq => $engines[$idx]->frequency_distribution_ref(3)
		);	
    }
	
}

sub _output
{
	my ($self, $args ) = ( shift, { @_ } );
	say "Column [$args->{col}]";
	say "	range: $args->{min} - $args->{max}";
	my $low = $args->{min};
	for (sort {$a <=> $b} keys %{ $args->{freq} } )
	{
	   my $perc = ceil(sprintf("%.2f",(($args->{freq}->{$_}/$args->{count})*100)))."%";
	   say "	from ($low - ".ceil($_).") there are $args->{freq}->{$_} ($perc) drawn";
	   $low = ceil($_) + 1;
	}
	say "-"x80;
}



1;
