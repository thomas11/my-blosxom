#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use File::Find;
use Storable;


my $CATEGORIES = 'categories';
my $BLOSXOM_FILE_EXTENSION = 'text';

my $META_STORAGE = '.meta';

my $writing_dir = $ARGV[0];
die "Please give the directory containing your writing" unless $writing_dir;

my %meta_global = ( categories => {} );

sub handle_file {
    my $file = $_;

    return unless $file =~ /\.$BLOSXOM_FILE_EXTENSION$/;
    # Strip the ending.
    (my $article = $_) =~ s/\.$BLOSXOM_FILE_EXTENSION//;
    say $article;

    open (my $fh, '<', $file) or die "$file: $!";

    # Record the title in the first line. For consistency it should be
    # a meta value, too, but I couldn't get it to work in the
    # templates.
    my $first_line = 1;

    my %meta = ();
    # The end result will look like this:
    # meta
    #  article
    #    title
    #    date
    #    blurb
    #    [categories]
    #  categories
    #    [articles]

    while (my $line = <$fh>) {

        # Title; see above.
        if ($first_line) {
            $meta{title} = $line;
            $first_line = 0;
            next;
        }

        # Meta tag of the form "key: value"?
        my ($key, $value) = ($line =~ m!^(.+?)\s*:\s*(.+)$!);  # from meta
        next unless defined $key;

        if ($key eq $CATEGORIES) {
            my @categories = ();
            for my $category (split /, */, $value) {
                push @categories, $category;

                my $global_categories = $meta_global{categories};
                if (not exists $global_categories->{$category}) {
                    $global_categories->{$category} = [];
                }
                push @{$global_categories->{$category}}, $article;
            }
            $meta{categories} = \@categories;
        } else {
            $meta{$key} = $value;
        }
    }

    $meta_global{$article} = \%meta;
}

find(\&handle_file, ($writing_dir));

store \%meta_global, $META_STORAGE;
