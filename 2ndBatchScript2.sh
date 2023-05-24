#!/bin/sh

#  2ndBatchScript2.sh
#
#
#  23 May 4

################################################
#Set options
################################################
#Set resource requirements
#SBATCH --time=12:0:0
 
#SBATCH --mail-type=end 
#SBATCH --mail-user=czhan130@jh.edu 
#SBATCH --cpus-per-task=6 
#SBATCH --partition=defq
#SBATCH --mem=32GB 
#SBATCH --job-name=seqmatchMerged

# Start script

module list

date
echo "running $SLURM_JOBID job now"
hostname

cd /scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/PostScript/

mkdir /scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/PostScript/Counts/

outputDir=/scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/PostScript/Counts/

echo "pwd: $(pwd)"

echo "outputDir: $outputDir"

file1=(*_seqMatches_withAnn.txt)

echo "file1: ${file1[$SLURM_ARRAY_TASK_ID]}"

outFileName=$(echo ${file1[$SLURM_ARRAY_TASK_ID]} | sed "s/....$//")

echo "outFileName: $outFileName"

sed 's/^[[:space:]]*//' ${file1[$SLURM_ARRAY_TASK_ID]} | awk '{ if ( $NF ~ /(-ordered|-reversed)/){gsub("(-ordered)|(-reversed)", "", $NF)}; print $0}' | sort | uniq -c > ${outputDir}${outFileName}_counts.txt

echo "-----------------------"
echo "---------DONE----------"
echo "-----------------------"

date
