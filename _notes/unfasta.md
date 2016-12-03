---
title: unfasta - FASTA without the pesky line breaks
excerpt: "Unfasta is a suite of command-line utilities for working with FASTA files in the common pipes and filters style of Unix and GNU."
published: true
ignore: { permalink }
---

[Unfasta](http://github.com/zwets/unfasta) is a suite of command-line utilities for working with FASTA sequence data in the common "pipes and filters" style of Unix and GNU.  The unfasta 'file format' is FASTA without line breaks in sequences.  Every odd line in an unfasta file is a header (aka defline, title), and every even line is a sequence.  Unfasta files are still valid FASTA, they're just more convenient for stream processing.

Read more about unfasta [here](http://io.zwets.it/2016/01/22/introducing-unfasta/) or at its source code repository <https://github.com/zwets/unfasta>.  Unfasta is free and open source software released under GPL v3+.

