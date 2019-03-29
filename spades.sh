export PATH=/programs/spades/bin:$PATH


rm -f -r spades-output/
mkdir spades-output
rm -f spades.cmds


cd trimmomatic-output/

for R1 in *R1_001.paired*
do
   R2=${R1//R1_001.paired.fq.gz/R2_001.paired.fq.gz}
   output=${R1//L001_R1_001.paired.fq.gz/spades_output}
   echo "spades.py -1 trimmomatic-output/$R1 -2 trimmomatic-output/$R2 -o $output --careful -t 40" >> spades.cmds
done


cat spades.cmds
chmod u+x spades.cmds
mv spades.cmds ../

cd ../
