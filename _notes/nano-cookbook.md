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
> The order of presentation intermixes installation and usage instructions, which means we sometimes need to hop forward and backward through this guide.
> Use the road map and [table of contents](#table-of-contents) to find your way back when lost.


## Road Map

![course road map](assets/NanoCourseRoadmap1.jpg)

## Table of Contents

* Table of Contents
{:toc}


## Prerequisites

### Knowledge

The instructions here assume basic familiarity with the Linux shell, a.k.a. the command-line (interface), a.k.a. the CLI, as was covered in last year's training.

To jog your recollection, check that [modules 1.1 through 1.3 in the CLI course overview](https://share.kcri.it/sites/cli-course) hold few surprises, and check that the concepts from module 2 look reasonably familiar.  We will be seeing a lot of those here.

To learn more about the CLI, remember:

 * `man COMMAND` and `COMMAND --help` get you a long way
 * [GIYF](https://en.wiktionary.org/wiki/GIYF), and [AskUbuntu](https://askubuntu.com/) has many answers and helpful people (be sure to read [how to ask questions]() first).
 * A very complete on-line CLI course is [LinuxCommand.org](https://linuxcommand.org/)
 * If you spend a lot of time in the CLI, study [the Art of the Command Line](https://github.com/jlevy/the-art-of-command-line).
 
### Computer

The instructions here were intended for a plain Ubuntu Desktop laptop (to be installed by you over the course of the workshop).
Lacking that, we propose you use either use an Ubuntu 22.04 Virtual Machine (see [VirtualBox](#virtualbox) below),
or a shell into an Ubuntu 22.04 Docker container (see [Ubuntu Docker](#ubuntu-docker) below).


## Getting a CLI (recap)

### Local: Gnome Terminal

#### Opening a Terminal

 * Click the Ubuntu "Apps" button and start typing "terminal"
 * Once it shows, right click and "Add to Favourites"
 * From now on, the terminal icon is in the Ubuntu dock

#### Multiple terminals

 * Inside Gnome Terminal, press `Ctrl+T` and a second tab opens
 * Switch between tabbed terminals: press `Ctrl+PgUp/PgDn`

### Remote: SSH

Opening a shell into a remote host:

 * `ssh [user@]host`

#### Automating your SSH login: key pairs

 * Generate a key pair (if you don't already have one): `ssh-keygen -t ed25519` (pick a secure password and make sure to remember it!)
 * Copy the public key to the remote host: `ssh-copy-id [user@]host` (and type the _remote password_, not the private password you just set on your key)
 * From now on `ssh [user@]host` (on your machine) will use the key pair
 * Same key pair can safely be used with all your remote hosts (your own "SSO": one password for all hosts - which Ubuntu Desktop helpfully caches!)
 * Also needed when you set up a GitHub (GitLab, Bitbucket, etc) account

#### Multiple _remote_ shells: `screen`

Either open another Gnome Terminal and `ssh` in from that, or _inside the SSH session_ use `screen`.

The `screen` (or `tmux`) utility 'multiplexes' multiple shells in a single terminal session.

 * **Tip** start `screen` whenever you login over `ssh`
 * To start: inside any terminal, type `screen`
 * Create a new terminal: `Ctrl+A`, then `C`
 * Switching terminals: `Ctrl+A` then `A`
 * More than two terminals: `Ctrl+A` then `1`, `2`, etc., or `Ctrl+A` then `=` for a list
 * Exit the `ssh` session _but keep screen session running_: `Ctrl+A` then `DD`.
 * Reconnecting to that session: `ssh` in, then `screen -DRRU` (see `man screen` for meaning)


## Sequencing: MinKNOW

### Installing MinKNOW

Adding the ONT Ubuntu repositories:

```bash


```

### Running MinKNOW


## Run to Reads

### Basecalling

### Demultiplexing

### Joining FastQ


## Reads QC

### Metrics

The go-to tool for reads QC is `FastQC`.

FastQC is showing its age

### Contamination



## Reads to Assembly (= Genome)

### Flye

### Medaka


## Assembly to Analysis

Once you have the assembled genome (assuming your run and reads passed QC), you can use it like any other assembly.

We won't get 
  analysis directly from Nanopore reads needs special attention (compared to ), once you have an assembled genome, you can in principle apply any analysis takes assemblies as input.


## Reads to Analysis


