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

General Tips on ONT software:

 * New releases (and bugs, and changes!) are announced through the [ONT Community Site](https://nanoporetech.com/community)
 * Make sure you have a login there (linked to your institute's account with ONT) and _check in regularly_
 * ONT have an Ubuntu repository, which makes installing & updating easy, but it's ... a work in progress and not without glitches

### Adding the ONT repositories

Add the ONT repository to the APT sources

    # Note this says 'focal' (= 20.04) but it actually supports 'jammy' (22.04)
    echo 'deb http://cdn.oxfordnanoportal.com/apt focal-stable non-free' | sudo tee /etc/apt/sources.list.d/ont-repo.list

Add ONT's GPG package signing key APT's trusted keys:

    wget -O - https://mirror.oxfordnanoportal.com/apt/ont-repo.pub | sudo tee /etc/apt/trusted.gpg.d/ont-repo.asc

Update APT's cache of available software:

    sudo apt update

### Installing MinKNOW

MinKNOW is the GUI tool to set up and perform MinION sequencing runs.  Installing MinKNOW pulls
the Guppy basecaller (see below) and other software as well.

The package to install, once you have [added the ONT repositories](#adding-the-ont-repositories), is (as of last week):

    # On machines WITH an NVidia GPU (see the Guppy documentation below)
    sudo apt install ont-standalone-minknow-release-gpu

    # On machines without an NVidia GPU
    sudo apt install ont-standalone-minknow-release

**IMPORTANT** if you insta


### Running MinKNOW


## Run to Reads

To convert the FAST5 from the run 
MinKNOW requires a GPU (Graphics Processing Unit) for its basecall
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



## Installation Dos and Donts

 * *Always* prefer `sudo apt install` 

   * Try the command you need in the command-line, Ubuntu will suggest the package
   * Or use `apt search ...`
   * Then just `sudo apt install` the package
   * Deinstallation is `sudo apt remove ...` (or `purge`)

 * If not in Ubuntu, but available in a Debian/Ubuntu repository (e.g. ONT software, R CRAN):

   * Check that their target release is (close to) your current Ubuntu Release (22.04 = `jammy`)
   * Add the repository URL in `/etc/apt/sources.list.d/...`
   * `sudo apt update`
   * `sudo apt install` as above
   * Be aware that their software _may_ conflict with Ubuntu software, miss dependencies, etc

 * Otherwise, if precompiled binary available (e.g. `polypolish`):

   * Download and drop in your `~/bin`
   * Or drop (as root) in `/usr/local/bin` 
   * But note that both override `/usr/bin` (i.e. a possible later `apt install`)
   * Use `which ...` or `command -v ...` to find out which would be called
   * Deinstallation is `rm ~/bin/...`

 * Otherwise, if sources but single binary that can be easily compiled (e.g. `kma`, `flye`):

   * Git clone its repository: `git clone ...`
   * `cd kma && make`
   * Then either symlink the resulting binary from `~/bin`, or continue as for precompiled binary

 * Otherwise, if the package is "Python installable" (`pip`, `pypi`, `python setup.py`, etc):

   * If it has an `environment.yaml` (e.g. `pangolin`), use that to do everything
   * Else always install in a Conda environment of its own
     * Setup Conda (see below) 
     * Create new environment with requirements pre-installed: `conda create -n MYENV PKG1 PKG2 ...`
     * Requirements usually listed in the `README`, in `requirements.txt` or `setup.py`
   * Then `conda activate MYEMV`
   * Only then `python setup.py install` (or `pip install`, etc)

 * Fall back to Docker (or Conda, below):

   * If a prebuilt Docker image is available: `docker pull ...`
   * If a Dockerfile is available: `docker build ...`
   * Avoid running Docker containers as `root` (when they produce output on your filesystem):

        docker run --rm -u $(id -u):$(id -g) IMAGE [ARGS]

   * Running an Ubuntu shell in a Docker container

        docker pull ubuntu:22.04
        docker run -ti --rm ubuntu:22.04 bash -l   # you will be root (but locked inside)

 * Fall back to Conda:

   * Install `miniconda` (or `anaconda`) according to [their instructions](https://docs.conda.io/en/latest/miniconda.html)
   * Install `mamba` in the Conda `base` environment, according to [their instructions](https://mamba.readthedocs.io/en/latest/installation.html)
   * Use `mamba` whenever you would use `conda` (much faster)
   * Disable auto-activation of the Conda base environment

        echo 'auto_activate_base: false' >> ~/.condarc

   * **Never** install things in Conda `base`, always in newly created environments

        mamba create -n MYENV [PACKAGES TO INSTALL]
        mamba activate ENVNAME

   * Installing additional Python packages in an existing Conda env

        mamba activate ENVNAME
        mamba install ...
        or: pip, pypi, setup.py, easy_install etc

 * At all times avoid `sudo make install` and (even more) `wget https://get-something.org | sudo sh -`

