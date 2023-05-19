#!/bin/sh

#  modifiedPathScript.sh
#
#
#  23 Mar 13

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
# module load java/11.0.2
# module load bbmap/38.23
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


cd /scratch4/heaswar1/czhan130/2023FlashCombinedReads/

echo "pwd: $(pwd)"

file1=(*.fastq)

echo "file1: ${file1[$SLURM_ARRAY_TASK_ID]}"

outFileName=$(echo ${file1[$SLURM_ARRAY_TASK_ID]} | sed "s/...$//")

mkdir /scratch4/heaswar1/czhan130/2023FlashCombinedReads/PostScript/

outputDir=/scratch4/heaswar1/czhan130/2023FlashCombinedReads/PostScript/

echo "outFileName: $outFileName"

echo "outputDir: $outputDir"


echo "running seqence match"


awk 'NR%4==2' ${file1[$SLURM_ARRAY_TASK_ID]}  | sed 's/CTCGTTTGTGGAGCGGATGTCCT/BMP2/;s/AGGACATCCGCTCCACAAACGAG/BMP2_R/;s/ACTTTAGTCGATACATCACCATC/CDX2/;s/GATGGTGATGTATCGACTAAAGT/CDX2_R/;s/CACTTGAGGTCGGCACACGTCCA/AXIN2_R/;s/TGGACGTGTGCCGACCTCAAGTG/AXIN2_R/;s/CATCTACCACAGTTGTGACCTCA/SFRP4/;s/TGAGGTCACAACTGTGGTAGATG/SFRP4_R/;s/ACTACAGCCGGTACATCACTATC/CDX1/;s/GATAGTGATGTACCGGCTGTAGT/CDX1_R/;s/GAGAGAGAGCGAGGTATTGGCCT/APC/;s/AGGCCAATACCTCGCTCTCTCTC/APC_R/;s/CCGCAGGACAACGACCTCTGCAT/SFRP2/;s/ATGCAGAGGTCGTTGTCCTGCGG/SFRP2_R/;s/CCGAGACACGGGAAACCAACTTG/WIF1/;s/CAAGTTGGTTTCCCGTGTCTCGG/WIF1_R/;s/AGGTGATGATGATGGGCAACGTT/cdkn2a/;s/AACGTTGCCCATCATCATCACCT/cdkn2a_R/;s/CCTGGTGAAAAGGGCCTGGGTCT/BMP5/;s/AGACCCAGGCCCTTTTCACCAGG/BMP5_R/;s/CACGCGCAACCCCAGCAGCCGCT/SOX17/;s/AGCGGCTGCTGGGGTTGCGCGTG/SOX17_R/;s/CATAAGCCTGAAAATGTCTCCTG/P53/;s/CAGGAGACATTTTCAGGCTTATG/P53_R/;s/ACGGTTGGCCTTAGGGTTCAGGG/ACTB/;s/CCCTGAACCCTAAGGCCAACCGT/ACTB_R/;s/GCGTGCACGGACTATAAAGGCCT/SCRAMB/;s/AGGCCTTTATAGTCCGTGCACGC/SCRAMB_R/;s/GCCTGCAGCGGACCCCGCGAGCC/SCRAMA/;s/GGCTCGCGGGGTCCGCTGCAGGC/SCRAMA_R/' | while read -r line; do echo $line | grep -o -e 'BMP2' -e 'BMP2_R' -e 'CDX2' -e 'CDX2_R'  -e 'AXIN2' -e 'AXIN2_R'  -e 'SFRP4' -e 'SFRP4_R'  -e 'CDX1' -e 'CDX1_R'  -e 'APC' -e 'APC_R'  -e 'SFRP2' -e 'SFRP2_R'  -e 'WIF1' -e 'WIFI_R'  -e 'cdkn2a' -e 'cdkn2a_R' -e 'BMP5' -e 'BMP5_R'  -e 'SOX17' -e 'SOX17_R'  -e 'P53' -e 'P53_R' -e 'ACTB' -e 'ACTB_R' -e 'SCRAMB' -e 'SCRAMB_R' -e 'SCRAMA' -e 'SCRAMA_R' | tr "\n" " "  ; echo ; done > ${outputDir}${outFileName}_seqMatches.txt

cd $outputDir

echo "pwd: $(pwd)"

file2=(*_seqMatches.txt)

echo "file2: $(echo ${file2[$SLURM_ARRAY_TASK_ID]})"

for i in 'BMP2' 'BMP2_R' 'CDX2' 'CDX2_R' 'AXIN2' 'AXIN2_R' 'SFRP4' 'SFRP4_R' 'CDX1' 'CDX1_R' 'APC' 'APC_R' 'SFRP2' 'SFRP2_R' 'WIF1' 'WIF1_R' 'cdkn2a' 'cdkn2a_R' 'BMP5' 'BMP5_R' 'SOX17' 'SOX17_R' 'P53' 'P53_R' 'ACTB' 'ACTB_R' 'SCRAMB' 'SCRAMB_R' 'SCRAMA' 'SCRAMA_R'

do

count=$(grep -c -e $i  ${file2[$SLURM_ARRAY_TASK_ID]})


countAll=$(grep -c  -e 'BMP2' -e 'BMP2_R'  -e 'CDX2' -e 'CDX2_R'  -e 'AXIN2' -e 'AXIN2_R'  -e 'SFRP4' -e 'SFRP4_R'  -e 'CDX1' -e 'CDX1_R'  -e 'APC' -e 'APC_R'  -e 'SFRP2' -e 'SFRP2_R'  -e 'WIF1' -e 'WIF1_R'  -e 'cdkn2a' -e 'cdkn2a_R' -e 'BMP5' -e 'BMP5_R'  -e 'SOX17' -e 'SOX17_R'  -e 'P53' -e 'P53_R' -e 'ACTB' -e 'ACTB_R' -e 'SCRAMB' -e 'SCRAMB_R' -e 'SCRAMA' -e 'SCRAMA_R' ${file2[$SLURM_ARRAY_TASK_ID]})

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
