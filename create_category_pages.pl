#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Storable;

my $META_STORAGE = '.meta';

my $writing_dir = $ARGV[0];
die "Please give the directory containing your writing" unless $writing_dir;

my $meta = retrieve($META_STORAGE);
for my $cat (keys %{$meta->{categories}}) {
    open my $f, '>', "$writing_dir/categories/$cat.text";
    print $f $cat, "\n", "static: true\n\n", "\$stored_meta::$cat", "\n\n";
    close $f;
}
