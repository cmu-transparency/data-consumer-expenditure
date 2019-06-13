use strict;
#use LWP::UserAgent;
use URI::URL;
use Number::Bytes::Human qw(format_bytes);
use Term::ProgressBar;
# use HTTP::Tiny;

use Data::Dumper;

my $url = new URI::URL(shift());
my $pattern = shift();
#my $scheme = $url->scheme();
#my $ua = LWP::UserAgent->ProgressBar->new();
#
#if (! $http->is_protocol_supported($scheme)) {
#    die("protocol $scheme not supported");
#}
#

#my $res = $http->get($url);
#
#if ($res->is_error) {
#    die("download failed: " . $res->message);
#}

use WWW::Mechanize;

my $mech = WWW::Mechanize->new(autocheck=>1, show_progress=>1);

print "downloading $url\n";
$mech->get($url);

my $links = $mech->find_all_links('tag'=>'a',
				  'url_regex'=>qr/$pattern/i);

my $progress = 0;
my $url = 0;

*{WWW::Mechanize::progress} = sub {
    my ($ignore, $status, $request_or_response) = @_;
    if ($status eq 'begin') {
    } elsif ($status eq 'end') {
	$progress = 0;
    } else {
	my $res = $request_or_response;
	my $len = $res->header('content_length');
	my $bytes = format_bytes($len);
	if (! $progress) {
	    $progress = Term::ProgressBar->new({'count'=>1.0,
						'name'=>"$url ($bytes)"});
	}
	$progress->update($status);
    }
};

for my $link (@$links) {
    $url = $link->url();

    my $filename = $url;
    $filename =~ s/\//-/g;

    #print "downloading $url to $filename\n";

    my $res = $mech->head($link->url_abs());

    $mech->mirror($link->url_abs(), $filename);
}
