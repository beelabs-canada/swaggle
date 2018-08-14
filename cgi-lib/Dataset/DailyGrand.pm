package Dataset::DailyGrand;

use base 'Dataset::Base';

use v5.18;
use Path::Tiny;
use LWP::Simple;
use IO::Uncompress::Unzip qw(unzip $UnzipError) ;


sub fetch
{
  my ( $self ) = @_;
  
  say "[source] preparing to download";
  
  my ( $zip, $output ) = ( Path::Tiny->tempfile( )->stringify().".zip", Path::Tiny->tempfile()->stringify().".csv" ) ;
  my $rc = getstore( 'http://www.bclc.com/documents/DownloadableNumbers/CSV/DailyGrand.zip',  $zip );
  
  say "[source] got source from origin proceeding to extract";
  
  unzip $zip => $output or die "unzip failed: $UnzipError\n";
  
  return path($output)->lines_utf8({ chomp => 1});
  
}

1;