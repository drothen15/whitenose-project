# Data Anaylsis Workflow of a Unique Whitenose Microbiome Study - Cornell University Animal Health and Diagnostic Center

Descibed here is a workflow of bat microbiome study that contained pooled large amplicon targets of 18S and 16S from wing tissues collected from 2007-2009.

- Dataset Challenges

1. Each sample contained a PCR amplified full-length 16S and 18S phlyogenetic marker.
2. These phylogenetic markers were then pooled per sample and library prepped with unique barcodes per sample
3. Determination of best data analysis strategy without introducing too many biases

# Analysis of data independent of QIIME or with QIIME?

1. Initial workflow analyzed samples independently and then combined parsed results into a single species matrix table. The analysis method is relatively robust for this dataset, but requires extensive
parsing and filtering with custom python scripts. This was initial attempted, but later drop due to issuse custom taxonomy parsing and species matrix generation.

2. The workflow discribed here uses a combination of python scripts from QIIME v1.9, various independent Q/C programs, and SPAdes 3.13.0 to assemble Q/C reads into contigs.
- This data analysis strategy was ultimately chosen due to the ease of merging samples from a large dataset into a single normalized species matrix (OTU-table) that could be used for various downstream analyses.

    
# Quality Control of Reads and Assembly with SPAdes

1. FASTQC and Trimming of Reads
```bash
export PATH=/programs/FastQC-0.11.5:$PATH

gunzip *R1* | gunzip *R2* | cat *R1* > cat-r1-fastq | cat *R2* cat-r2-fastq
```

-Create histogram of read-length distribution
```bash
awk 'NR%4 == 2 {lengths[length($0)]++ ; counter++} END {for (l in lengths) {print l, lengths[l]}; print "total reads: " counter}' cat-r1.fastq > readlength-r1.txt

awk 'NR%4 == 2 {lengths[length($0)]++ ; counter++} END {for (l in lengths) {print l, lengths[l]}; print "total reads: " counter}' cat-r2.fastq > readlength-r2.txt
```

-Trimmomatic: this step uses a simple shell loop to create positional arguments for the trimmomatic command. The shell creates a .cmds file with all the created commands that can be run. 
```bash
./trimmomatic-auto.sh
./trimmomatic.cmds
```


- Assembly with SPAdes: much like the trimmomatic step, run the spades shell script followed by the .cmds file to execute the SPAdes commands
```bash
./spades.sh
./spades.cmds
```

# Input into QIIMEv1.9 and processing of data.
-To activate the QIIME 1.9 environment in Cornell's HPC refer to the Cornell BioHPC website (https://biohpc.cornell.edu/lab/userguide.aspx?a=software&i=30#c)


1. Concatenate Assembly Files and Clustering into â‰97% OTUS
```bash
cat *.fasta > all-samples-spades-contigs.fasta
```


```bash
pick_otus.py -i all-samples-spades-contigs.fasta -o picked-otus-97clustered
```
- I used default parameters in the step, which includes UCLUST for clustering and 97% similarity threshold.
- There are many optional parameters refer to (http://qiime.org/scripts/pick_otus.html) for more information

2. Pick a reperesentative sequence from each clustered group for taxonomic assignment
```bash
pick_rep_set.py -i picked-otus-97clustered.txt -f all-samples-spades-contigs.fasta -o rep-set-97clustered.fasta
```
(http://qiime.org/scripts/pick_rep_set.html)

3. Taxonomic Assignment with BLAST using BROCC script
- Because this dataset contained samples that had pooled 18S and 16S amplicons, taxonomy could only be assigned with blast

The brocc tool was used to assign taxonomy, these commands are copied from [@kylebittinger](https://github.com/kylebittinger/brocc)

Create a local version on the NCBI's database
```bash
create_local_taxonomy_db.py
```

Blast the repset fasta file with the following parameters. The important step is to make sure 100 blast hits are generated per query, as this will be used to assign taxonomic depth.
```bash
blastn -query <SEQUENCES (FASTA FORMAT)> -evalue 1e-5 -outfmt 7 -db nt -out <BLAST RESULTS> -num_threads 8 -max_target_seqs 100
```

Run the brocc.py script to parse the blast results and assign taxonomy
```bash
brocc.py -i <SEQUENCES (FASTA FORMAT)> -b <BLAST RESULTS> -o <OUTPUT DIRECTORY>
```

4. Create an otu-table (aka species matrix) with assigned taxonomy
```bash
make_otu_table.py -i picked-otus-97clustered.txt -t Standard_Taxonomy.txt -o otu-table-97clustered.biom
```
- Note: the <Standard_Taxonomy.txt> is the default output naming from brocc.py

# Downstream analysis
- OTU table was parsed to remove singletons.
- Bat microbiome otu table consisted of Bacteria, Fungi, and non-metazoan eukaryotes.
- See < > publication for full analysis and intpretation of bat microbiome data. 




