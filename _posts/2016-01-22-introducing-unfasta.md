---
title: Introducing Unfasta 
layout: post
excerpt: "Unfasta is a suite of command-line utilities for working with sequence data.  The rationale behind unfasta is to have the ability to process genomic sequence data using simple standard utilities, in the common pipes and filters style of Unix and GNU."
updated: 2018-04-06
---

[Unfasta](http://github.com/zwets/unfasta) is a suite of command-line utilities for working with sequence data.

The rationale behind unfasta is to have the ability to process genomic sequence data using simple standard utilities like `grep`, `cut` and `head`, in the common [pipes and filters style](http://www.dossier-andreas.net/software_architecture/pipe_and_filter.html) of Unix and GNU.

For instance,

```bash
# Compute the GC content of all sequences in a FASTA file
uf 'file.fa' | sed -n '2~2p' | tr -dc 'GC' | wc -c
```

In that pipeline,

* `uf` reads a FASTA file and outputs it in 'unfasta' format, collapsing sequence data to single lines;
* `sed -n 2~2p` filters every second line from its input, thus dropping the header lines;
* `tr -dc GC` drops from its input all characters except `G` and `C`;
* and `wc -c` counts the number of characters it reads, then writes this to standard output.

Pipelines are a simple and powerful way to process large streams of data, but the FASTA format is the party pooper.  By allowing sequences to span multiple lines, FASTA defies processing by line-oriented standard tools.  Even a seemingly obvious `fgrep -q 'GAATCATCTTTA'` fails with a false negative in 10-15% of cases.  Unfasta originated from frustration over this missed opportunity.

Unfasta resolves the issue by converting FASTA format to 'unfasta format' when it enters the pipeline.  The unfasta format is FASTA without line breaks in the sequence data.  Note that [unfasta files are still valid FASTA files](https://github.com/zwets/unfasta/blob/master/README.md#unfasta-is-fasta).

Some examples to illustrate my case:

```bash
# Extract all deflines using sed or awk
$ sed -n 1~2p
$ awk 'NR%2==1'

# Extract the data for the 3rd and 12th sequence
$ sed -n 7,25p

# Extract the header and sequence data for identifier 'gi|22888'
$ sed -n '/>gi|22888[^0-9]/,+1p'

# Extract the bases at positions 952-1238 in the first sequence
$ sed -n 2p | cut -b 952-1238

# Extract a 500 base fragment at position 135
$ tail -c +135 | head -c 500	# or: cut -b 135-$((134+500))

# How long are the Borrelia sequences?
$ awk '/Borrelia/ { getline; print length; }'

# Does any sequence contain fragment 'ACGTATAGCGGC'? 
$ fgrep -q 'ACGTATAGCGGC' && echo "Yes" || echo "No"
```

Obviously the law of conservation of misery applies as you now need to memorise nutty `sed` commands.  But that can be mitigated by wrapping the complexity in little self-explanatory shell scripts, which is what I did in `unfasta`.

Some examples (all assume FASTA arriving on `stdin`):

```bash
# The starting point is 'uf', which turns line-broken FASTA into unbroken FASTA
$ uf --help
... concise but complete description ...

# And as all uf-utils are shell scripts, there is always the source
$ cat `which uf`
... six lines of `awk` code doing the actual work ...
... and 60 lines of boilerplate fluff ...

# How many sequences?
$ zcat seqs.fsa.gz | uf | uf-headers | wc -l

# Is the input good, and what are the base counts?
$ uf | uf-valid --dna -s | uf-freqs  -t
  >NODE_1_length_388420_cov_15.7201
  388420 A=117181 C=82016 G=72519 T=116704
  ...
  >TOTALS
  4101446 A=1255608 C=811259 G=785749 T=1248830

# Select only the first sequence, or the one whose defline matches a regex
$ uf | uf-select 1
$ uf | uf-select 'Acinetobacter'

# Various ways of cutting from a sequence
$ uf | uf-cut 1200/1000'  Selects the 1000 bases starting at position 1200
$ uf | uf-cut 5:-5        Trim four elements off of both ends
$ uf | uf-circut -50:50   Select 100 bases around the start of a circular sequence
$ uf | uf-circut 100:99   Select all bases, starting at pos 100 and wrapping around,
                          effectively rotating the sequence to start at 100

# Process just the content of each sequence, temporarily removing the FASTA deflines
uf file.fna | uf-bare | ..processing.. | uf-dress -r <(uf file.fna | uf-headers)
```

Unfasta won't work for everyone.  It does for me because I work in bash most of the time, and have used the Unix/GNU toolset for decades.  Over that period I have written software in at least a dozen 'proper' programming languages, but when it comes to string processing nothing beats piping together a one-liner in bash.

If you recognise this, then unfasta will work for you.  If not, spend some time with [the Art of the Command Line](https://github.com/jlevy/the-art-of-command-line) and you may become enlightened.

Find [Unfasta on GitHub](http://github.com/zwets/unfasta).

