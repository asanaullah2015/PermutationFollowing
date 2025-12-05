#!/bin/bash

#set -x 
set -e

if [ $# -ne 4 ]; then
    echo "Please specify exactly 4 command line arguments: permutationGenerator, permutationFollower, numIterations, and maxPerm"
    exit 1
fi

gen=$1
fol=$2
numIter=$3
maxPerm=$4

sizes=`for ((curSize=1; curSize < maxPerm; curSize*=2)); do echo -n $curSize ' '; done`

curSize=1
for curSize in $sizes 
do 
    $gen $curSize 2> /dev/null | $fol $numIter 2> /dev/null
done
