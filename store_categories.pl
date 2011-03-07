#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use File::Find;
use Storable;


my $CATEGORIES = 'categories';
my $STORAGE = '.categories';

my $writing_dir = $ARGV[0];
die "Please give the directory containing your writing" unless $writing_dir;

my %files_per_tag = ();

sub handle_file {
    say $_;
    open (my $fh, '<', $_) or die "$_: $!";
    while (my $line = <$fh>) {
        my ($key, $value) = ($line =~ m!^(.+?)\s*:\s*(.+)$!);  # from meta
        next unless (defined $key and $key eq $CATEGORIES);

        for my $category (split /, */, $value) {
            if (not exists $files_per_tag{$category}) {
                $files_per_tag{$category} = [];
            }
            push @{$files_per_tag{$category}}, $_;
        }
    }
}

find(\&handle_file, ($writing_dir));

store \%files_per_tag, $STORAGE;
