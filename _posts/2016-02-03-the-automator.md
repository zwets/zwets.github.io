---
title: The Automator
layout: post
excerpt: "The first time around is for exploration, the second time you recognise repetition, the third time you automate.  Recognise this?"
published: true
updated: 2016-12-29
---

In the early days of commercial IT in the Netherlands, before English became the standard vocabulary in the field that was later to be called "IT", the Dutch language had its own word for IT.  IT was called *automation* (automatisering) and people working in automation were called *automators* (automatiseerders).

The words now sound old-fashioned and have gotten into disuse to the extent that my children would conjure up an image of [Schwarzenegger](https://www.imdb.com/character/ch0000931/) or [Doofenschmirz](https://www.imdb.com/character/ch0111656/) if I would tell them I am an **automator**.  

I like the term "automation" for our field of work.  It stresses the *purpose* of what we do rather than the means we use.  I am very much an automator.

> The first time around explore, the second time recognise repetition, the third time automate.  

Much of what I keep in my [public repositories](https://github.com/zwets) are shell scripts wrapping tedious, error-prone, or repetitious operations.  I initially wrote these for my own use, but I've tried to make them useful for others[^1].  They are operationalised documentation.  When you need to keep notes anyway[^2], it pays to put in the extra effort to condense all NTK into an executable script.  It's like having unit tests for your notes.

###### Footnotes

[^1]: [taxo](https://github.com/zwets/taxo) to search and browse the NCBI taxonomy, [unfasta](https://io.zwets.it/unfasta) for natural handling of FASTA in command line pipes and filters, and a collection of scripts built on top of BLAST in [blast-galley](https://github.com/zwets/blast-galley) to e.g. [cut genes out of an unannotated assembly](https://github.com/zwets/blast-galley/blob/master/gene-cutter) or do simple [in-silico PCR](https://github.com/zwets/blast-galley/blob/master/in-silico-pcr.sh).

[^2]: You don't?  I'd hold off the cheers until you cross the age of forty.

*[NTK]: Need To Knows
