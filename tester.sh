#!/bin/bash
#SBATCH -w c0-5
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --cpus-per-task=128
#SBATCH --mem=0
#SBATCH --time=720:00:00
#SBATCH --output=permTest



if [ $# -ne 4 ]; then
    echo "Please specify exactly 4 command line arguments: permutationGenerator, permutationFollower, numIterations, and maxPerm"
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

#print header
echo -n -e "bytes,elements"
for ((curRun=1; curRun <= numIter; ++curRun))
do
    echo -n -e ",run $curRun"
done
echo

sizes=`for ((curSize=1; curSize <= maxPerm; curSize*=2)); do echo -n $curSize ' '; done`
curSize=1
for curSize in $sizes 
do 
    $gen $curSize 2> /dev/null | $fol $numIter 2> /dev/null | tr '\t' ',' 
done | tee permTestRaw

echo -n "Ending on "
date
