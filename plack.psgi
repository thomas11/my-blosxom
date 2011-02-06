#!/usr/bin/env perl

use Plack::App::File;

my $root = "/home/thomas/Dropbox/blosxom/out";
my $app = Plack::App::File->new(root => $root)->to_app;
