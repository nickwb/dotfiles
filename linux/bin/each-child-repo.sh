#!/bin/sh

ORIGIN=`pwd`;
REPOS=`list-child-repos.sh`;
COMMAND=$1;

for d in $REPOS; do
    cd $d;
    eval $COMMAND;
    cd $ORIGIN;
done