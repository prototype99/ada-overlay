# Gentoo Ada overlay

This is an attempt to get the Ada lanugage into Gentoo as a first class citizen, rather than a hideously deformed ginger
step-kid she currently is. Rather than develop a whole bunch of ebuilds just to add another compiler to the system, which
is what currently happens in Gentoo, the toolchain.eclass should be modified to enable Ada based on a USE flag.

## To download

Find a place to put the overlay and clone it, but name it *ada*, this is the name of the overlay, not *ada-overlay*. I
named it *ada-overlay* on Github just so it didn't get confused with anything else.

```bash
git clone git@github.com:Lucretia/ada-overlay.git ada
```

## The source

There is a copy of the system toolchain.eclass in the eclass directory, this has been modified. This does work now. I
have tested x86 and amd64 chroot's, building using the bootstrap compiler the ebuild will download and then subsequently
using the installed system compiler (which includes GNAT!). I've also tested building mingw under crossdev and that will
build ada, but I had to:

1. Install the "ebuild's" to where I had my ada overlay so it would pick up the correct toolchain.eclass,
```crossdev --ov-output /usr/local/overlays/ada i686-w64-mingw32```
2. I didn't really need to do this, but I didn't want to build the stage2 twice, so I stopped the build after stage1-gcc
   was built and added the ada USE flag,
```echo "cross-i686-w64-mingw32/gcc ada -fortran -vtv -sanitize" >> /etc/portage/package.use/cross-i686-w64-mingw32-gcc```

Once you have this overlay somewhere and you've added the following to ```/etc/portage/repos.conf/local.conf``` or similar:

```bash
[ada]
priority = 20
location = /usr/local/overlays/ada
masters = gentoo
auto-sync = no
```

Add the following to ```/etc/portage/package.use/ada.use```:

```bash
=sys-devel/gcc-4.9.4::ada ada
```

Add the following to ```/etc/portage/package.accept_keywords/ada.accept_keywords```:

```bash
=sys-devel/gcc-4.9.4::ada **
```

Then build 4.9.4 using:

```bash
emerge -av gcc
```

Once GCC-4.9.4 has been built with Ada support, you will be able to use that installed compiler as a bootstrap to update
to newer GCC's.

# Roadmap

See [this bug report](https://bugs.gentoo.org/show_bug.cgi?id=592060) for the status of the inclusion of my patches to
Gentoo's toolchain.eclass. If you want this to be added in, add a comment there saying so.

This what I really want to happen:

1. Be able to build a system compiler including GNAT with ```USE=ada```.
2. Modify directory locations according to Gentoo Ada policy, add this to gcc-config
3. Build a libgnat_util and gpr file. I would prefer to use the same sources, so we can have better version information. May need to configure gcc to generate the version.c file to copy.
4. Use [this script](https://github.com/AdaCore/gprbuild/commit/eaa3b24efeba20c3ebc1fd091fa9d78ad3a6510a) to bootstrap a gprbuild, use this to build xmlada and gprtools.
5. ASIS, GPS, other AdaCore tools.
6. Further ebuild commands via an eclass to add building and installing using GPR files.
7. Further libraries.
8. Cross compiler using the system ebuilds. By working on the toolchain.eclass, this should get this for free!
9. Delete all the old crap from Portage.
10. Incorporate this layer directly into Portage so that new users get it when they install Gentoo.
11. Other stuff not mentioned above.

# Contributions

Luke A. Guest

Add your name here
