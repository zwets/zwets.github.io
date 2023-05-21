---
title: Nano Cookbook - Course materials for 2023-05 SeqAfrica/FAO Nanopore workshop
excerpt: "Notebook with instructions for the May 2023 workshop at NMIMR Ghana: _Strengthening Microbial Risk Assessment for Food Safety and Antimicrobial Resistance Using Portable DNA Sequencing Technology_."
layout: page
updated: 2023-05-21
---

This page collects instructions for the May 2023 joint FAO/SeqAfrica workshop _"Strengthening Microbial Risk Assessment for Food Safety and Antimicrobial Resistance Using Portable DNA Sequencing Technology"_.  It's not a coursebook, rather a collection of recipes and copy-pasteable snippets to turn a plain laptop into a workstation that can process Nanopore runs of (pathogenic) bacterial isolates, all the way to actionable reports.

> These instructions were originally intended as the installation and user manual for the FAO-provided laptop and MinION sequencer.
> As timely delivery became increasingly uncertain, the instructions were broken into bite-size bits that could be assembled in various ways.
> There is a [road map](assets/NanoCourseRoadmap1.pdf) that shows how the bits are related.

## Road Map

{: .no_toc}
![course road map](assets/NanoCourseRoadmap1.jpg)
{:toc}

## Table of Contents

{: .no_toc}
* Table of Contents
{:toc}

See [the Art of the Command Line](https://github.com/jlevy/the-art-of-command-line).

## BLAST Links

* [All BLAST Documentation](http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs)
* [Blast+ Command Line Applications User Manual](http://www.ncbi.nlm.nih.gov/books/NBK1763/) (PDF)
* [NCBI C++ Toolkit](http://ncbi.github.io/cxx-toolkit/) book and code on GitHub, the [examples](http://ncbi.github.io/cxx-toolkit/pages/ch_demo) describe `id1_fetch`.

The command-line options for the Blast+ CLI Tools.  Taken from the [User Manual](http://www.ncbi.nlm.nih.gov/books/NBK1763/)
because the tools lack individual manpages and information is spread all over.

**NOTE: documentation below applies to the 2.2 version, which is current in Ubuntu 16.04.  NCBI released 2.5 in late 2016 when they switched to https for remote queries, and after recently having moved from _gi_ to _accession_ as the primary identifier.  Features such as `-gilist` may have been deprecated together with the abolishment of the GI.**

