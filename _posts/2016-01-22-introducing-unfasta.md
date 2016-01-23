---
title: Introducing Unfasta 
permalink: /unfasta/
layout: post
---

[Unfasta](http://github.com/zwets/unfasta) is a suite of command-line utilities for working with sequence data.

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

Unfasta resolves the issue by converting FASTA format to 'unfasta format' when it enters the pipeline.  The unfasta format is FASTA without line breaks in the sequence data.  Note that [unfasta files are still valid FASTA files](https://github.com/zwets/unfasta/blob/master/README.md#unfasta-is-fasta).

Some examples to illustrate the benefits of single-line sequence data:

{% highlight bash %}
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
{% endhighlight %}

Unfasta isn't intended as the be-all and end-all of genomic sequence processing.  It won't work for everyone.  It does for me because I usually work in bash and have been using the Unix/GNU toolset for over two decades.  In that same period I have written software in at least a dozen 'proper' programming languages, but when it comes to string processing nothing beats piping together a one-liner in bash.

If you recognise this, then unfasta will work for you.  If your natural preference is to work in a graphical user environment, then unfasta may be just the occasion to get out of your comfort zone and discover the beauty and power of the command line.

Find [Unfasta on GitHub](http://github.com/zwets/unfasta).

