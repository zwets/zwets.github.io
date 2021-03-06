---
title: OpenCL on a dual graphics Dell M4800
layout: post
excerpt: "Documenting how I got OpenCL working on Ubuntu 16.04 on my dual graphics Dell M4800 workstation."
published: true
updated: 2017-03-01
---


This post documents how I got OpenCL working on Ubuntu 16.04 on my dual (hybrid) graphics Dell M4800
workstation.  The machine has an integrated Intel HD Graphics 4600 GPU, and a discrete AMD/ATI FirePro M5100.


## Background

[Caffe](http://caffe.berkelyvision.org) can transparently switch between CPU and GPU for its computations.
Caffe's [master branch](https://github.com/BVLC/caffe) is bound to NVidia.
Its [OpenCL branch](https://github.com/BVLC/caffe/tree/opencl) is in development and should support all
vendors through the OpenCL standard.

I prefer to keep my Ubuntu 16.04 plain vanilla, that is stick with packages available in the distro.
I avoid PPAs, `sudo make install` and certainly `sudo ./run-installer.sh`.[^1]  My worry was that
installing OpenCL would involve a lot of the latter, but it turned out that `apt-get install` goes
a long way.

The **tl;dr** version: `sudo apt-get install ocl-icd-libopencl1 beignet-opencl-icd mesa-opencl-icd`
makes both GPUs available as OpenCL devices.  The CPU can be added quite easily.  Below is my
install log. YMMV.


## Exploring the GPUs

My Dell M4800 has dual Intel/AMD graphics:

```bash
$ lspci -nn | grep VGA
00:02.0 VGA compatible controller [0300]: Intel Corporation 4th Gen Core Processor Integrated Graphics Controller [8086:0416] (rev 06)
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Venus XT [Radeon HD 8870M / R9 M270X/M370X] [1002:6821] (rev ff)
```

The AMD in the Dell M4800 is a FirePro M5100:

```bash
$ # 1002 and 6821 from lspci -nn are vendor and device id; 1028 is subvendor Dell (pciutils)
$ sed -ne '/^1002/,/^[0-9]/p' /usr/share/misc/pci.ids | sed -ne '/^\t6821/,/^\t[0-9]/p' | grep 1028
      1028 05cc  FirePro M5100
      1028 15cc  FirePro M5100
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


## Installing OpenCL

Installing OpenCL involves three layers:

* The API library and implementation loader (ICD Loader)
* One or more vendor-specific platform implementations (ICDs, installable client drivers)
* Any DRM/DRI hardware device drivers required by the ICDs

The top layer is provided by Ubuntu package `ocl-icd-libopencl1`.  This package contains
`libOpenCL`, the API library against which OpenCL applications are linked.  It also provides
the ICD Loader, the machinery that dynamically loads ICDs.  ICDs (installable client drivers)
implement the vendor-specific interaction with the hardware.

It is convenient to also install the `clinfo` utility which queries the API library about
available platforms:

```bash
$ sudo apt-get install clinfo ocl-icd-libopencl1
$ clinfo
Number of platforms   0   # We haven't installed ICDs yet
```

Each ICD is defined by a file with extension `.icd` in directory `/etc/OpenCL/vendors`.  The
first line in the ICD file specifies the path to a shared library.  The ICD Loader `dlopen`s
this library when the platform is requested.  Environment variables control the order of the
platforms, the default platform, and the debugging level.  For instance, to run an application
on a specific platform, set `OCL_ICD_VENDORS=<icd-file-name>`.  See `man libOpenCL`.


## Installing ICDs

Ubuntu provides ICDs for Intel and Nvidia GPUs.  AMD is supported via the Mesa ICD, which
implements OpenCL atop the open source DRM/DRI drivers:

```bash
$ apt-cache search '^opencl-icd$'  # virtual package provided by all ICDs
beignet-opencl-icd - OpenCL library for Intel GPUs
mesa-opencl-icd - free implementation of the OpenCL API -- ICD runtime
nvidia-opencl-icd-304 - NVIDIA OpenCL ICD
... more nvidia versions ...

$ apt-cache show beignet-opencl-icd
... supports the integrated GPUs of Ivy Bridge, Bay Trail, Haswell and Broadwell processors

$ apt-cache depends mesa-opencl-icd  # cards supported by the mesa ICD
... r600, amdgcn, amdgpu1, radeon1, nouveau2 ...
```

Install the Intel and Mesa ICDs to obtain the respective platforms:

```bash
$ sudo apt-get install beignet-opencl-icd mesa-opencl-icd
$ clinfo -l
Platform 0: Intel Gen OCL Driver
 `-- Device 0: Intel(R) HD Graphics Haswell GT2 Mobile
Platform 1: Clover
 `-- Device 0: AMD CAPE VERDE (DRM 2.43.0, LLVM 3.8.0)
```

It is that simple.  Two OpenCL devices ready to rock.  Run `clinfo` without
`-l` for a detailed overview of the platforms and the features of each device.


## Smoke Testing

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
with no out-of-distro repositories.  The "nice to have" to add is OpenCL **CPU** support.


## Installing CPU support

Unfortunately there isn't currently in Ubuntu an OpenCL ICD for CPUs.  One used to come with
`fglrx`, supporting AMD and Intel CPUs, but that package was dropped in Ubuntu 16.04.
Installing one is easy though.  There are two options.

#### Intel's CPU driver

Intel's "OpenCL™ Runtime for Intel® Core™ and Intel® Xeon® Processors" can be downloaded from their
[OpenCL™ Drivers and Runtimes for Intel® Architecture](https://software.intel.com/en-us/articles/opencl-drivers) page.

[Here](https://bitbucket.org/snippets/bkchr/EkeMg) is a way to turn the installer into a .deb
(thus reducing the risk of overwriting files from other packages).  Also, note the comment at
the bottom of that page mentioning that `install.sh` or `install_GUI.sh` should just work now
that Intel officially supports the driver on Ubuntu.  I haven't tested this.

#### AMD's CPU driver

AMD's CPU driver, which supports both AMD and Intel CPUs, comes 'for free' with their GPU driver.
If you want to install *just* the CPU driver (and stick to mesa over radeon on the GPU), then this
works:

* Download and unpack the
[AMDGPU-Pro](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx),
beta driver (more on this below) and install *only* the ICD package:

```bash
$ wget 'https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-16.60-379184.tar.xz'
  # note: link was current on 2017-03-01, check the AMDGPU-Pro page for latest
$ tar Jxvf amdgpu-pro_16.60-379184.tar.xz
$ cd amdgpu-pro-driver
$ sudo dpkg -i amdgpu-pro-opencl-icd_*_amd64.deb
```

This installs:

```
# The OpenCL ICD definition file for the AMD GPU platform
/etc/OpenCL/vendors/amdocl64.icd

# The libraries implementing the platform and its CPU and GPU devices.
# The GPU won't show up unless we install the DRI/DRM libraries, driver and firmware.
/usr/lib/x86_64-linux-gnu/amdgpu-pro/libamdocl12cl64.so
/usr/lib/x86_64-linux-gnu/amdgpu-pro/libamdocl64.so
```

We need to manually create one file to add the installed libraries to the `ld` path:

```bash
$ cat <<EOF | sudo sh -c 'cat > /etc/ld.so.conf.d/local-amdgpu.conf' && sudo ldconfig
# Added manually; can be removed when package amdgpu-pro-opencl-icd is uninstalled
/usr/lib/x86_64-linux-gnu/amdgpu-pro
EOF
```

This would have been done by `amdgpu-pro-core` but we don't want to install that
package because it also adds `/etc/modprobe.d/amdgpu-blacklist-radeon.conf` which
does what its name says, and we don't want to blacklist the radeon module.

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

All processing devices on my workstation made available using only debs (plus a mostly
harmless manual configuration change).


## Installing proprietary GPU support

From here on it's optimisation only.  We have a working OpenCL system which makes available
both GPUs and the CPU.  All software used is open source (AMDGPU-PRO will be in Ubuntu once
it leaves beta). Inquisitive minds may wonder if the proprietary drivers have more to offer,
certainly for the AMD GPU which currently operates via the generic Mesa layer.

#### Intel's GPU driver

Intel's "OpenCL™ 2.0 Driver+Runtime for Intel® HD, Iris™, and Iris™ Pro Graphics for Linux"
is available from their
[OpenCL™ Drivers and Runtimes for Intel® Architecture](https://software.intel.com/en-us/articles/opencl-drivers)
page.  I haven't tested this and stick with the open source driver.  It allegedly [citation
needed] is at least as good, and Intel devs are putting lots of effort into it.  Kudos!

#### AMD's AMDGPU-PRO driver

AMDGPU-PRO will supersede Catalyst (fglrx), which was dropped from Ubuntu 16.04.  It will have
a GPL kernel module (but proprietary firmware) and be supported on Ubuntu.  It is currently
available in beta, but works only for a handful of models.  More on it
[here](http://www.pcworld.com/article/3075837/linux/amds-gaming-optimized-amdgpu-pro-driver-for-linux-is-in-beta.html),
and
[on AMDGPU-PRO's official page](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx),
which has installation instructions and model compatibility lists.

Installing the beta packages requires care.  Though allegedly tailored for Ubuntu 16.04, the
AMDGPU-PRO packages have multiple packaging errors, such as failing to declare conflicts with
existing packages, leaving you with a stuck APT.
Details in [Appendix I](#appendix-i-amdgpu-pro-install-notes) below.

#### AMD's Catalyst (fglrx) driver

As AMDGPU-PRO doesn't (yet) support my FirePro M5100, I tried the Catalyst Pro (workstation)
driver.  The Catalyst driver can be
[built "headless"](http://support.amd.com/en-us/kb-articles/Pages/XServerLessDriver.aspx),
meaning that you can build and install just the OpenCL part, without going for the whole
graphics stack:

```bash
$ # Omitting installation steps for the build-dependencies (devscripts, dh-modaliases, ...)
$ unzip 15.302.2301-linux-retail_end_user.zip  # This is the "Pro" version for my FirePro, YMMV
$ cd fglrx-15.302.2301
$ sudo ./amd-driver-installer-15.302.2301-x86.x86_64.run --buildpkg Ubuntu/xenial --NoXServer
```

This builds `fglrx-core_15.302-0ubuntu1_amd64.deb`, but not without a fair share of issues:
the kernel module fails to build against current kernels; `clinfo` runs once and segfaults ever
after (an old bug resurfacing due to AMD forgetting to add `/etc/ati/amdpcsdb.default` to the
package); and, like AMDGPU-PRO, the package conflicts with the Ubuntu 16.04 OpenCL packages.  Sigh.

Still, with some patching [documented here](https://github.com/zwets/amd-opencl-patches)
I managed to install the `fglrx` driver *and* got full OpenCL support:

```bash
$ clinfo -l
Platform #0: AMD Accelerated Parallel Processing
 +-- Device #0: Capeverde
 `-- Device #1: Intel(R) Core(TM) i7-4910MQ CPU @ 2.90GHz
Platform #1: Intel Gen OCL Driver
 `-- Device #0: Intel(R) HD Graphics Haswell GT2 Mobile
Platform #2: Clover
```

My joy however lasted until the moment I unplugged my laptop from AC.  Uptime on battery
plummeted from the usual 4 to 5 hours to 1:30, *while I'm not even using the card*.
There's probably a way to switch it off, but I'm not inclined to spend hours again to
find the next workaround for AMD's failure to get things right.

**Update** I have since installed TLP, which works fabulously and gets me 6 to 7 hours on
battery.  Haven't yet checked though if it also manages to kill the power to `fglrx`,
as I somehow guess I already know the answer.


#### Oibaf's drivers

An [answer on AskUbuntu](http://askubuntu.com/a/815592/134479) suggests
[Oibaf's drivers](https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers)
as a promising alternative for `fglrx`.  I haven't looked at these yet.


## Installing the Intel and AMD SDKs

AMD distributes the
[AMD Accelerated Parallel Processing (APP) SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/),
and Intel has its
[Intel SDK for OpenCL Applications](https://software.intel.com/en-us/articles/opencl-drivers).

I'm not using these as I'm currently only interested in OpenCL as a *user*, not as a developer.
Maybe more on the SDKs in the future.


## More to Explore

* StarPU
* erlang-cl, pyopencl
* [ArrayFire](http://arrayfire.com/why-arrayfire/)
* ...


---

## Appendix I: AMDGPU-PRO install notes

The organisation of the AMDGPU-PRO debian packages (downloadable from the
[official page](http://support.amd.com/en-us/kb-articles/Pages/AMD-Radeon-GPU-PRO-Linux-Beta-Driver%e2%80%93Release-Notes.aspx))
is promising: there is a main `amdgpu-pro` package which depends on `amdgpu-pro-computing`
and `amdgpu-pro-graphics`, separating the headless from the gamers.

However AMD need to fix the packaging before AMDGPU-PRO can leave beta.
Currently (release 16.30.3-315407) the packages conflict (without declaring
'Conflicts') with packages in Ubuntu and so fail halfway installation,
leaving you with a stuck APT.

These things need fixing in the AMDGPU-PRO (Beta) Debian packages[^2]:

* `amdgpu-pro-computing` depends on `amdgpu-pro-clinfo`, which conflicts with `clinfo` as it replaces the
clinfo tool (by one that has lots less functionality).  Solution:

    * `amdgpu-pro-computing` should `Depends: clinfo | amdgpu-pro-clinfo` (or better: *Recommends*, unless
    the `clinfo` utility is indispensable for the proper functioning of the package).
    * `amdgpu-pro-clinfo` must `Conflicts: clinfo`.

* `amdgpu-pro-clinfo` depends on `amdgpu-pro-libopencl1`, which conflicts with `ocl-icd-libopencl1`
as it replaces the libOpenCL library.  Solution:

    * `amdgpu-pro-clinfo` should `Depends: ocl-icd-libopencl1 | amdgpu-pro-libopencl1`.  In fact, is
    `amdgpu-pro-libopencl1` needed at all?  The libOpenCL library is part of the common OpenCL infrastructure
    (the top layer [described above](#installing-opencl)) and needn't be provided by vendor ICDs.
    * `amdgpu-pro-libopencl1` must `Conflicts: ocl-icd-libopencl1`

* `amdgpu-pro-computing` depends on `amdgpu-pro-libopencl-dev`, which conflicts with `ocl-icd-opencl-dev`
as it replaces the `libOpenCL.so` symlink.  It shouldn't do this as that symlink file is part of the common
OpenCL infrastructure.  Solution:

    * `amdgpu-pro-computing` should `Depends: ocl-icd-opencl-dev | amdgpu-pro-libopencl-dev`,
    or leave out the `amdgpu-pro-libopencl-dev` altogether (for same reasons as explained above).
    * Moreover, `amdgpu-pro-computing` probably shouldn't depend on the `-dev` library but rather on the
    *runtime* library `ocl-icl-libopencl1`, as the `-dev` package is a *build* dependency.

* `amdgpu-pro-opencl-icd` is missing the `/etc/ld.so.conf.d/amdgpu.conf` file.  This file is provided
by `amdgpu-pro-core`, which however also blacklists the `radeon` driver
(as described [above](#amd-s-cpu-driver)), thus preventing a 'CPU-only' install. Solution:

    * Move the `ld.so.conf.d/amdgpu.conf` to package `amdgpu-pro-opencl-icd` as it should logically be
    installed together with the libraries in that package.  The package provides the CPU device.
    * Create a new `amdgpu-pro-opencl-gpu-icd` package to provide the GPU device, and make that
    package (as well as `amdgpu-pro-graphics`) depend on the `core` package which has the driver
    and the radeon blacklist.


## Appendix II: graphics switching

This section is about Open*GL* rather than OpenCL.  I include it to document the simplicity
of switching to the discrete GPU for rendering.  All it requires is setting the environment
variable `DRI_PRIME`.

> **Note:** moved to the appendix because it is off-topic.  Also, after a number of
> `apt-get update`s the Gallium rendering gives a black window and its framerate is actually
> lower (11000) than that for Mesa (12900).

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

I was surprised to see the high frame rate on the IGD.  In fact, with current package
versions, the IGD actually wins.  Just because it is an integrated GPU, doesn't mean that
it can't be used for computing.

**Note:** According to
[this page](http://askubuntu.com/questions/593098/hybrid-graphic-card-drivers-amd-radeon-hd-8570-intel-hd-graphics-4000/620756#620756)
it is required to do `xrandr --setprovideroffloadsink 0x49 0x72` (where the hex numbers are
the card IDs from the `xrandr --listproviders` output) to make `DRI_PRIME` work,
but I get the exact same results when I don't.  ([May be related to DRI3?](https://wiki.archlinux.org/index.php/PRIME))


###### Footnotes

[^1]: For out-of-distro software or cutting-edge versions I use [GNU Guix](https://guix.gnu.org/) which perfectly isolates these without being the kludge that containers are.

[^2]: AMD: if you're reading this, I'm happy to work with you to sort this out.

