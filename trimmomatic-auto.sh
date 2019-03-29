#!/bin/bash

echo step 1 : trimming reads - trimmomatic

rm -f -r trimmomatic-output/
mkdir trimmomatic-output
rm -f trimmomatic.cmds

cd raw-fastq/


for R1 in *R1*
do
   R2=${R1//R1_001.fastq/R2_001.fastq}
   R1paired=${R1//.fastq/.paired.fq}
   R1unpaired=${R1//.fastq/unpaired.fq}
   R2paired=${R2//.fastq/.paired.fq}
   R2unpaired=${R2//.fastq/.unpaired.fq}
   echo $R2
   echo "java -jar /programs/trimmomatic/trimmomatic-0.36.jar PE raw-fastq/$R1 raw-fastq/$R2 trimmomatic-output/$R1paired trimmomatic-output/$R1unpaired trimmomatic-output/$R2paired trimmomatic-output/$R2unpaired ILLUMINACLIP:/programs/trimmomatic/adapters/NexteraPE-PE.fa:2:30:10 LEADING:2 TRAILING:2 MINLEN:150 SLIDINGWINDOW:4:5" >> trimmomatic.cmds
done

cat trimmomatic.cmds
chmod u+x trimmomatic.cmds
mv trimmomatic.cmds ../

#cd ../

echo COMPLETE


