#!/bin/sh

rm -rf out/*
cp -R static out/
perl blosxom/blosxom.cgi -password='pass'
