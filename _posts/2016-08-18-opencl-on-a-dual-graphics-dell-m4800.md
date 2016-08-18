---
title: OpenCL on a dual graphics Dell M4800
layout: post
excerpt: "Documenting how I got OpenCL working on my dual graphics Dell M4800 workstation running plain vanilla Ubuntu 16.04."
published: true
---


This post documents how I got OpenCL working on a dual graphics Dell M4800 workstation running Ubuntu 16.04.


## Background

[Caffe](http://caffe.berkelyvision.org) can transparently switch between CPU and GPU for its computations.
Caffe's [master branch](https://github.com/BVLC/caffe) is bound to NVidia.
Its [OpenCL branch](https://github.com/BVLC/caffe/tree/opencl) is in development and should support all
vendors through the OpenCL standard.

I prefer to keep my Ubuntu 16.04 plain vanilla, that is stick with packages available in the distro.[^1]
I avoid PPAs, `sudo make install` and certainly `sudo ./run-installer.sh`.  My worry was that installing
OpenCL would involve a lot of the latter, but it turned out that `apt-get install` goes a long way.

Below is my install log. YMMV.


## Exploring the GPUs

My Dell M4800 has dual graphics:

```bash
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 4th Gen Core Processor Integrated Graphics Controller (rev 06)
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Venus XT [Radeon HD 8870M / R9 M270X/M370X] (rev ff)
```

Ubuntu does not suggest proprietary drivers for my GPUs:

```bash
$ ubuntu-drivers list
intel-microcode		# Driver for the CPU, not the GPU
```

Instead the open source drivers from the kernel tree are in use and under control of kernel mode switching:

```bash
$ lsmod | grep drm_kms_helper
drm_kms_helper        147456  2 i915,radeon
$ dpkg -S i915.ko radeon.ko | grep $(uname -r)
linux-image-extra-4.4.0-34-generic: /lib/modules/4.4.0-34-generic/kernel/drivers/gpu/drm/i915/i915.ko
linux-image-extra-4.4.0-34-generic: /lib/modules/4.4.0-34-generic/kernel/drivers/gpu/drm/radeon/radeon.ko
```

By default the Intel IGD is powered on, the AMD 'discrete' card is idle (`vgaswitcheroo` is a legacy method
for switching between GPUs; its kernel interface is still there):

```bash
$ sudo cat /sys/kernel/debug/vgaswitcheroo/switch
0:DIS: :DynOff:0000:01:00.0
1:IGD:+:Pwr:0000:00:02.0
2:DIS-Audio: :Off:0000:01:00.1
```


## Sidestep: switching graphics rendering

Switching between the Intel IGD and the AMD Radeon for graphics rendering is simpler than it used to be:

```bash
$ xrandr --listproviders
Providers: number : 3
Provider 0: id: 0x72 cap: 0x9, Source Output, Sink Offload crtcs: 4 outputs: 5 associated providers: 2 name:Intel
Provider 1: id: 0x49 cap: 0x6, Sink Output, Source Offload crtcs: 6 outputs: 4 associated providers: 2 name:VERDE @ pci:0000:01:00.0
Provider 2: id: 0x49 cap: 0x6, Sink Output, Source Offload crtcs: 6 outputs: 4 associated providers: 2 name:VERDE @ pci:0000:01:00.0

$ DRI_PRIME=0 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Mesa DRI Intel(R) Haswell Mobile 
305 frames in 5.0 seconds = 60.871 FPS

$ DRI_PRIME=1 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Gallium 0.4 on AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
70041 frames in 5.0 seconds = 14008.121 FPS
```

Note that according to 
[this page](http://askubuntu.com/questions/593098/hybrid-graphic-card-drivers-amd-radeon-hd-8570-intel-hd-graphics-4000/620756#620756)
we must first do `xrandr --setprovideroffloadsink 0x49 0x72` to make device 0x49 (*VERDE* is the
codename for my AMD card) the rendering offload device for the Intel, but I get the exact same
results when I don't. ([May be related to DRI3?](https://wiki.archlinux.org/index.php/PRIME))

While `glxgears` is running the DIS card is powered on (`sudo cat /sys/kernel/debug/vgaswitcheroo/switch`),
and you could use `sudo radeontop` to see some live statistics.

A interesting finding is that when `DRI_PRIME=0` or unset, the rendering frequency is synchronised
with the monitor refresh rate, whereas when I set `DRI_PRIME=2` (or any higher value), I get the
Intel renderer but without the synchronised rendering:

```bash
$ DRI_PRIME=42 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Mesa DRI Intel(R) Haswell Mobile 
53971 frames in 5.0 seconds = 10793.093 FPS
```

Though 30% lower than the discrete card (with the open source driver), its frame rate is still
considerable.  As we'll see, just because it is an integrated GPU, doesn't mean that it is a dud
for parallel computing.


## Installing OpenCL

Back to OpenCL.  Installing `clinfo` pulls in package `ocl-icd-libopencl1` which sets up the basic
OpenCL infrastructure:

```bash
$ sudo apt-get install clinfo
$ clinfo
Number of platforms   0
```

Package `ocl-icd-libopencl1` provides `libOpenCL`, the library against which OpenCL applications
are linked.  It provides the *ICD Loader*, the machinery that dynamically loads "ICDs", the 
installable client drivers which implement the vendor-specific interaction with the hardware.

Each ICD is defined by a file with extension **.icd** in directory `/etc/OpenCL/vendors`.  The
first line in the ICD file specifies the path to a shared library which is `dlopen`ed by the ICD
Loader when that platform is requested.  Environment variables can be used to influence platform
order, default, and debugging level (see `man libOpenCL`).


## Installing ICDs

Ubuntu provides ICDs for Intel and Nvidia GPUs.  AMD is supported via the Mesa ICP, which 
implements OpenCL in terms of the free (non-proprietary) DRM/DRI drivers.

```bash
$ apt-cache search '^opencl-icd$'
beignet-opencl-icd - OpenCL library for Intel GPUs
nvidia-opencl-icd-304 - NVIDIA OpenCL ICD
mesa-opencl-icd - free implementation of the OpenCL API -- ICD runtime
... more ...
$ apt-cache show beignet-opencl-icd
... supports the integrated GPUs of Ivy Bridge, Bay Trail, Haswell and Broadwell processors
$ apt-cache depends mesa-opencl-icd
... r600, amdgcn, amdgpu1, radeon1, nouveau2 ...
```

Installing the Intel and Mesa ICDs gives us two platforms:

```bash
$ sudo apt-get install beignet-opencl-icd mesa-opencl-icd
$ clinfo
Number of platforms   2
... lots of details about the platforms ...
```

@@@ MORE @@@


## Installing the AMD SDK

* [AMD OpenCL Zone](http://developer.amd.com/tools-and-sdks/opencl-zone/opencl-resources/getting-started-with-opencl/)
* [AMD APP SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/)
* [AMD Catalyst Driver](http://www.amd.com/en-us/innovations/software-technologies/technologies-gaming/catalyst)



I run plain Ubuntu 16.04 and prefer not to install 


integrated Intel GPU and an AMD ATI Radeon runs plain Ubuntu 16.04.

Intel and AMD both have an OpenCL SDK.

### Drivers, ICDs and OpenCL

### Ubuntu OpenCL packages


###### Footnotes

[^1]: For out-of-distro software or cutting-edge version I use [GNU Guix](https://guix.gnu.org/) which
perfectly isolates these without being the kludge that containers are.

