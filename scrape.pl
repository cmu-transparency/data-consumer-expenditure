use strict;
use URI::URL;
use Number::Bytes::Human qw(format_bytes);
use Term::ProgressBar;
use WWW::Mechanize;
use Data::Dumper;

# use LWP::UserAgent;
# use HTTP::Tiny;

my $url = new URI::URL(shift());
my $pattern = shift();

my $mech = WWW::Mechanize->new(autocheck=>1, show_progress=>1);

$mech->get($url);

my $links = $mech->find_all_links('tag'=>'a',
				  'url_regex'=>qr/$pattern/i);

my $progress = 0;
my $url = 0;
my $last_status = 0;

*{WWW::Mechanize::progress} = sub {
    my ($ignore, $status, $request_or_response) = @_;
    if ($status eq 'begin') {
    } elsif ($status eq 'end') {
	if ($progress) {
	    $progress->message("got $url");
	    $progress = 0;
	}
    } else {
	my $res = $request_or_response;
	my $len = $res->header('content_length');
	my $bytes = format_bytes($len);
	if (! $progress) {
	    $progress = Term::ProgressBar->new({'count'=>1.0,
						'name'=>"$url ($bytes)",
					        'ETA'=>'linear'});
	}
	if ($status != $last_status) {
	    $progress->update($status);
	}
	$last_status = $status;
    }
};

for my $link (@$links) {
    $url = $link->url();

    my $filename = $url;
    $filename =~ s/\//-/g;

    #print "downloading $url to $filename\n";

    my $res = $mech->head($link->url_abs());

    $mech->mirror($link->url_abs(), "./data/$filename");
}
