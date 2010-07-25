package FATE;

use strict;
use warnings;

BEGIN {
    use Exporter;
    our ($VERSION, @ISA, @EXPORT);
    $VERSION = 0.1;
    @ISA     = qw/Exporter/;
    @EXPORT  = qw/doctype start end tag h1 trow trowa trowh th td fail/;
}

# HTML helpers

my %block_tags;
my @block_tags = ('html', 'head', 'style', 'body', 'table');
$block_tags{$_} = 1 for @block_tags;

my @tags;

sub doctype {
    print q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">}, "\n";
}

sub opentag {
    my ($tag, %attrs) = @_;
    print qq{<$tag};
    print qq{ $_="$attrs{$_}"} for keys %attrs;
}

sub start {
    my ($tag, %attrs) = @_;
    opentag @_;
    print '>';
    print "\n" if defined $block_tags{$tag};
    push @tags, $tag;
}

sub end {
    my ($end) = @_;
    my $tag;
    do {
        $tag = pop @tags or last;
        print "</$tag>";
        print "\n" if defined $block_tags{$tag};
    } while (defined $end and $tag ne $end);
}

sub tag {
    opentag @_;
    print "/>\n";
}

sub h1 {
    my ($text, %attrs) = @_;
    start 'h1', %attrs;
    print $text;
    end;
    print "\n";
}

sub trow {
    start 'tr';
    print "<td>$_</td>" for @_;
    end;
    print "\n";
}

sub trowh {
    start 'tr';
    print "<th>$_</th>" for @_;
    end;
    print "\n";
}

sub trowa {
    my $attrs = shift;
    start 'tr', %{$attrs};
    print "<td>$_</td>" for @_;
    end;
    print "\n";
}

sub th {
    my ($text, %attrs) = @_;
    start 'th', %attrs;
    print $text;
    end;
}

sub td {
    my ($text, %attrs) = @_;
    start 'td', %attrs;
    print $text;
    end;
}

sub fail {
    my ($msg) = @_;
    print "Content-type: text/html\r\n\r\n";
    doctype;
    start 'html', xmlns => "http://www.w3.org/1999/xhtml";
    start 'head';
    tag 'meta', 'http-equiv' => "Content-Type",
                'content'    => "text/html; charset=utf-8";
    print "<title>FATE error</title>\n";
    end 'head';

    start 'body';
    h1 "FATE error", id => 'title';
    print "$msg\n";
    end 'body';
    end 'html';
    exit 1;
}

1;
