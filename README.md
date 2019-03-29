# Data Anaylsis Workflow of a Unique Whitenose Microbiome Study - Cornell University Animal Health and Diagnostic Center

Descibed here is a workflow of bat microbiome study that contained pooled large amplicon targets of 18S and 16S from wing tissues collected from 2007-2009.

- Dataset Challenges

1. Each sample contained a PCR amplified full-length 16S and 18S phlyogenetic marker (~1.5kb).
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

1. Concatenate Assembly Files and Clustering into ≥
