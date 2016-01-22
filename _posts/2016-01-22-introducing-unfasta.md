---
title: Introducing Unfasta 
permalink: /unfasta/
layout: post
---

*Command-line pipes and filters for genomic sequence data.*

Unfasta is a suite of command-line utilities for working with sequence data.

The rationale behind unfasta is to have the ability to process genomic sequence data using simple standard utilities like `grep`, `cut` and `head`, in the common [pipes and filters style](http://www.dossier-andreas.net/software_architecture/pipe_and_filter.html) of Unix and GNU.

For instance,

{% highlight bash %}
# Compute the GC content of all sequences in a FASTA file
uf 'file.fa' | sed -n '2~2p' | tr -dc 'GC' | wc -c
{% endhighlight %}

In that pipeline,

* `uf` reads a FASTA file and outputs it in 'unfasta' format, collapsing sequence data to single lines;
* `sed -n 2~2p` filters every second line from its input, thus dropping the header lines;
* `tr -dc GC` drops from its input all characters except `G` and `C`;
* and `wc -c` counts the number of characters it reads, then writes this to standard output.

Pipelines are a simple and powerful way to process large streams of data, but the FASTA format is the party pooper.  By allowing sequences to span multiple lines, FASTA defies processing by line-oriented standard tools.  Even a seemingly obvious `fgrep -q 'GAATCATCTTTA'` fails with a false negative in 10-15% of cases.  Unfasta originated from frustration over this missed opportunity.

Unfasta solves the issue by converting FASTA format to 'unfasta format' when it enters the pipeline.  The unfasta format is simply FASTA without line breaks in the sequence data.  Note that [unfasta files are still valid FASTA files](https://github.com/zwets/unfasta/blob/master/README.md#unfasta-is-fasta).

Unfasta isn't intended as the be-all and end-all of genomic sequence processing.  It won't work for everyone.  It does for me because I usually work in bash and have been using the Unix/GNU toolset for twenty years.  Over that period I have written software in at least a dozen 'proper' programming languages, but when it comes to string processing nothing beats piping together a one-liner in bash.

If you recognise this, then unfasta will work for you.  If your natural preference is to work in a graphical user environment, then unfasta may be just the occasion to get out of your comfort zone and discover the beauty and power of the command line.  They'll get you hooked.

Find [Unfasta on GitHub](http://github.com/zwets/unfasta).

