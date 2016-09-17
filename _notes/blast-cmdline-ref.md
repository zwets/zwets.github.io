---
title: BLAST Command-line Reference
excerpt: "Command-line reference for the NCBI BLAST suite, reorganised because the tools lack individual man pages and information is spread all over."
layout: page
tags: blast
---

The command-line options for the Blast+ CLI Tools.  Taken from the [User Manual](http://www.ncbi.nlm.nih.gov/books/NBK1763/)
because the tools lack individual manpages and information is spread all over.

## Table of Contents
{: .no_toc}
* Table of Contents
{:toc}


## BLAST Links

* [All BLAST Documentation](http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs)
* [Blast+ Command Line Applications User Manual](http://www.ncbi.nlm.nih.gov/books/NBK1763/) (PDF)
* [NCBI C++ Toolkit](http://ncbi.github.io/cxx-toolkit/) book and code on GitHub, the [examples](http://ncbi.github.io/cxx-toolkit/pages/ch_demo) describe `id1_fetch`.

## Search Programmes

The BLAST search programmes are:

1. [blastn](#blastn-options): nucleotide - nucleotide (regular, mega, dc-mega, short)
2. [blastp](#blastp-options): protein - protein (regular, fast, short)
3. [blastx](#blastx-options): nucleotide - protein (regular, fast)
4. [tblastn](#tblastn-options): protein - nucleotide translated (regular, fast)
5. [tblastx](#tblastx-options): nucleotide translated - nucleotide translated (ungapped only)
6. [rpsblast+](#rpsblast-options): protein - conserved domain profiles (CDD)
7. [rpstblastn](#rpstblastn-options):
8. [psiblast](#psiblast-options):
9. [deltablast](#deltablast-options): sensitive protein sequence search based on psiblast

The BLAST search programmes share the following set of shared options.


### Common search options

|option|type|default|description|
|------+----+-------+-----------|
|`db`|string|none|BLAST database name, searched in BLASTDB path (see [Configuring BLAST+](#configuring-blast).|
|`query`|string|stdin| Query file name, contents autodetected and [autoresolved](#identifier-auto-resolution): fasta, GIs, accession numbers.|
|`query_loc`|string|none|Location on the query sequence (Format: start-stop)|
|`out`|string|stdout|Output file name|
|`evalue`|real|10.0|Expect value (E) for saving hits|
|`subject`|string|none|File with subject sequence(s) to search, contents autodetected and [autoresolved](#identifier-auto-resolution): fasta, GIs, accession numbers.|
|`subject_loc`|string|none|Location on the subject sequence (Format: start-stop).|
|`show_gis`|flag|N/A|Show NCBI GIs in report.|
|`num_descriptions`|integer|500|Show one-line descriptions for this number of database sequences.|
|`num_alignments`|integer|250|Show alignments for this number of database sequences.|
|`max_target_seqs`|Integer|500|Number of aligned sequences to keep. Use with report formats that do not have separate definition line and alignment sections such as tabular (all outfmt > 4). Not compatible with `num_descriptions` or `num_alignments`.|
|`html`|flag|N/A|Produce HTML output|
|`gilist`|string|none|Restrict search of database to GI’s listed in this file. Local searches only. Note that [blastdb_aliastool](#blastdb-aliastool-options) can (1) optimise a GI list to binary and (2) create a named alias to a database filtered on a GI list.   |
|`negative_gilist`|string|none|Restrict search of database to everything except the GI’s listed in this file. Local searches only.|
|`entrez_query`|string|none|Restrict search with the given Entrez query. Remote searches only.|
|`culling_limit`|integer|none|Delete a hit that is enveloped by at least this many higher-scoring hits.|
|`best_hit_overhang`|real|none|[Best Hit algorithm](#best-hit-filtering) overhang value (recommended value: 0.1)|
|`best_hit_score_edge`|real|none|[Best Hit algorithm](#best-hit-filtering) score edge value (recommended value: 0.1)|
|`dbsize`|integer|none|Effective size of the database|
|`searchsp`|integer|none|Effective length of the search space|
|`import_search_strategy`|string|none|Search strategy file to read.|
|`export_search_strategy`|string|none|Record search strategy to this file.|
|`parse_deflines`|flag|N/A|Parse query and subject bar delimited sequence identifiers (e.g., gi\|129295).|
|`num_threads`|integer|1|Number of threads (CPUs) to use in blast search.|
|`remote`|flag|N/A|Execute search on NCBI servers?|
|`outfmt`|string|0|Alignment view options (see [below](#alignment-view-options))|

#### Alignment View options (outfmt values)

Note: options 6, 7, and 10 can be additionally configured to produce a custom format specified by space delimited format specifiers (see [format specifiers below](#search-output-specifiers)).

`0` | pairwise (default) 
`1` | query-anchored showing identities,
`2` | query-anchored no identities,
`3` | flat query-anchored, show identities,
`4` | flat query-anchored, no identities,
`5` | XML Blast output,
`6` | tabular, see [output specifiers](#search-output-specifiers)
`7` | tabular with comment lines, see [output specifiers](#search-output-specifiers)
`8` | Text ASN.1,
`9` | Binary ASN.1,
`10` | Comma-separated values, see [below](#search-output-specifiers)
`11` | BLAST archive format (ASN.1),
`12` | JSON Seqalign output,
`13` | JSON Blast output,
`14` | XML2 Blast output

#### Search Output Specifiers

These apply to the tabular [alignment view options](#alignment-view-options) (blast `outfmt` 6,7,10). Asterisks mark the defaults, which correspond to keyword `std`.

`qseqid*` | Query Seq-id
`qgi` | Query GI
`qacc` | Query accesion
`qaccver` | Query accesion.version
`qlen` | Query sequence length
`sseqid*` | Subject Seq-id
`sallseqid` | All subject Seq-id(s), separated by semicolon
`sgi` | Subject GI
`sallgi` | All subject GIs
`sacc` | Subject accession
`saccver` | Subject accession.version
`sallacc` | All subject accessions
`slen` | Subject sequence length
`qstart*` | Start of alignment in query
`qend*` | End of alignment in query
`sstart*` | Start of alignment in subject
`send*` | End of alignment in subject
`qseq` | Aligned part of query sequence
`sseq` | Aligned part of subject sequence
`evalue*` | Expect value
`bitscore*` | Bit score
`score` | Raw score
`length*` | Alignment length
`pident*` | Percentage of identical matches
`nident` | Number of identical matches
`mismatch*` | Number of mismatches
`positive` | Number of positive-scoring matches
`gapopen*` | Number of gap openings
`gaps` | Total number of gaps
`ppos` | Percentage of positive-scoring matches
`frames` | Query and subject frames separated by a '/'
`qframe` | Query frame
`sframe` | Subject frame
`btop` | Blast traceback operations (BTOP)
`staxids` | unique Subject Taxonomy ID(s), separated by semicolon (in numerical order)
`sscinames` | unique Subject Scientific Name(s), separated by semicolon
`scomnames` | unique Subject Common Name(s), separated by semicolon
`sblastnames` | unique Subject Blast Name(s), separated by semicolon (in alphabetical order)
`sskingdoms` | unique Subject Super Kingdom(s), separated by semicolon (in alphabetical order)
`stitle` | Subject Title
`salltitles` | All Subject Title(s), separated by a '<>'
`sstrand` | Subject Strand
`qcovs` | Query Coverage Per Subject
`qcovhsp` | Query Coverage Per HSP

#### Identifier Auto-resolution

The `-query` and `-subject` files can contain sequences or identifiers (GIs, accession number), which 
will be resolved locally and remotely.  For remote resolution, `DATA_LOADERS`, `BLASTDB_PROT_DATA_LOADER`,
`BLASTDB_NUCL_DATA_LOADER` must be set (see [configuring BLAST+](#configuring-blast)).

#### Best-Hit Filtering

Returns only the best matches for each query region reporting matches.  Given `-best_hit_overhang H` and
`-score_edge E`, this selects hit A over a hit B when:

1. B's query region extends neither end of A's query region by more than `H` times A's query region length.
2. A's e-value is no worse than that of B, i.e. `evalue(A) <= evalue(B)`
3. A's score over length has an `E` edge over that of B, i.e. `score(A)/length(A) > (1-E) * score(B)/length(B)`

Suggested ranges are `H` in 0.1 .. 0.25 (larger is more filtering but longer runtime), `E` 0.05 .. 0.25
(larger is less filtering).


### BLASTN options

The blastn application searches a nucleotide query against nucleotide subject sequences or a nucleotide database.
It has four `-task` options, which preset defaults values for specific types of search:

1. `megablast`: for very similar sequences (e.g, sequencing errors), 
2. `dc-megablast`: discontinuous megablast, typically used for inter-species comparisons
3. `blastn`: the traditional program used for inter-species comparisons,
4. `blastn-short`: optimized for sequences less than 50 nucleotides.

In addition to the [Common Search Options](#common-search-options), these are the `blastn` options:

|blastn option|type|default|description|
|-+-+-+-| 
|`word_size`|integer|28(m) 11(d,n) 7(s)|Length of initial exact match. Note: dc allows non-consecutive letters to match.|
|`gapopen`|integer|0(m) 5(d,n,s)|Cost to open a gap. See [below](#blastn-reward-penalty-values)|
|`gapextend`|integer|-(m) 2(d,n,s)|Cost to extend a gap. This default is a function of reward/ penalty value. see [below](#blastn-reward-penalty-values)|
|`reward`|integer|1(m,s) 2(d,n)|Reward for a nucleotide match.|
|`penalty`|integer|-1(m) -3(d,n,s)|Penalty for a nucleotide mismatch.|
|`ungapped`|flag|N/A|Perform ungapped alignment.|
|`strand`|string|both|Query strand(s) to search against database/subject. Choice of both, minus, or plus.|
|`perc_identity`|integer|0|Percent identity cutoff.|
|`dust`|string|20 64 1|Filter query sequence with dust.|
|`filtering_db`|string|none|Mask query using the sequences in this database.|
|`window_masker_taxid`|integer|none|Enable WindowMasker filtering using a Taxonomic ID.|
|`window_masker_db`|string|none|Enable WindowMasker filtering using this file.|
|`soft_masking`|boolean|true|Apply filtering locations as soft masks (i.e., only for finding initial matches).|
|`lcase_masking`|flag|N/A|Use lower case filtering in query and subject sequence(s).|
|`db_soft_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as soft mask (i.e., only for finding initial matches).|
|`db_hard_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as hard mask (i.e., sequence is masked for all phases of search).|
|`xdrop_ungap`|real|20|Heuristic value (in bits) for ungapped extensions.|
|`xdrop_gap`|real|30|Heuristic value (in bits) for preliminary gapped extensions.|
|`xdrop_gap_final`|real|100|Heuristic value (in bits) for final gapped alignment.|
|`min_raw_gapped_score`|integer|none|Minimum raw gapped score to keep an alignment in the preliminary gapped and trace-back stages. Normally set based upon expect value.|

#### Megablast specific

|blastn option|type|default|description|
|-+-+-+-| 
|`use_index`|boolean|false|Use MegaBLAST database index. Indices may be created with the makembindex application.|
|`index_name`|string|none|MegaBLAST database index name.  |
|`no_greedy`|flag|N/A|Use non-greedy dynamic programming extension.|

#### DC-Megablast specific

|blastn option|type|default|description|
|-+-+-+-| 
|`template_type`|string|coding|Discontiguous MegaBLAST template type. Allowed values are coding, optimal and coding_and_optimal.|
|`template_length`|integer|18|Discontiguous MegaBLAST template length.|
|`window_size`|integer|40|Multiple hits window size, use 0 to specify 1-hit algorithm|


### BLASTP options

The blastp application searches a protein sequence against protein subject sequences or a protein database.  This table reflects the 2.2.31 BLAST+ release.

#### Tasks

1. `blastp`: standard protein-protein comparisons
2. `blastpshort`: optimized for query sequences shorter than 30 residues
3. `blastp-fast`: using a larger wordsize for the initial word matching as described in PMID17921491. 

In addition to the [Common Search Options](#common-search-options), these are the `blastp` options:

|blastp option|type|default|description|
|-+-+-+-| 
|`word_size`|integer|3(p) 2(s) 6(f)|Word size of initial match. Valid word sizes are 2-7.|
|`gapopen`|integer|11(p,f) 9(s)|Cost to open a gap.|
|`gapextend`|integer|1|Cost to extend a gap.|
|`matrix`|matrix|BLOSUM62(p,f) PAM30(s)| Scoring matrix name.|
|`threshold`|integer|11(p) 16(s) 21(f)| Minimum score to add a word to the BLAST lookup table.|
|`seg`|string|no|Filter query sequence with SEG (Format: 'yes', 'window locut hicut', or 'no' to disable).|
|`soft_masking`|boolean|false(p,f) N/A(s)|Apply filtering locations as soft masks (i.e., only for finding initial matches). Not for blastpshort.|
|`lcase_masking`|flag|N/A|Use lower case filtering in query and subject sequence(s).|
|`db_soft_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as soft mask (i.e., only for finding initial matches).|
|`db_hard_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as hard mask (i.e., sequence is masked for all phases of search).|
|`xdrop_gap_final`|real|25|Heuristic value (in bits) for final gapped alignment/|
|`window_size`|integer|40(p,f) 15(s)| Multiple hits window size, use 0 to specify 1-hit algorithm.|
|`use_sw_tback`|flag|N/A|Compute locally optimal Smith-Waterman alignments?|
|`comp_based_stats`|opt|2(p,f) 0(s)|Use composition-based statistics (see [below](#composition-based-stats-option))

#### Composition-based stats option

|value|meaning|
D,d | Default
F,f,0 | No composition-based statistics
1 | Composition-based statistics as in NAR 29:2994-3005, 2001
T,t,2 | Composition-based score adjustment as in Bioinformatics 21:902-911, 2005, conditioned on sequence properties
3 | Composition-based score adjustment as in Bioinformatics 21:902-911, 2005, unconditionally


### BLASTX options

The blastx application translates a nucleotide query and searches it against protein subject sequences or a protein database.  It has two tasks:

1. `blastx`: standard searches
2. `blastx-fast`: larger word-size for the initial word matching as described in PMID17921491.

In addition to the [Common Search Options](#common-search-options), these are the `blastx` options:

|blastx option|type|default|description|
|-+-+-+-| 
|`word_size`|integer|3(x) 6(f)| Valid word sizes are 2-7.|
|`gapopen`|integer|11|Cost to open a gap.|
|`gapextend`|integer|1|Cost to extend a gap.|
|`matrix`|string|BLOSUM62|Scoring matrix name.|
|`threshold`|integer| 12(x) 21(f)| Minimum score to add a word to the BLAST lookup table.|
|`seg`|string|12 2.2 2.5|Filter query sequence with SEG (Format: 'yes', 'window locut hicut', or 'no' to disable).|
|`soft_masking`|boolean|false|Apply filtering locations as soft masks (i.e., only for finding initial matches).|
|`lcase_masking`|flag|N/A|Use lower case filtering in query and subject sequence(s).|
|`db_soft_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as soft mask (i.e., only for finding initial matches).|
|`db_hard_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as hard mask (i.e., sequence is masked for all phases of search).  |
|`xdrop_gap_final`|real|25|Heuristic value (in bits) for final gapped alignment.|
|`window_size`|integer|40|Multiple hits window size, use 0 to specify 1-hit algorithm.|
|`strand`|string|both|Query strand(s) to search against database/subject. Choice of both, minus, or plus.|
|`query_genetic_code`|integer|1|Genetic code to translate query, see ftp://ftp.ncbi.nih.gov/entrez/misc/data/gc.prt|
|`max_intron_length`|integer|0|Length of the largest intron allowed in a translated nucleotide sequence when linking multiple distinct alignments (a negative value disables linking).  |
|`comp_based_stats`|integer|2|Use composition-based statistic (see [Composition based statistics option for BLASTN](#composition-based-stats-option))|


### TBLASTN options

The tblastn application searches a protein query against nucleotide subject sequences or a nucleotide database translated at search time.  It has two tasks:

1. `tblastn`: for standard searches, 
2. `tblastn-fast`: using a larger word-size for the initial word matching as described in PMID17921491.

In addition to the [Common Search Options](#common-search-options), these are the `tblastn` options:

|tblastn option|type|default|description|
|-+-+-+-| 
|`word_size`|integer|3(n) 6(f)| Word size for initial match. Valid word sizes are 2-7.|
|`gapopen`|integer|11|Cost to open a gap.|
|`gapextend`|integer|1|Cost to extend a gap.|
|`matrix`|string|BLOSUM62|Scoring matrix name.|
|`threshold`|integer|13(n) 21(f)| Minimum score to add a word to the BLAST lookup table.|
|`seg`|string|12 2.2 2.5|Filter query sequence with SEG (Format: 'yes', 'window locut hicut', or 'no' to disable).|
|`soft_masking`|boolean|false|Apply filtering locations as soft masks (i.e., only for finding initial matches).|
|`lcase_masking`|flag|N/A|Use lower case filtering in query and subject sequence(s).  |
|`db_soft_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as soft mask (i.e., only for finding initial matches).|
|`db_hard_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as hard mask (i.e., sequence is masked for all phases of search).|
|`xdrop_gap_final`|real|25|Heuristic value (in bits) for final gapped alignment.|
|`window_size`|integer|40|Multiple hits window size, use 0 to specify 1-hit algorithm.|
|`db_gen_code`|integer|1|Genetic code to translate subject sequences, see ftp://ftp.ncbi.nih.gov/ entrez/misc/data/gc.prt|
|`max_intron_length`|integer|0|Length of the largest intron allowed in a translated nucleotide sequence when linking multiple distinct alignments (a negative value disables linking).|
|`comp_based_stats`|string|2|Use composition-based statistics see [Composition based statistics option for BLASTN](#composition-based-stats-option))|


### TBLASTX options

The tblastx application searches a translated nucleotide query against translated nucleotide subject sequences or a translated nucleotide database.  Only ungapped searches are supported for tblastx.

In addition to the [Common Search Options](#common-search-options), these are the `tblastx` options:

|tblastx option|type|default|description|
|-+-+-+-| 
|`word_size`|integer|3|Word size for initial match.|
|`matrix`|string|BLOSUM62|Scoring matrix name.|
|`threshold`|integer|13|Minimum word score to add the word to the BLAST lookup table.|
|`seg`|string|12 2.2 2.5|Filter query sequence with SEG (Format: 'yes', 'window locut hicut', or 'no' to disable).|
|`soft_masking`|boolean|false|Apply filtering locations as soft masks (i.e., only for finding initial matches).|
|`lcase_masking`|flag|N/A|Use lower case filtering in query and subject sequence(s).|
|`db_soft_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as soft mask (i.e., only for finding initial matches).|
|`db_hard_mask`|integer|none|Filtering algorithm ID to apply to the BLAST database as hard mask (i.e., sequence is masked for all phases of search).|
|`strand`|string|both|Query strand(s) to search against database subject sequences. Choice of both, minus, or plus.|
|`query_genetic_code`|integer|1|Genetic code to translate query, see ftp://ftp.ncbi.nih.gov/entrez/misc/data/gc.prt|
|`db_gen_code`|integer|1|Genetic code to translate subject sequences, see ftp://ftp.ncbi.nih.gov/entrez/misc/data/gc.prt|
|`max_intron_length`|integer|0|Length of the largest intron allowed in a translated nucleotide sequence when linking multiple distinct alignments (a negative value disables linking)|


### RPSBLAST options

The rpsblast application searches a protein query against the conserved domain database (CDD), which is a set of protein profiles. Many of the common options such as matrix or word threshold are set when the CDD is built and cannot be changed by the rpsblast application. A search ready CDD can be downloaded from ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/

In addition to the [Common Search Options](#common-search-options), these are the `rpsblast` options:

|rpsblast option|type|default|description|
|-+-+-+-| 
|`window_size`|integer|40|Multiple hits window size, use 0 to specify 1-hit algorithm.|
|`xdrop_ungap`|real|15|Heuristic value (in bits) for ungapped extensions|
|`xdrop_gap`|real|25|Heuristic value (in bits) for preliminary gapped extensions.|
|`xdrop_gap_final`|real|40|Heuristic value (in bits) for final gapped alignment.|
|`seg`|string|no|Filter query sequence with SEG (Format: 'yes', 'window locut hicut', or 'no' to disable).|
|`soft_masking`|boolean|false|Apply filtering locations as soft masks (i.e., only for finding initial matches).|
|`comp_based_stats`|string|1|Use composition-based statistics (see [Composition based statistics option for BLASTN](#composition-based-stats-option))|

### DELTABLAST options

DELTA-BLAST uses RPS-BLAST to search for conserved domains matching to a query, constructs a PSSM from the sequences associated with the matching domains, and searches a sequence database. Its sensitivity is comparable to PSI-BLAST and does not require several iterations of searches against a large sequence database.


## Database Management

The BLAST database & index management related tools:

1. [makeblastdb](#makeblastdb-options): create BLAST+ database
2. [makembindex](#makembindex-options): create index for megablast or (new) srsearch 
3. [makeprofiledb](#makeprofiledb-option): create profile database for [rpsblast+](#rpsblast-options)
4. [blastdbcmd](#blastdbcmd-options): read and report from BLAST+ database
5. [blastdb_aliastool](#blastdb-aliastool-options): manage subsetted and multipart databases
6. blastdbcheck
7. blastdbcp


### MAKEBLASTDB options

Makeblastdb application options. This application builds a BLAST database.  Note that [blastdb\_aliastool](#blastdb-aliastool-options) can create a 'virtual' database by subsetting a database with a GI list, or 'supersetting' across a number of databases.

|makeblastdb option|type|default|description|
|-+-+-+-| 
|`in`|string|stdin|Input file/database name|
|`out`|string|input|file name Name of BLAST database to be created. Input file name is used if none provided. This field is required if input consists of multiple files.|
|`input_type`|string|fasta|Input file type, it may be any of fasta, blastdb, asn1\_txt, asn1\_bin|
|`dbtype`|string|prot|Molecule type of input, values can be nucl or prot.|
|`title`|string|none|Title for BLAST database. If not set, the input file name will be used.|
|`parse_seqids`|flag|N/A|Parse bar delimited sequence identifiers (e.g., gi\|129295) in FASTA input, so they can be used to filter queries on identifier lists. See section [About Sequence Identifiers](#about-sequence-identifiers) below.|
|`hash_index`|flag|N/A|Create index of sequence hash values.|
|`mask_data`|string|none|Comma-separated list of input files containing masking data as produced by NCBI masking applications (e.g. dustmasker, segmasker, windowmasker).|
|`max_file_size`|string|1GB|Maximum file size to use for BLAST database.|
|`taxid`|integer|none|Taxonomy ID to assign to all sequences.|
|`taxid_map`|string|none|File with two columns mapping sequence ID to the taxonomy ID. The first column is the sequence ID represented as one of the below. The second column should be the NCBI taxonomy ID (e.g., 9606 for human). First column is either fasta with accessions (`emb|X17276.1|`), fasta with GI (`gi|4`), GI as a bare number (`4`), or a local ID which must be prefixed with `lcl` (`lcl|4`). See section on [sequence indentifiers](#about-sequence-identifiers) too.|
|`logfile`|string|none|Program log file (default is stderr).|

### MAKEMBINDEX options

The indexed databases created by makembindex are used by production MegaBLAST software and by a new **srsearch** utility designed to quickly search for nearly exact matches (up to one mismatch) of short queries against a genomic database. When a FASTA formatted file is used as the input, then masking by lower case letters is incorporated in the index. Makembindex can currently build two types of indices, called old style and new style indexing. The NCBI offers full support for the new style and has deprecated the old style. A MegaBLAST search with a new style index requires that both the index and the corresponding BLAST database be present. The index structure is described in PMID: 18567917. Please cite this paper in any publication that uses makembindex.

|`makembindex option`|type|default|description|
|`-+-+-+-`| 
|`input`|string|stdin|Input file name or BLAST database name, depending on the value of the iformat parameter.  For FASTA formatted input, this parameter is optional and defaults to the program's standard input stream.|
|`output`|string|none|The resulting index name. The index itself can consist of multiple files, called volumes, called <index_name>.00.idx, <index_name>.01.idx,...  This option should not be used with new style indices.  |
|`iformat`|string|fasta|The input format selector. Possible values are 'fasta' and 'blastdb'.|
|`old_style_index`|boolean|true|If set to 'false' the new style index is created. New style indices require a BLAST database as input (use -iformat blastdb), which can be downloaded from the NCBI FTP site or created with makeblastdb. The option -output is ignored for a new style index. New style indices are always created at the same location as the corresponding BLAST database.|
|`db_mask`|integer|None|Exclude masked regions of BLAST db from the index. Use makeblastdb to discover the algorithm ID to be used as input for this argument.|
|`legacy`|boolean|true|This is a compatibility feature to support current production MegaBLAST. If true, then -stride, -nmer, and -ws_hint are ignored. The legacy format must be used for BLAST.|
|`nmer`|integer|12|N-mer size to use. Ignored if –legacy is specified |
|`ws_hint`|integer|28|This is an optimization hint for makembindex that indicates an expected minimum match size in searches that use the index. If n is the value of -nmer parameter and s is the value of –stride parameter, then the value of -ws_hint must be at least n + s - 1.  |
|`stride`|integer|5|makembindex will index every stride-th N-mer of the database.  |
|`volsize`|integer|1536|Target index volume size in megabytes.|


### MAKEPROFILEDB options

This application builds an RPS-BLAST database (which includes the files for a standard protein BLAST database). COBALT (a multiple sequence alignment program) and DELTA-BLAST both use RPS-BLAST searches as part of their processing, but use specialized versions of the database. This application can build databases for COBALT, DELTA-BLAST, and a standard RPS-BLAST search. The `dbtype` option (see entry in table) determines which flavor of the database is built.

|makeprofiledb option|type|default|description|
|-+-+-+-| 
|`in`|string|stdin|Input file that contains a list of scoremat files (delimited by space, tab, or newline)|
|`binary`|flag|N/A|The scoremat files are binary ASN.1|
|`title`|string|none|Title for RPS-BLAST database. If not set, the input file name will be used.|
|`threshold`|real|9.82|Threshold for RPSBLAST lookup table.|
|`out`|string|input|file name Name of BLAST database to be created. Input file name is used if none provided.|
|`max_file_size`|string|1GB|Maximum file size to use for BLAST database.|
|`dbtype`|string|rps|Specifies use for RPSBLAST db. One of rps, cobalt, or delta.|
|`index`|boolean|true|Creates index files for the standard BLAST database (equivalent to `parse_seqids` with makeblastdb).|
|`gapopen`|integer|none|Cost to open a gap. Used only if scoremat files do not contain PSSM scores, otherwise ignored.|
|`gapextend`|integer|none|Cost to extend a gap by one residue. Used only if scoremat files do not contain PSSM scores, otherwise ignored.|
|`scale`|real|100|PSSM scale factor.|
|`matrix`|string|BLOSUM62|Matrix to use in constructing PSSM. One of BLOSUM45, BLOSUM50, BLOSUM62, BLOSUM80, BLOSUM90, PAM250, PAM30 or PAM70. Used only if scoremat files do not contain PSSM scores, otherwise ignored.  |
|`obsr_threshold`|real|6|Exclude domains with maximum number of independent observations below this value (for use in DELTA-BLAST searches).|
|`exclude_invalid`|boolean|true|Exclude domains that do not pass validation test (for use in DELTA-BLAST searches).  |
|`logfile`|string|none|Program log file (default is stderr).  |


### BLASTDBCMD options

This application reads a BLAST database and produces reports. For every format except '%f' (default), each line of output will correspond to a sequence.

|blastdbcmd option|type|default|description|
|-+-+-+-| 
|`db`|string|nr|BLAST database name.|
|`dbtype`|string|guess|Molecule type stored in BLAST database, one of nucl, prot, or guess.|
|`entry`|string|none|Comma-delimited search string(s) of sequence identifiers: e.g.: `555`, `AC147927`, `gnl|dbname|tag`, or `all` to select all sequences in the database. See also section [About Sequence Identifiers](#about-sequence-identifiers) below.|
|`entry_batch`|string|none|Input file for batch processing. The format requires one entry per line; each line should begin with the sequence ID followed by any of the following optional specifiers (in any order): range (format: from-[to], 1-based inclusive), strand ('plus' or 'minus'), or masking algorithm ID (integer value representing the available masking algorithm).|
|`pig`|integer|none|PIG (protein identity group) to retrieve.|
|`info`|flag|N/A|Print BLAST database information.  |
|`range`|string|none|Range of sequence to extract (Format: start-stop).|
|`strand`|string|plus|Strand of nucleotide sequence to extract. Choice of plus or minus.|
|`mask_sequence_with`|string|none|Produce lower-case masked FASTA using the algorithm IDs specified.  |
|`out`|string|stdout|Output file name.  |
|`target_only`|flag|N/A|Definition line should contain target GI or accession only|
|`get_dups`|flag|N/A|Retrieve duplicate accessions.  |
|`line_length`|integer|80|Line length for output.|
|`ctrl_a`|flag|N/A|Use Ctrl-A as the non-redundant definition line separator.|
|`outfmt`|string|%f|Output format, see [Database output specifiers](#database-output-specifiers))|


#### Database output specifiers

Note that all specifiers except `%f` (default) produce a single line per result.

`%f` | sequence in FASTA format
`%s` | sequence data (without defline)
`%a` | accession
`%g` | gi
`%o` | ordinal id (OID)
`%t` | sequence title
`%l` | sequence length
`%T` | taxid
`%L` | common taxonomic name
`%S` | scientific name
`%P` | PIG
`%m`_X_ | sequence masking data, where _X_ is an optional comma-separated list of integers to specify the algorithm ID(s) to display (or all masks if absent or invalxd specification). Masking data will be displayed as a series of 'N-M' values separated by ';' or the word 'none' if none are available. 


### BLASTDB\_ALIASTOOL options

Optimise a textual GI list into a binary list: 

    blastdb_aliastool -gi_file_in gilist.txt -gi_file_out gilist.bin

Create an aliased database using a GI list (use a binary GI list or the tool will create it; note that the GI list must stay with the generated `.nal` file):

    blastdb_aliastool -db nt -dbtype nucl -title "Subset database" -gilist gilist.bin -out subsetdb

To create a subset database for a specific taxonomy ID', generate the GI list first.  Ways of doing this:
* Use the `gi_taxid_{nucl,prot}.dmp` GI-taxid mapping files from [ftp://ftp.ncbi.nih.gov/pub/taxonomy/](ftp://ftp.ncbi.nih.gov/pub/taxonomy/) (see the [readme](ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid.readme))
* Perform an [Entrez query](http://www.ncbi.nlm.nih.gov/protein) with query `txidXXXX[ORGN]` where `XXXX` is the taxid, then choose "Send to File" and select GI List (suggested [here](https://www.biostars.org/p/6528/)
* Trawl recursively trought the taxdump `nodes` and `names` files from the archive at [ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz](ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz)

Create an alias for a multi-volume BLAST database:

```bash
blastdb_aliastool -dblist ... -num_volumes ...
```

### seqdb_perf

TBD.


## Filtering and Masking

### dustmasker

Identifies and masks regions of low complexity in nucleotide sequences.  See ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/dustmasker/README.dustmasker

### segmasker

Identifies and masks regions of low complexity in protein sequences.  See ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/segmasker/README.segmasker

### windowmasker

Identifies sequences occurring too often to be of interest to most users.  See ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/windowmasker/README.windowmasker

### convert2blastmask

TBD.


## Miscellanous Tools & Topics

### Configuring BLAST+

The blast+ toolkit reads `.ncbirc` in current directory, user `$HOME` or directory `$NCBI`.  On Ubuntu, package `ncbi-data` installs `/etc/ncbi/.ncbirc` so set `export NCBI=/etc/ncbi` and add a [BLAST] section having at least `BLASTDB` pointing to the directory/ies containing Blast databases, and optionally `DATA_LOADERS`, `BLASTDB_PROT_DATA_LOADER`, `BLASTDB_NUCL_DATA_LOADER` for [identifier auto-resolution](#identifier-auto-resolution).

### About Sequence Identifiers

Defined [here](http://ncbi.github.io/cxx-toolkit/pages/ch_demo) as in tables below.  The "lcl" and "general database reference" (`gnl|MYDB|123`) (at least) work for `parse_seqid` and will be indexed in the resulting database.  Sequence identifiers can be concatenated separated by a vertical bar (who makes this up?).  So for instance `gi|1234|ref|NP_5432.1` would make the sequence retrievable (or filterable with `-gilist`) using any of `gi|1234|ref|NP_5432.1`, `1234`, `ref|NP_5432`, `NP_5432.1`, etc.  Any string following the space following an identifier will be the (unparsed) title for the sequence.

#### Flattened Sequence ID format

A flattened sequence ID has one of the following three formats, where square brackets surround optional elements. The type is a number, indicating who assigned the ID (numbers in table below):

* `type([name or locus][,[accession][,[release][,version]]])`
* `type=accession[.version]`
* `type:number`

#### FASTA Sequence ID format

|Type|Description|Format|Example|
|----+-----------+------+-------|
|1|Local|`lcl|[integer|string]`|`lcl|123` `lcl|hmm271`|
|2|GenInfo backbone sequence ID|`bbs|integer`|`bbs|123`|
|3|GenInfo backbone molecule type|`bbm|integer`|`bbm|123`|
|4|GenInfo import ID|`gim|integer`|`gim|123`|
|5|GenBank|`gb|accession|locus`|`gb|M73307|AGMA13GT`|
|6|European Mol Biol Lab (EMBL)|`emb|accession|locus`|`emb|CAM43271.1|`|
|7|Protein Info Resource (PIR)|`pir|accession|name`|`pir||G36364`|
|8|SWISS-PROT|`sp|accession|name`|`sp|P01013|OVAX_CHICK`|
|9|Patent|`pat|country|patent|sequence`|`pat|US|RE33188|1`|
|-|Pre-grant patent|`pgp|country|application-number|seq-number`|`pgp|EP|0238993|7`|
|10|[RefSeq](http://www.ncbi.nlm.nih.gov/projects/RefSeq)|`ref|accession|name`|`ref|NM_010450.1|`|
|11|General database reference|`gnl|database|[integer|string]`|`gnl|taxon|9606` `gnl|PID|e1632`|
|12|GenInfo integrated database (GI)|`gi|integer`|`gi|21434723`|
|13|DNA Bank of Japan (DDBJ)|`dbj|accession|locus`|`dbj|BAC85684.1|`|
|14|Protein Research Foundation (PRF)|`prf|accession|name`|`prf||0806162C`|
|15|Protein Database (PDB)|`pdb|entry|chain`|`pdb|1I4L|D`|
|16|Third-party annot to GenBank|`tpg|accession|name`|`tpg|BK003456|`|
|17|Third-party annot to EMBL|`tpe|accession|name`|`tpe|BN000123|`|
|18|Third-party annot to DDBJ|`tpd|accession|name`|`tpd|FAA00017|`|
|19|TrEMBL|`tr|accession|name`|`tr|Q90RT2|Q90RT2_9HIV1`|
|-|Genome pipeline (internal)|`gpp|accession|name`|`gpp|GPC_123456789|`|
|-|Named annotation track (internal)|`nat|accession|name`|`nat|AT_123456789.1|`|

### BLASTN reward/penalty values

BLASTN uses a simple approach to score alignments, with matching bases assigned a reward and mismatching bases assigned a penalty. It is important to choose reward/penalty values appropriate to the sequences being alignedi, with (absolute) reward/penalty ratio increasing for more divergent sequences. Rules of thumb for the reward/penalty ratio are:

* 0.33 (1/-3) is appropriate for sequences that are about 99% conserved; 
* 0.5 (1/-2) is best for sequences that are 95% conserved; 
* about unity (1/-1) is best for sequences that are 75% conserved.

For each reward/penalty pair, a number of different gap costs are supported. Gap cost is a value to open the gap and a value to extend the gap by a base. Default costs are:

* MegaBLAST: opening cost is 0, extension is half of the cost of two mismatches minus one match.
* Other tasks of blastn: 5 to open a gap and 2 to extend one base.

Table below presents the supported reward/penalty values and gap costs.  Blastn also supports gap costs more stringent than those listed.  Default megaBLAST gap costs are shown in the right-most column. Accurate statistics for these default megaBLAST gap costs can only be calculated for the most stringent reward/penalty values, but the values listed in the middle column can always be used.

reward/penalty | gap costs (open/extend) | default MegaBLAST gap costs (open/extend) |
-+-+-|
1/-5 | 3/3 | 0/5.5 |
1/-4 | 1/2, 0/2, 2/1, 1/1 | 0/4.5 |
2/-7 | 2/4, 0/4, 4/2, 2/2 | 0/8 |
1/-3 | 2/2, 1/2, 0/2, 2/1, 1/1 | 0/3.5 |
2/-5 | 2/4, 0/4, 4/2, 2/2 | 0/6 |
1/-2 | 2/2, 1/2, 0/2, 3/1, 2/1, 1/1 | 0/2.5 |
2/-3 | 4/4, 2/4, 0/4, 3/3, 6/2, 5/2, 4/2, 2/2 | 0/4 |
3/-4 | 6/3, 5/3, 4/3, 6/2, 5/2, 4/2 | N/A |
4/-5 | 6/5, 5/5, 4/5, 3/5 | N/A |
1/-1 | 3/2, 2/2, 1/2, 0/2, 4/1, 3/1, 2/1 | N/A |
3/-2 | 5/5 | N/A |
5/-4 | 10/6, 8/6 | N/A |

### legacy_blast

Run legacy BLAST command in BLAST+.  Use `--print-only` to see what modern blast+ invokes instead.

### gene_info_reader

Convert between GI and Gene IDs.

### blast_formatter

Reformat the output of a blast job without needing to rerun the query.

### seedtop+

**TODO**

