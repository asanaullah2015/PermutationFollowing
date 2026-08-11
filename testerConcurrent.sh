#!/bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=720:00:00
##SBATCH -w node07
##SBATCH --cpus-per-task=64


if [ $# -ne 6 ]; then
    echo "Please specify exactly 6 command line arguments: permutationGenerator, permutationFollower, numIterations, maxPerm, outputFile, and maxConcurrency"
    exit 1
fi

echo -n "Starting on "
date
echo "NODE: " $SLURMD_NODENAME

#set -x 
set -e

gen=$1
fol=$2
numIter=$3
maxPerm=$4
outputFile=$5
maxConcurrency=$6

#print header
echo -n -e "bytes,elements,jumps"
for ((curRun=1; curRun <= numIter; ++curRun))
do
    echo -n -e ",run $curRun"
done
echo

sizes=`for ((curSize=1; curSize <= maxPerm; curSize*=2)); do echo -n $curSize ' '; done`
for curSize in $sizes 
do 
    $gen $curSize $maxConcurrency | $fol $numIter | tr '\t' ',' 
done 2> $outputFile.err | tee $outputFile

echo -n "Ending on "
date
