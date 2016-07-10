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

Then build using:

```bash
USE=ada ebuild /usr/local/overlays/ada/sys-devel/gcc/gcc-4.9.3.ebuild compile
```

# Roadmap

This what I really want to happen:

1. Be able to build a system compiler including GNAT with ```USE=ada```.
2. Build the libgnat_util inside toolchain.eclass as well. Using the same sources, so we have better version information.
3. GPR tools, which means, ASIS, XMLAda.
4. Further ebuild commands via an eclass to add building and installing using GPR files.
5. Further libraries.
6. Cross compiler using the system ebuilds. By working on the toolchain.eclass, this should get this for free!
7. Delete all the old crap from Portage.
8. Incorporate this layer directly into Portage so that new users get it when they install Gentoo.
9. Other stuff not mentioned above.

# Contributions

Luke A. Guest

Add your name here
