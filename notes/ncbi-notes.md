---
title: NCBI Notes
layout: page
category: notes
excerpt: Miscellaneous links and notes kept on the NCBI databases and tools.
published: false
ignore: { permalink }
---

## Contents

{:toc}

## TODO
- [ ] SRA search functions!
- [ ] Overview of All NCBI Software and Data, and HOWTO's
    https://www.ncbi.nlm.nih.gov/guide/data-software/
    http://www.ncbi.nlm.nih.gov/home/tutorials.shtml
- [ ] How to find SNPs using Blast
    https://www.ncbi.nlm.nih.gov/guide/howto/view-all-snps/
    ftp://ftp.ncbi.nih.gov/pub/factsheets/HowTo_Finding_SNP_by_BLAST.pdf
- [ ] API's and download methods
    ftp://ftp.ncbi.nih.gov/pub/factsheets/Factsheet_bulk_download.pdf
    https://www.ncbi.nlm.nih.gov/guide/howto/automate-blast-searches-ncbi-server
- [ ] The Entrez Programming Utilies
    http://www.ncbi.nlm.nih.gov/books/NBK25501/
    Chapter 6 is Unix: http://www.ncbi.nlm.nih.gov/books/n/helpeutils/chapter6/
- [ ] Check out more Ubuntu docs (e.g. the scoring.pdf in /usr/share/doc/blast2/...)
    Explains exactly the L, K, etc.
  [ ] New WGS Blast search, limited to taxonomy
    ftp://ftp.ncbi.nlm.nih.gov/blast/WGS_TOOLS/README_BLASTWGS.txt

## NCBI Links

### Overall

* [OVERVIEW of ALL NCBI Software and Data](https://www.ncbi.nlm.nih.gov/guide/data-software/)
* [Overview of NCBI HowTo's](http://www.ncbi.nlm.nih.gov/home/tutorials.shtml)

### Blast Links

* [Blast Home](http://blast.ncbi.nlm.nih.gov)
* [Blast User Manual](http://www.ncbi.nlm.nih.gov/bookshelf/br.fcgi?book=helpblast)
* [Howto BLAST Guide](ftp://ftp.ncbi.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf)
* [Blast Databases](ftp://ftp.ncbi.nlm.nih.gov/blast/db/)
* [RefSeq databases](ftp://ftp.ncbi.nlm.nih.gov/refseq/release/)
* [Nucleotide database (nuccore)](https://www.ncbi.nlm.nih.gov/nuccore?itool=toolbar)
* [Straight to the Sequences](ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_BACTERIA # try Aeromonas, for instance.)

## The BLAST Suite

BLAST is the **Basic Local Alignment Search Tool**.  blast+ is the C++ rewrite deprecating the C original.

### Ubuntu packages

* `ncbi-blast+` is the package to install
  * binaries: `psiblast rpsblast+ tblastn blast_formatter blastx blastdb_aliastool dustmasker makembindex blastdbcmd blastdbcheck makeprofiledb segmasker blastp makeblastdb seedtop+ tblastx convert2blastmask windowmasker gene_info_reader rpstblastn update_blastdb seqdb_perf legacy_blast deltablast blastn windowmasker_2.2.22_adapter blastdbcp`
  * documentation: one man page only: ncbi-blast+, referring to http://www.ncbi.nlm.nih.gov/books/NBK1763/ (stored in Zotero)
* `blast2` deprecated by blast+
  * `legacy_blast [--print-only] ...` invokes or shows equivalent from `blast+`
  * documentation at /usr/share/doc/blast2/index.html mentions blast+
  * binaries: `megablast blast2 blastcl3 fastacmd formatdb makemat blastall bl2seq blastall_old taxblast formatrpsdb blastpgp rpsblast impala copymat blastclust seedtop`
* `ncbi-tools-bin` seem to be the developer tools (why not called ncbi-blast+-dev?)
  * binaries: `errhdr asn2asn idfetch asn2idx insdseqget nps2gps asn2xml getmesh gil2bin asn2gb getpub gene2xml subfuse gbseqget vecscreen trna2tbl tbl2asn asnval debruijn trna2sap cleanasn asntool asn2all asn2fsa asndisc sortbyquote findspl asn2ff checksub indexpub asndhuff spidey fa2htgs asnmacro makeset`
* `ncbi-data` is package required by all three aforementioned packages
   * configuration: `/etc/ncbi/{.ncbirc,.nlmstmanrc}` _note they're dotfiles (silly)_
     * `.ncbirc` has lot of config and sets [NCBI] DATA=/usr/share/ncbi/data
     * `.ncbirc` set `[BLAST] BLASTDB=/data/genomics/ncbi/blast/db` _but doesn't seem get picked up?_
   * binaries: vibrate # preloads vibrate library so omitted arguments will be prompted (but library not here)
   * data: `/usr/share/ncbi/data` has 16SCore but e.g. also the genetic code [gc.prt](file://usr/share/ncbi/data/gc.prt)

## Configuring blast+
  
* `BLASTDB` point to directory with databases
* /etc/ncbi/.ncbirc # sheesh why dotfile?

## BLAST Programs
* blastn  - search nucleotide database using nucleotide sequence
  * blastn: classical
  * megablast: intra-species identification (fast, precise)
  * discontiguous megablast: cross-species, search with coding sequences
  * blastn-short: short sequences, cross-species
* blastp  - search protein database using protein query
  * psi-blast: iterative search for position-specific score matrix (PSSM) construction, identify remote relatives for protein family
  * phi-blast: protein alignment with input pattern as anchor / constraint
  * delta-blast: protein similarity search, higher sensitivity than blastp
* blastx  - search protein database using translated nucleotide: identify potential protein products encoded by sequence
* tblastn - search translated nucleotide using protein query: identify sequences encoding products similar to protein query
* tblastx - search translated nucleotide database using translated nucleotide query: idem that could also be produced by nucleotides in query
* blast2  - align two sequences (bl2seq)

## Some other programs at NCBI

* Standalone Blast+   - with remote option
* QBlast, URLAPI      - RESTful BLAST
                        http://www.ncbi.nlm.nih.gov/blast/Doc/urlapi.html
                        Sample: http://www.ncbi.nlm.nih.gov/blast/docs/web_blast.pl
* blastn\_vdb          - Search in the SRA (SRR, WGS and TSA files are stored in vdb)
* MOLE-BLAST          - Take number of input sequences, cluster with nearest neighbours in database
* CDS/CDART           - Find conserved domains in curated domains / and find other sequences containing these CDS
* WGS BLAST

## The BLAST Databases 
  
Explained in the [How To BLAST Guide](ftp://ftp.ncbi.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf), also see the [README](ftp://ftp.ncbi.nih.gov/blast/db) on the [FTP Server](ftp://ftp.ncbi.nih.gov/blast/db)

* **Representative_Genomes** (local copy): Archaea and Bacteria Representative and reference genomes from refseq
* **nr**: default database: all GenBank + EMBL (Europe) + DDBJ (Japan) + PDB (World-wide Protein Database)
  *Excluding:* 
    * PAT (patent division), 
    * STS (Sequence Tagged Sites), 
    * GSS (Genomic Survey Sequences) 
    * HTGS (Unfinished High Throughput Sequences, phases 0,1,2)
    * EST (Expressed Sequence Tag = cDNA, i.e. mRNA or other transcript), 
    * TSA (Transcriptome Shotgun Assemblies, assembled from RNAseq SRA), 
    * WGS (Whole Genome Shotgun Assemblies, from SRA)
* **nt**: default nucleotide database
* **refseq_rna**: curated (NM, NR) and predicted (XM, XR) sequences from RefSeq project
* **refseq_genomic**: genomic sequences from RefSeq project
* **chromosome**: complete genomes and chromosomes from RefSeq project
* **human, mouse G+T**:genomic sequences, curated and predicted RNA for current build for human / mouse
* **16S microbial** (local copy): archea & bacteria 16S rRNA sequences from Targeted Loci Project
* **SRA**: Sequence Read Archive: raw sequence data from NGS, also DRA (DDBJ) and ERA (EMBL)
  http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi
  To search these use `blast_vdb`, and SRA Toolkit: <ftp://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_Local_SRA_BLAST.pdf>,
  also documented here: <ftp://ftp.ncbi.nlm.nih.gov/blast/WGS_TOOLS/README_BLASTWGS.txt>

## Reference & representative Prokaryotic Genomes

About (includes explanation of distinction): <http://www.ncbi.nlm.nih.gov/refseq/about/prokaryotes/>
Browse: <http://www.ncbi.nlm.nih.gov/genome/browse/reference/#>

## GenBank

What is [GenBank](http://www.ncbi.nlm.nih.gov/genbank/)

Is the NIH genetic sequence database, an annotated collection of all publicly available DNA sequences
GenBank is part of the INSDC (GenBank, EMBL - European Mol Bio Lab, DDBJ - DNA Data Bank of Japan)
Comprised of 
- NucCore (http://www.ncbi.nlm.nih.gov/nuccore/)
- NucEst (http://www.ncbi.nlm.nih.gov/nucest/)  Expressed Sequence Tags
- Nucgss (http://www.ncbi.nlm.nih.gov/nucgss/)  Genome Survey Sequences

## Download locations

#### Web Pages

* (Reads) http://www.ncbi.nlm.nih.gov/sra (SRA)
* (Assembled) http://www.ncbi.nlm.nih.gov/genbank
* (Mapped) http://www.ncbi.nlm.nih.gov/assembly
* (Representative) http://www.ncbi.nlm.nih.gov/refseq

#### FTP 

New organisation of the download, read the FAQ: <http://www.ncbi.nlm.nih.gov/genome/doc/ftpfaq/>

```
/genomes
  /genbank
    /archaea
      /Genus_species
        assembly_summary.txt
        all_assembly_versions
          links to /genomes/all/acc.accver_assver
        latest_assembly_versions
    /bacteria
    /fungi
    ...
  /refseq
    /archaea
    /bacteria
    .
  /all
    /GCA_000000000.1_ASM000
      GCA_000000000.1_ASM000_assembly_{report,stats,structure}.txt
      GCA_000000000.1_ASM000_feature_table.txt.gz
      GCA_000000000.1_ASM000_genomic_{fna,gff,gbff}.gz
      GCA_000000000.1_ASM000_protein_{faa,gpff}.gz
      GCA_000000000.1_ASM000_wgsmaster.gbff.gz
```

More confusing: there is also /genomes/Bacteria/Genus_species_ETC_uid12345 # but is old (THIS LOCAL COPY)

First check the reference (and representative?):
      wget ftp://ftp.ncbi.nih.gov/genomes/refseq/bacteria/Aeromonas_hydrophila/assembly_summary.txt 
      wget ftp://ftp.ncbi.nih.gov/genomes/all/GCF_ # the accession link is in the summary file
      But also linked from {latest,all}_assembly_versions
    Then check the genbank (s/refseq/genbank/ in the URL)

## BLAST scores

See also /usr/share/doc/blast2/scoring.pdf.gz

* `S = [lambda x R - ln(K)] / ln(2)`, where R is raw score and lambda and K are constants that change over time
* `R = match scores + mismatch penalties + gap penalties` (for nucleotides; for protein is sum of scores in BLOSUM matrix used)
* `E = number of alignments found by chance would have score S = Q * D * 2^-S`, where Q is query length, D is database length

## Feature Table Format 

For NCBI-GenBank, EBI-EMBL and DDBJ: http://www.insdc.org/files/feature\_table.html
INSDC = International Nucleotide Sequence Data Collaboration

