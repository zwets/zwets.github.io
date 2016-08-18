---
title: OpenCL on a dual graphics Dell M4800
layout: post
excerpt: "Documenting how I got OpenCL working on my dual graphics Dell M4800 workstation running plain vanilla Ubuntu 16.04."
published: true
---


This post documents how I got OpenCL working on Ubuntu 16.04 on my dual (hybrid) graphics Dell M4800
workstation.  The machine has an integrated Intel HD Graphics 4600 GPU, and a discrete AMD/ATI Radeon HD 8870M.


## Background

[Caffe](http://caffe.berkelyvision.org) can transparently switch between CPU and GPU for its computations.
Caffe's [master branch](https://github.com/BVLC/caffe) is bound to NVidia.
Its [OpenCL branch](https://github.com/BVLC/caffe/tree/opencl) is in development and should support all
vendors through the OpenCL standard.

I prefer to keep my Ubuntu 16.04 plain vanilla, that is stick with packages available in the distro.[^1]
I avoid PPAs, `sudo make install` and certainly `sudo ./run-installer.sh`.  My worry was that installing
OpenCL would involve a lot of the latter, but it turned out that `apt-get install` gets you a long way.

Below is my install log. YMMV.


## Exploring the GPUs

My Dell M4800 has dual graphics:

```bash
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 4th Gen Core Processor Integrated Graphics Controller (rev 06)
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Venus XT [Radeon HD 8870M / R9 M270X/M370X] (rev ff)
```

Ubuntu suggests no proprietary drivers for my GPUs:

```bash
$ ubuntu-drivers list
intel-microcode		# Driver for the CPU, not the GPU
```

The DRM driver modules are `i915` and `radeon`; they participate in kernel mode switching:

```bash
$ lsmod | grep drm_kms_helper
drm_kms_helper        147456  2 i915,radeon
$ dpkg -S i915.ko radeon.ko | grep $(uname -r)
linux-image-extra-4.4.0-34-generic: /lib/modules/4.4.0-34-generic/kernel/drivers/gpu/drm/i915/i915.ko
linux-image-extra-4.4.0-34-generic: /lib/modules/4.4.0-34-generic/kernel/drivers/gpu/drm/radeon/radeon.ko
```

The Intel integrated GPU (IGD) is powered on, the AMD discrete GPU (DIS) is idle:

```bash
$ sudo cat /sys/kernel/debug/vgaswitcheroo/switch
0:DIS: :DynOff:0000:01:00.0
1:IGD:+:Pwr:0000:00:02.0
2:DIS-Audio: :Off:0000:01:00.1
```
(`vga_switcheroo` is the legacy kludge for hybrid graphics systems.  It is being replaced by
'muxless hybrid graphics', however switcheroo's kernel interface is still there.)


## Sidestep: muxless graphics switching

This section is not directly relevant for OpenCL.  It documents how to switch from the integrated GPU
to the discrete GPU for rendering.  This is now much simpler than in the switcheroo-days, and can even
be done for a single application.  All it requires is setting an environment variable. 

```bash
$ xrandr --listproviders
Providers: number : 3
Provider 0: id: 0x72 cap: 0x9, Source Output, Sink Offload crtcs: 4 outputs: 5 associated providers: 2 name:Intel
Provider 1: id: 0x49 cap: 0x6, Sink Output, Source Offload crtcs: 6 outputs: 4 associated providers: 2 name:VERDE @ pci:0000:01:00.0
Provider 2: id: 0x49 cap: 0x6, Sink Output, Source Offload crtcs: 6 outputs: 4 associated providers: 2 name:VERDE @ pci:0000:01:00.0

$ DRI_PRIME=0 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Mesa DRI Intel(R) Haswell Mobile        # Intel renders
305 frames in 5.0 seconds = 60.871 FPS                  # at rate synced with monitor

$ DRI_PRIME=1 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Gallium 0.4 on AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
70041 frames in 5.0 seconds = 14008.121 FPS             # AMD renders ... faster

$ DRI_PRIME=2 glxgears -info | grep -E '(GL_RENDERER|FPS)'
GL_RENDERER   = Mesa DRI Intel(R) Haswell Mobile 	# Surprise: Intel renders,
53971 frames in 5.0 seconds = 10793.093 FPS		# but this time not synced to 60Hz
```

When `DRI_PRIME` is 0 or unset, the Intel is selected.  Its rendering frequency is 60Hz,
synchronised with the monitor refresh rate.  `DRI_PRIME=1` selects the AMD Radeon.
`DRI_PRIME=2` (or any higher value) selects the Intel, but without synchronised rendering.

I was surprised to see the high frame rate on the IGD.  Even if it is 30% below the discrete
GPU, it is still considerable.  Just because it is an integrated GPU, doesn't mean that it can't
be used for computing.

It will be interesting to see what frame rates can be achieved with the AMD proprietary
(Catalyst) driver.  We'll get back to that.


**Note:** According to 
[this page](http://askubuntu.com/questions/593098/hybrid-graphic-card-drivers-amd-radeon-hd-8570-intel-hd-graphics-4000/620756#620756)
it is required to do `xrandr --setprovideroffloadsink` to make `DRI_PRIME` work, 
but I get the exact same results when I don't.  ([May be related to DRI3?](https://wiki.archlinux.org/index.php/PRIME))


## Installing OpenCL

Installing OpenCL involves three layers: 

* the API library and implementation loader (ICD Loader)
* one or more vendor-specific implementations (ICDs)
* DRM/DRI hardware device drivers

Installing `clinfo` pulls in package `ocl-icd-libopencl1` which sets up the top layer of the
OpenCL infrastructure:

```bash
$ sudo apt-get install clinfo
$ clinfo
Number of platforms   0
```

Package `ocl-icd-libopencl1` provides `libOpenCL`, the library against which OpenCL applications
are linked.  It provides the ICD Loader, the machinery that dynamically loads ICDs.  The ICDs
(installable client drivers) implement the vendor-specific interaction with the hardware.

An ICD is defined by a file with extension `.icd` in directory `/etc/OpenCL/vendors`.  The
first line in the ICD file specifies the path to a shared library.  The ICD Loader `dlopen`s
this library when that platform is requested.  Environment variables regulate the order of the
platforms, the default, and the debugging level.


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
$ clinfo -l
$ clinfo -l
Platform #0: Intel Gen OCL Driver
 `-- Device #0: Intel(R) HD Graphics Haswell GT2 Mobile
Platform #1: Clover
 `-- Device #0: AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
```

`clinfo --human` and `clinfo --raw` produce detailed overviews of the features of the
platforms.  @@@ TODO @@@ table comparing the significant differences.


## Hitting the asfalt

Andreas Klöckner's wiki has an [OpenCL HOWTO](https://wiki.tiker.net/OpenCLHowTo) which
links to demo code (tools-master) for testing OpenCL.  His site has 
[lots more](https://wiki.tiker.net/WelcomePage) on OpenCL, CUDA, PyOpenCL, Numpy, Boost, 
etc.

Erik Smistad has a nice 
[hands-on article](https://www.eriksmistad.no/getting-started-with-opencl-and-gpu-computing/)
with C sample code.  It is from 2010 so may be out of date.

@@@ TODO @@@

## Installing the AMD Catalyst driver

## Installing the AMD Accelerated Parallel Processing (APP) SDK

* [AMD OpenCL Zone](http://developer.amd.com/tools-and-sdks/opencl-zone/opencl-resources/getting-started-with-opencl/)
* [AMD APP SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/)
* [AMD Catalyst Driver](http://www.amd.com/en-us/innovations/software-technologies/technologies-gaming/catalyst)


## Further steps

* StarPU
* erlang-cl, pyopencl
* arrayfire, 

###### Footnotes

[^1]: For out-of-distro software or cutting-edge version I use [GNU Guix](https://guix.gnu.org/) which
perfectly isolates these without being the kludge that containers are.

