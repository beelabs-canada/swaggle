#!/Users/masterbee/perl5/perlbrew/perls/perl-5.16.3/bin/perl

use strict;
use warnings;
use v5.14;

use Path::Tiny qw/path/;
use Data::Dmp qw/dd/;

#use CGI::Fast;

use lib path( $ENV{'DOCUMENT_ROOT'} )->sibling('cgi-lib')->absolute->stringify;

use Caravan::Application;

my $app = Caravan::Application->new();

print $app->handle();

#print "Content-Type: text/html\n\n";

#while ($q = CGI::Fast->new) {
#    process_request($q);
#}





#say $app->storage( "mario" )->stringify;

