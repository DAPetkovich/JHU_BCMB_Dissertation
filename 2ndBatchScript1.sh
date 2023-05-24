#!/bin/sh

#  2ndBatchScript1.sh
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
mlStat=$?
echo mlStat : $mlStat
if [ $mlStat -eq 1 ]
then
  echo module load fail. Exiting
  exit 1
fi

module list

scratchDir=/scratch4
date
echo "running $SLURM_JOBID job now"
hostname

cd /scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/

echo "pwd: $(pwd)"

file1=(*.fastq)

echo "file1: ${file1[$SLURM_ARRAY_TASK_ID]}"

outFileName=$(echo ${file1[$SLURM_ARRAY_TASK_ID]} | sed "s/...$//")

mkdir /scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/PostScript/

outputDir=/scratch4/heaswar1/czhan130/2023FlashCombinedReadsBatch2/PostScript/

echo "outFileName: $outFileName"

echo "outputDir: $outputDir"

echo "running seqence match"

awk 'NR%4==2' ${file1[$SLURM_ARRAY_TASK_ID]}  | sed 's/CTCGTTTGTGGAGCGGATGTCCT/Bmp2/;s/AGGACATCCGCTCCACAAACGAG/Bmp2_R/;s/ACTTTAGTCGATACATCACCATC/Cdx2/;s/GATGGTGATGTATCGACTAAAGT/Cdx2_R/;s/CACTTGAGGTCGGCACACGTCCA/Axin2_R/;s/TGGACGTGTGCCGACCTCAAGTG/Axin2_R/;s/CATCTACCACAGTTGTGACCTCA/Sfrp4/;s/TGAGGTCACAACTGTGGTAGATG/Sfrp4_R/;s/ACTACAGCCGGTACATCACTATC/Cdx1/;s/GATAGTGATGTACCGGCTGTAGT/Cdx1_R/;s/GAGAGAGAGCGAGGTATTGGCCT/Apc/;s/AGGCCAATACCTCGCTCTCTCTC/Apc_R/;s/CCGCAGGACAACGACCTCTGCAT/Sfrp2/;s/ATGCAGAGGTCGTTGTCCTGCGG/Sfrp2_R/;s/CCGAGACACGGGAAACCAACTTG/Wif1/;s/CAAGTTGGTTTCCCGTGTCTCGG/Wif1_R/;s/AGGTGATGATGATGGGCAACGTT/Cdkn2a/;s/AACGTTGCCCATCATCATCACCT/Cdkn2a_R/;s/CCTGGTGAAAAGGGCCTGGGTCT/Bmp5/;s/AGACCCAGGCCCTTTTCACCAGG/Bmp5_R/;s/CACGCGCAACCCCAGCAGCCGCT/Sox17/;s/AGCGGCTGCTGGGGTTGCGCGTG/Sox17_R/;s/CATAAGCCTGAAAATGTCTCCTG/Trp53/;s/CAGGAGACATTTTCAGGCTTATG/Trp53_R/;s/ACGGTTGGCCTTAGGGTTCAGGG/ActB/;s/CCCTGAACCCTAAGGCCAACCGT/ActB_R/;s/GCGTGCACGGACTATAAAGGCCT/ScrambledB/;s/AGGCCTTTATAGTCCGTGCACGC/ScrambledB_R/;s/GCCTGCAGCGGACCCCGCGAGCC/ScrambledA/;s/GGCTCGCGGGGTCCGCTGCAGGC/ScrambledA_R/' | while read -r line; do echo $line | grep -o -e 'Bmp2' -e 'Bmp2_R' -e 'Cdx2' -e 'Cdx2_R'  -e 'Axin2' -e 'Axin2_R'  -e 'Sfrp4' -e 'Sfrp4_R'  -e 'Cdx1' -e 'Cdx1_R'  -e 'Apc' -e 'Apc_R'  -e 'Sfrp2' -e 'Sfrp2_R'  -e 'Wif1' -e 'Wif1_R'  -e 'Cdkn2a' -e 'Cdkn2a_R' -e 'Bmp5' -e 'Bmp5_R'  -e 'Sox17' -e 'Sox17_R'  -e 'Trp53' -e 'Trp53_R' -e 'ActB' -e 'ActB_R' -e 'ScrambledB' -e 'ScrambledB_R' -e 'ScrambledA' -e 'ScrambledA_R' | tr "\n" " "  ; echo ; done > ${outputDir}${outFileName}_seqMatches.txt

cd $outputDir

echo "pwd: $(pwd)"

file2=(*_seqMatches.txt)

echo "file2: $(echo ${file2[$SLURM_ARRAY_TASK_ID]})"

for i in 'Bmp2' 'Bmp2_R' 'Cdx2' 'Cdx2_R' 'Axin2' 'Axin2_R' 'Sfrp4' 'Sfrp4_R' 'Cdx1' 'Cdx1_R' 'Apc' 'Apc_R' 'Sfrp2' 'Sfrp2_R' 'Wif1' 'Wif1_R' 'Cdkn2a' 'Cdkn2a_R' 'Bmp5' 'Bmp5_R' 'Sox17' 'Sox17_R' 'Trp53' 'Trp53_R' 'ActB' 'ActB_R' 'ScrambledB' 'ScrambledB_R' 'ScrambledA' 'ScrambledA_R'

do

count=$(grep -c -e $i  ${file2[$SLURM_ARRAY_TASK_ID]})

countAll=$(grep -c  -e 'Bmp2' -e 'Bmp2_R' -e 'Cdx2' -e 'Cdx2_R'  -e 'Axin2' -e 'Axin2_R'  -e 'Sfrp4' -e 'Sfrp4_R'  -e 'Cdx1' -e 'Cdx1_R'  -e 'Apc' -e 'Apc_R'  -e 'Sfrp2' -e 'Sfrp2_R'  -e 'Wif1' -e 'Wif1_R'  -e 'Cdkn2a' -e 'Cdkn2a_R' -e 'Bmp5' -e 'Bmp5_R'  -e 'Sox17' -e 'Sox17_R'  -e 'Trp53' -e 'Trp53_R' -e 'ActB' -e 'ActB_R' -e 'ScrambledB' -e 'ScrambledB_R' -e 'ScrambledA' -e 'ScrambledA_R' ${file2[$SLURM_ARRAY_TASK_ID]})

percent=$( echo "scale=2; $count/$countAll*100" | bc )

echo "Guide: $i"
echo "Count: $count"
echo "CountAll: $countAll"
echo "Percent: $percent"

done

awk '{sum = gsub("_R", ""); if(sum == 0 && NF !=0) {print $0, "-ordered";}; if(sum==0 && NF ==0){print $0, "-line-blank";} if(sum > (NF/2)){ for(i=NF;i>0;i=i-1) {printf("%s ", $i);} printf("%s ", "-reversed\n");} if(sum >0 && sum <= (NF/2))print $0, "-mixed"}' ${file2[$SLURM_ARRAY_TASK_ID]} > ${outputDir}${outFileName}_seqMatches_withAnn.txt

echo "-----------------------"
echo "---------DONE----------"
echo "-----------------------"

date
