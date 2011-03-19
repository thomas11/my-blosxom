#!/bin/sh

writing_dir=writing

rm -rf out/*
cp -R static out/
cp CNAME out/
perl store_categories.pl $writing_dir
perl blosxom/blosxom.cgi -password='pass'
