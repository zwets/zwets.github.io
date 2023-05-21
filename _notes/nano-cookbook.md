---
title: Nano Cookbook - course materials
excerpt: "Notebook with instructions for May 2023 workshop 'Strengthening Microbial Risk Assessment for Food Safety and Antimicrobial Resistance Using Portable DNA Sequencing Technology'
layout: page
updated: 2023-05-21
---

{: .no_toc}
## Nano Cookbook

This page collects instructions for the May 2023 joint FAO/SeqAfrica workshop _"Strengthening Microbial Risk Assessment for Food Safety and Antimicrobial Resistance Using Portable DNA Sequencing Technology"_.  It's not a coursebook, rather a collection of recipes and copy-pasteable snippets to turn a plain laptop into a workstation that can process Nanopore runs of (pathogenic) bacterial isolates, all the way to actionable reports.

> These instructions were originally intended as the installation and user manual for the FAO-provided laptop and MinION sequencer.
> As timely delivery became uncertain, the instructions were broken into bite-size bits that could be assembled in various ways.
>
> The order of presentation is
> Use the road map and [table of contents](#table-of-contents) to find your way back when lost.

## Road Map

![course road map](assets/NanoCourseRoadmap1.jpg)
{:toc}

## Table of Contents

* Table of Contents
{:toc}

## Prerequisites

### Knowledge

The instructions here assume basic familiarity with the Linux shell, a.k.a. the command-line (interface), a.k.a. the CLI, as was covered in last year's training.

To jog your recollection, check that [modules 1.1 through 1.3 in the CLI course overview](https://share.kcri.it/sites/cli-course) hold few surprises, and that the concepts from module 2 are reasonably familiar.  We will be seeing a lot of those here.

To learn more about the CLI, remember:

 * `man COMMAND` and `COMMAND --help` get you a long way
 * [GIYF](https://en.wiktionary.org/wiki/GIYF), and [AskUbuntu](https://askubuntu.com/) have many answers and helpful people (be sure to read [how to ask questions]() first).
 * A great on-line course is [LinuxCommand.org](https://linuxcommand.org/)
 * If you spend a lot of time in the CLI, study [the Art of the Command Line](https://github.com/jlevy/the-art-of-command-line).
 
### Computer

The


### Opening a terminal

### Using multiple terminals

### Remote shell (ssh)

### Using multiple remo


## Sequencing: MinKNOW

### Installing MinKNOW

### Running MinKNOW


## Run to Reads

### Basecalling

### Demultiplexing

### Joining FastQ


## Reads QC


## Reads to Assembly (= Genome)

### Flye

### Medaka


## Assembly to Analysis

Whereas analysis directly from Nanopore reads needs special attention (compared to ), once you have an assembled genome, you can in principle apply any analysis takes assemblies as input.


## Reads to Analysis


