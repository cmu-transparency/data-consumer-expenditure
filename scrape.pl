use strict;
use URI::URL;
use Number::Bytes::Human qw(format_bytes);
use Term::ProgressBar;
use WWW::Mechanize;
use Data::Dumper;
use Time::Stamp;

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
my $bytes = 0;

*{WWW::Mechanize::progress} = sub {
    my ($ignore, $status, $request_or_response) = @_;
    if ($status eq 'begin') {
	$progress = Term::ProgressBar->new({'count'=>1.0,
					    'name'=>"$url",
					    'ETA'=>'linear'});
	$progress->update(0.0);
    } elsif ($status eq 'end') {
	if ($progress) {
	    my $msg = "already had $url";
	    if ($bytes) {
		$msg = "got $url ($bytes)";
	    }
	    $progress->message(Time::Stamp::gmstamp() . ": " . $msg);
	    $progress = 0;
	    $last_status = 0;
	    $bytes = 0;
	}
    } else {
	my $res = $request_or_response;
	if (! $last_status) {
	    my $len = $res->header('content_length');
	    $bytes = format_bytes($len);

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

my $considered = {};

for my $link (@$links) {
    $url = $link->url();

    print($url . "\n");

    if ($considered->{$url}) {
	print("already considered $url\n");
	continue;
    } else {
	$considered->{$url} = 1;
    }

    my $filename = $url;
    $filename =~ s/\//-/g;

    my $res = $mech->head($link->url_abs());

    $mech->mirror($link->url_abs(), "./data/$filename");
}
