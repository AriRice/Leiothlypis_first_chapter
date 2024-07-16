#! /bin/bash

# Usage: checkHetsIndvVCF.sh <file>.vcf.gz [optional: x axis maximum]
# Outputs the read distribution in heterozygotes
# - plot with the depth of the genotype against the count of the minor allele
# - histogram of the proportion of the minor allele reads in the total reads
# (c) David Marques, 02.12.2015
# 10.07.2018: Joana Meier: adjusted for .vcf.gz files
# 19.03.2021: Joana Meier: added option to specify a custom maximum for the x axis

# This script requires vcftools and r

# Get a random number
r=$RANDOM


# This clause checks if the VCF file was given
if [ $# -eq 0 ] || [ ! -f $1 ]
then
        echo -e "ERROR: no vcf.gz file specified!\nUsage: checkHetsIndvVCF.sh <file>.vcf"
        exit 1
else
        f=$1
fi

if [ $# -eq 2 ]
then
        xmaxx=$2
else
        xmaxx="0"
fi

# Creates individual file
zgrep "#CHROM" $f | cut -f 10- | sed 's/\t/\n/g' > $r".tmp.indv"

# Writes the AD fields from all heterozygous genotypes with minor allele count i into a file hets.i
echo "Looping through individuals:"
n=$(wc -l $r".tmp.indv" | tr -s " " | cut -f 1 -d " ")
c=1
for i in $(cat $r".tmp.indv")
do
        echo -ne "$i | $c of $n"\\r
        vcftools --gzvcf $f --mac 1 --max-mac 1 --indv $i --recode --stdout |\
        grep -v "^#" | grep "0[/|]1" |\
        awk '{split($9,a,":");for(i=1;i<=10;i++){if(match(a[i],"AD")){adidx=i}};for(i=10;i<=NF;i++){if(match($i,"0[/|]1")==1){split($i,b,":");print b[adidx]}}}' \
        > $r".hets."$i
        ((c=c+1))
done


# Removes the temporary files hets.i
#rm $r".hets".*
#rm $r".tmp.indv"
