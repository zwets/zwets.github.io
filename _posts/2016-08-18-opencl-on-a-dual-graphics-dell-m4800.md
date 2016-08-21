---
title: OpenCL on a dual graphics Dell M4800
layout: post
excerpt: "Documenting how I got OpenCL working on Ubuntu 16.04 on my dual graphics Dell M4800 workstation."
published: true
---


This post documents how I got OpenCL working on Ubuntu 16.04 on my dual (hybrid) graphics Dell M4800
workstation.  The machine has an integrated Intel HD Graphics 4600 GPU, and a discrete AMD/ATI Radeon HD 8870M.


## Background

[Caffe](http://caffe.berkelyvision.org) can transparently switch between CPU and GPU for its computations.
Caffe's [master branch](https://github.com/BVLC/caffe) is bound to NVidia.
Its [OpenCL branch](https://github.com/BVLC/caffe/tree/opencl) is in development and should support all
vendors through the OpenCL standard.

I prefer to keep my Ubuntu 16.04 plain vanilla, that is stick with packages available in the distro.
I avoid PPAs, `sudo make install` and certainly `sudo ./run-installer.sh`.[^1]  My worry was that
installing OpenCL would involve a lot of the latter, but it turned out that `apt-get install` gets
you a long way.

Below is my install log. YMMV.


## Exploring the GPUs

My Dell M4800 has dual Intel/AMD graphics:

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

The DRM driver modules are `i915` and `radeon` which come with the kernel:

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
(Note: `vga_switcheroo` is the legacy kludge for hybrid graphics systems exposed by the `radeon` module.)


## Sidestep: graphics switching

This section is about Open*GL* rather than OpenCL.  I include it to document how simple it has
become to switch to the discrete GPU for rendering.  This can even be done for a single application,
and all it requires is setting an environment variable.

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
GL_RENDERER   = Mesa DRI Intel(R) Haswell Mobile 	# Surprise: Intel renders
53971 frames in 5.0 seconds = 10793.093 FPS		# without the syncing
```

When `DRI_PRIME` is 0 or unset, the Intel is selected.  Its rendering frequency is 60Hz,
synchronised with the monitor refresh rate.  `DRI_PRIME=1` selects the AMD discrete card.
`DRI_PRIME=2` (for some reason) selects the Intel, but without synchronised rendering.

I was surprised to see the high frame rate on the IGD.  Even if it is 30% below the DIS,
it is still considerable.  Just because it is an integrated GPU, doesn't mean that it can't
be used for computing.

**Note:** According to 
[this page](http://askubuntu.com/questions/593098/hybrid-graphic-card-drivers-amd-radeon-hd-8570-intel-hd-graphics-4000/620756#620756)
it is required to do `xrandr --setprovideroffloadsink` to make `DRI_PRIME` work, 
but I get the exact same results when I don't.  ([May be related to DRI3?](https://wiki.archlinux.org/index.php/PRIME))


## Installing OpenCL

Installing OpenCL involves three layers: 

* the API library and implementation loader (ICD Loader)
* one or more vendor-specific platform implementations (ICDs, installable client drivers)
* any DRM/DRI hardware device drivers required by the ICDs

The top layer is provided by Ubuntu package `ocl-icd-libopencl1`.  This package contains 
`libOpenCL`, the API library against which OpenCL applications are linked.  It also provides
the ICD Loader, the machinery that dynamically loads ICDs, installable client drivers
implementing the vendor-specific interaction with the hardware.

It is convenient to also install the `clinfo` utility which queries the API library about
available platforms:

```bash
$ sudo apt-get install clinfo ocl-icd-libopencl1
$ clinfo
Number of platforms   0   # We haven't installed ICDs yet
```

Each ICD is defined by a file with extension `.icd` in directory `/etc/OpenCL/vendors`.  The
first line in the ICD file specifies the path to a shared library.  The ICD Loader `dlopen`s
this library when the platform is requested.  Environment variables regulate the order of the
platforms, the default platform, and the debugging level.  See `man libOpenCL` for details.


## Installing ICDs

Ubuntu provides ICDs for Intel and Nvidia GPUs.  AMD is supported via the Mesa ICP, which 
implements OpenCL in terms of the free (non-proprietary) DRM/DRI drivers:

```bash
$ apt-cache search '^opencl-icd$'  # virtual package provided by all ICDs
beignet-opencl-icd - OpenCL library for Intel GPUs
mesa-opencl-icd - free implementation of the OpenCL API -- ICD runtime
nvidia-opencl-icd-304 - NVIDIA OpenCL ICD
... more nvidia versions ...

$ apt-cache show beignet-opencl-icd
... supports the integrated GPUs of Ivy Bridge, Bay Trail, Haswell and Broadwell processors

$ apt-cache depends mesa-opencl-icd
... r600, amdgcn, amdgpu1, radeon1, nouveau2 ...
```

Install the Intel and Mesa ICDs to obtain the relevant platforms:

```bash
$ sudo apt-get install beignet-opencl-icd mesa-opencl-icd
$ clinfo -l
Platform 0: Intel Gen OCL Driver
 `-- Device 0: Intel(R) HD Graphics Haswell GT2 Mobile
Platform 1: Clover
 `-- Device 0: AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
```

We have two OpenCL devices (supposedly) ready to rock!  Run `clinfo` without `-l` to get a
detailed overview of the platforms and the features of each device.


## Hitting the asphalt

Andreas Klöckner's wiki has an [OpenCL HOWTO](https://wiki.tiker.net/OpenCLHowTo) and
[lots more](https://wiki.tiker.net/WelcomePage) on OpenCL, CUDA, PyOpenCL, and the like.
His `cl-demo` application is perfect for a smoke test:

```bash
$ git clone 'https://github.com/hpc12/tools' hpc12-tools
$ cd hpc12-tools
$ make
$ ./cl-demo 1000000 10
Choose platform:
[0] Intel
[1] Mesa
Enter choice: 0
Choose device:
[0] Intel(R) HD Graphics Haswell GT2 Mobile
Enter choice: 0
... output ...
0.000824 s
14.566110 GB/s
GOOD
```

Good. Repeat for the Mesa/Clover platform:

```bash
$ ./cl-demo 1000000 10
... omitted for brevity ...
0.001086 s
11.053539 GB/s
GOOD
```

Good!  We have a working OpenCL system supporting both graphics cards, and needed only `apt-get install`
with no out-of-distro repositories.  The "nice to have" that's missing (given my requirements) is
**CPU** support.  (Caffe recommends using the CPU during development, then switching to GPU at deployment time.)


## Going beyond: installing CPU support

Unfortunately there isn't currently in Ubuntu an OpenCL ICD for Intel CPUs.  One used to come with the
fglrx driver but that package was dropped from Ubuntu (more on this below).  Both AMD and Intel offer an
OpenCL CPU driver, but it comes in proprietary installers which tend to bypass dpkg/APT.  Things however
are improving.

#### Intel's CPU driver

Intel's "OpenCL™ Runtime for Intel® Core™ and Intel® Xeon® Processors" can be downloaded from their
[OpenCL™ Drivers and Runtimes for Intel® Architecture](https://software.intel.com/en-us/articles/opencl-drivers) page.

[Here](https://bitbucket.org/snippets/bkchr/EkeMg) is a way to turn the installer into a .deb
(thus reducing the risk of overwriting files from other packages).  Also, note the comment at 
the bottom of that page mentioning that `install.sh` or `install_GUI.sh` should just work now
that Intel officially supports the driver on Ubuntu.  I haven't tested this.

#### AMD's CPU driver

AMD's CPU driver, which supports both AMD and Intel CPUs, comes 'for free' with their GPU driver.
This used to be **fglrx** (Catalyst) but it has been dropped from Ubuntu.  If you want to install
*just* the CPU driver there are two options:

* Download the [Catalyst driver for Radeon](http://www.amd.com/en-us/innovations/software-technologies/technologies-gaming/catalyst)
and extract the CPU parts according to 
[this hack](https://wiki.tiker.net/OpenCLHowTo#Installing_the_AMD_ICD_loader_and_CPU_ICD_.28from_the_driver_package--probably_unsupported.29)
by Andreas Klöckner.

* Simpler and more up to date, but in beta, is to download and unpack the 
[AMDGPU-Pro](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx),
driver (more on this below) and install *only* the ICD (`amdgpu-pro-opencl-icd_*.deb`):

```bash
$ wget 'https://www2.ati.com/drivers/linux/amdgpu-pro_16.30.3-315407.tar.xz'
  # note: link was current on 2016-08-20, check the AMDGPU-Pro page for latest
$ tar Jxvf amdgpu-pro_16.30.3-315407.tar.xz
$ cd amdgpu-pro-driver
$ sudo dpkg -i amdgpu-pro-opencl-icd_*_amd64.deb
```

This installs:

```
# The OpenCL ICD definition file for the AMD GPU platform
/etc/OpenCL/vendors/amdocl64.icd

# The libraries implementing the platform and its CPU and GPU devices. 
# The GPU won't show up unless we install the DRM libraries, driver and firmware.
/usr/lib/x86_64-linux-gnu/amdgpu-pro/libamdocl12cl64.so
/usr/lib/x86_64-linux-gnu/amdgpu-pro/libamdocl64.so
```

We manually need to create one more file, to add the libraries to the `ld` path:

```bash
$ cat <<EOF | sudo sh -c 'cat > /etc/ld.so.conf.d/local-amdgpu.conf' && sudo ldconfig
# Added manually; can be installed when package amdgpu-pro-opencl-icd is uninstalled
/usr/lib/x86_64-linux-gnu/amdgpu-pro
EOF
```

This would have been done by `amdgpu-pro-core` but we don't want to install
that package because it also adds `/etc/modprobe.d/amdgpu-blacklist-radeon.conf` which
does what its name says.  We don't want to blacklist the radeon module because we're not
installing the GPU driver.

And here we are:

```bash
$ clinfo -l
Platform 0: Intel Gen OCL Driver
 `-- Device 0: Intel(R) HD Graphics Haswell GT2 Mobile
Platform 1: Clover
 `-- Device 0: AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
Platform 2: AMD Accelerated Parallel Processing
 `-- Device 0: Intel(R) Core(TM) i7-4910MQ CPU @ 2.90GHz
```

All processing devices on my workstation made available using only Ubuntu packages
(plus a mostly harmless manual configuration change).


## Installing proprietary GPU support

From here on it's optimisation only.  We have a working OpenCL system which makes available
both GPUs and the CPU. All software used is open source (AMDGPU will be part of Ubuntu once
it leaves beta). Inquisitive minds may wonder if the proprietary drivers have more to offer,
certainly for the AMD GPU which currently operates via the generic Mesa layer.

#### Intel's GPU driver

Intel's "OpenCL™ 2.0 Driver+Runtime for Intel® HD, Iris™, and Iris™ Pro Graphics for Linux"
is available from their 
[OpenCL™ Drivers and Runtimes for Intel® Architecture](https://software.intel.com/en-us/articles/opencl-drivers)
page.  I haven't tested this and stick with the open source driver.  (IIRC there 
even was a shootout where Beignet performed better than the proprietary driver.)

#### AMD's GPU driver

Though the 
[AMD APP SDK page](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/)
still lists the [Catalyst driver](http://www.amd.com/en-us/innovations/software-technologies/technologies-gaming/catalyst) 
(aka fglrx, which was dropped from Ubuntu after 14.04) as a requirement, it seems that AMDGPU-PRO will
supercede it and be fully supported in Ubuntu once it leaves beta.  I read this 
[here](http://www.pcworld.com/article/3075837/linux/amds-gaming-optimized-amdgpu-pro-driver-for-linux-is-in-beta.html),
and [on AMDGPU-PRO's official page](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx),
which has installation instructions, compatibility lists, and the like.

The setup of the AMDGPU-PRO debian packages (downloadable from the 
[official page](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx))
is very promising: there is a main `amdgpu-pro` package which depends on `amdgpu-pro-computing` and
`amdgpu-pro-graphics`, suggesting that the computing aspect can be installed separate from the graphics.

However AMD really need to put more thinking into the packaging before AMDGPU-PRO can leave beta.  The
packages conflict (without declaring 'Conflicts') with packages in Ubuntu 16.04 and so fail to install
using the provided `amdgpu-pro-install` script.

#### AMDGPU-PRO Beta packaging problems

Here are the problems I ran into when attempting to install the beta:

* `amdgpu-pro-computing` depends on `amdgpu-pro-clinfo`, which conflicts with `clinfo` as it replaces
  the `clinfo` tool (by one that has much less functionality).  Instead it should depend on 
  `clinfo | amdgpu-pro-clinfo`.
* `amdgpu-pro-clinfo` in turn depends on `amdgpu-pro-libopencl1`.  That library is superfluous as 
  the libOpenCL library it contains is part of the the common OpenCL infrastructure.  Instead it should
  depend on the Ubuntu-provided `ocl-icd-libopencl1`.
* `amdgpu-pro-computing` depends on `amdgpu-pro-libopencl-dev`, which conflicts with `ocl-icd-opencl-dev`
  as it replaces the `libOpenCL.so` symlink.  It shouldn't do this as that file is part of the common
  OpenCL infrastructure.  AMD should change the dependency to `ocl-icd-opencl-dev | amdgpu-pro-libopencl-dev`,
  or leave out the `amdgpu-pro-libopencl-dev` altogether (for reasons explained above).
* Moreover, `amdgpu-pro-computing` shouldn't depend on the `-dev` library but rather on the *runtime*
  library `ocl-icl-libopencl1`, as the `-dev` is only needed when *compiling* OpenCL applications.
* `amdgpu-pro-opencl-icd` is missing the `/etc/ld.so.conf.d/amdgpu.conf` file.  This is provided by 
  `amdgpu-pro-core`, but that package blacklists the `radeon` driver as described earlier. I would
  suggest moving the `ld.so.conf.d/amdgpu.conf` to `amdgpu-pro-opencl-icd` so that the CPU can be used
  standalone.

Working around these isues I could install all AMDGPU-PRO packages except the two conflicting ones
(which are superfluous anyway), but it seems that the `amdgpu-pro` kernel module which replaces `radeon`
does not work on my system.  I'll need to look deeper though to be sure.  (AMD: if you're reading this,
I'm happy to work with you to sort this out.)


## Going all the way: the Intel and AMD's SDKs

AMD distributes the 
[AMD Accelerated Parallel Processing (APP) SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/),
and Intel has its
[Intel SDK for OpenCL Applications](https://software.intel.com/en-us/articles/opencl-drivers).

I will not cover these here but I do note that the AMD SDK appears to be installable non-root, which is
great!  Maybe more on this in the future.

## More to Explore

* StarPU
* erlang-cl, pyopencl
* [ArrayFire](http://arrayfire.com/why-arrayfire/)


###### Footnotes

[^1]: For out-of-distro software or cutting-edge versions I use [GNU Guix](https://guix.gnu.org/) which perfectly isolates these without being the kludge that containers are.

