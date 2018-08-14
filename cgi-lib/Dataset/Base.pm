package Dataset::Base;

use strict;
use warnings;
use v5.18;

use Class::Tiny;


sub data
{
  my ( $self ) = @_;
  
  return $self->fetch();
}

1;
