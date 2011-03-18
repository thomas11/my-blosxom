#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use File::Find;
use Storable;


my $CATEGORIES = 'categories';
my $BLOSXOM_FILE_EXTENSION = 'text';

my $ARTICLES_PER_CATEGORY_STORAGE = '.categories';
my $META_PER_FILE_STORAGE = '.meta';

my $writing_dir = $ARGV[0];
die "Please give the directory containing your writing" unless $writing_dir;

my %articles_per_category = ();
my %meta_per_file = ();

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
    my $title;

    while (my $line = <$fh>) {

        # Title; see above.
        if ($first_line) {
            $title = $line;
            $meta_per_file{title} = $title;
            $first_line = 0;
            next;
        }

        # Meta tag of the form "key: value"?
        my ($key, $value) = ($line =~ m!^(.+?)\s*:\s*(.+)$!);  # from meta
        next unless (defined $key and $key eq $CATEGORIES);

        my @categories = ();
        for my $category (split /, */, $value) {
            push @categories, $category;

            if (not exists $articles_per_category{$category}) {
                $articles_per_category{$category} = [];
            }
            push @{$articles_per_category{$category}}, $article;
        }
        $meta_per_file{$article} = \@categories;
    }
}

find(\&handle_file, ($writing_dir));

store \%articles_per_category, $ARTICLES_PER_CATEGORY_STORAGE;
# store \%meta_per_file, $META_PER_FILE_STORAGE
