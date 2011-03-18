#!/bin/sh

rm -rf out/*
cp -R static out/
cp CNAME out/
perl store_categories.pl
perl blosxom/blosxom.cgi -password='pass'
