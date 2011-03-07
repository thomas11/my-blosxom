#!/bin/sh

rm -rf out/*
cp -R static out/
cp CNAME out/
perl blosxom/blosxom.cgi -password='pass'
