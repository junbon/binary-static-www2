package BOM::Request;

use Moo;
use BOM::Config qw/root_url/;

has 'language' => (is => 'rw');
has 'website'  => (is => 'lazy');
sub _build_website { return BOM::Request::Website->new }

sub param  { }         # return nothing
sub broker { 'CR' }    # hardcode

our %HTML_URLS;

sub url_for {
    my $self = shift;
    my @args = @_;

    my $LANG = $self->language;
    my $url = $args[0] || '';

    if ($url =~ m{^/?(images|css|scripts)/}) {
        $url =~ s/^\///;
        return Mojo::URL->new(root_url() . $url);
    }

    if ($HTML_URLS{$url}) {
        $url =~ s/^\///;
        return Mojo::URL->new(root_url() . "$LANG/$url.html");
    }
    # /terms-and-conditions#privacy-tab
    my ($upre, $upost) = ($url =~ /^(.*?)\#(.*?)$/);
    if ($upost and $HTML_URLS{$upre}) {
        $upre =~ s/^\///;
        return Mojo::URL->new(root_url() . "$LANG/$upre.html#$upost");
    }
    # for link alternate
    my $query = $args[1] || {};
    if ($query->{l} and $query->{l} ne $LANG) {
        # /binary-static-www2/en/home.html
        $url =~ s{^(/binary-static-www2)?/(\w+)/(.+)\.html$}{/$3};
        if ($HTML_URLS{$url}) {
            $url =~ s/^\///;
            return Mojo::URL->new(root_url() . lc($query->{l}) . "/$url.html");
        }
    }

    my $uri = Mojo::URL->new($url);
    $uri->query($query);
    return $uri;
}

package BOM::Request::Website;

use Moo;

sub display_name { 'Binary.com' }

1;
