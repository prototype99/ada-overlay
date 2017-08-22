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

### WARNING!!!

Before you install the compiler, make a backup of the system compiler, just in case something goes wrong:

```bash
quickpkg sys-devel/gcc
```

Then rebuild 4.9.4 using:

```bash
emerge -av =sys-devel/gcc-4.9.4
```

Then rebuild 4.9.4 with Ada support:

```bash
emerge -av =sys-devel/gcc-4.9.4::ada
```

The ebuild will advise you to change compilers and then update the environment, you will want to repeat this 2 more times:

```bash
emerge -av =sys-devel/gcc-5.1.0::ada
gcc-config -l x86_64-pc-linux-gnu-5.1.0
. /etc/profile
```

```bash
emerge -av =sys-devel/gcc-5.4.0::ada
gcc-config -l x86_64-pc-linux-gnu-5.4.0
. /etc/profile
```

This will bring you up to date with the currently supported GCC on Gentoo.

```bash
# gcc-config -l
 [1] x86_64-pc-linux-gnu-4.9.4
 [2] x86_64-pc-linux-gnu-5.1.0
 [3] x86_64-pc-linux-gnu-5.4.0 *
```

After an ```eix-update```:

```bash
# eix sys-devel/gcc
[U] sys-devel/gcc
     Available versions:  
     (2.95.3) ~*2.95.3-r10^s ~*2.95.3-r10^s[1]
     (3.3.6) (~)3.3.6-r1^s (~)3.3.6-r1^s[1]
     (3.4.6) 3.4.6-r2^s 3.4.6-r2^s[1]
     (4.0.4) **4.0.4^s **4.0.4^s[1]
     (4.1.2) 4.1.2^s 4.1.2^s[1]
     (4.2.4) (~)4.2.4-r1^s (~)4.2.4-r1^s[1]
     (4.3.6) 4.3.6-r1^s 4.3.6-r1^s[1]
     (4.4.7) 4.4.7^s 4.4.7^s[1]
     (4.5.4) 4.5.4^s 4.5.4^s[1]
     (4.6.4) 4.6.4^s 4.6.4^s[1]
     (4.7.4) 4.7.4^s 4.7.4^s[1]
     (4.8.5) 4.8.5^s 4.8.5^s[1]
     (4.9.3) 4.9.3^s 4.9.3^s[1]
     (4.9.4) 4.9.4^s 4.9.4^s[1]
     (5.1.0) (**)5.1.0^s[1]
     (5.2.0) **5.2.0^s[1]
     (5.3.0) (~)5.3.0^s[1]
     (5.4.0) (~)5.4.0^s (~)5.4.0^s[1] 5.4.0-r3^s 5.4.0-r3^s[1]
     (6.3.0) **6.3.0^s **6.3.0^s[1]
       {ada altivec awt boundschecking cilk +cxx d debug doc fixed-point +fortran gcj go graphite hardened jit libssp mpx mudflap multilib +nls nopie nossp +nptl objc objc++ objc-gc +openmp +pch pie regression-test +sanitize ssp vanilla +vtv}
     Installed versions:  4.9.4(4.9.4)^s[1](19:37:43 01/05/17)(ada cxx fortran multilib nls nptl openmp sanitize vtv -altivec -awt -cilk -debug -doc -fixed-point -gcj -go -graphite -hardened -libssp -nopie -nossp -objc -objc++ -objc-gc -regression-test -vanilla) 5.1.0(5.1.0)^s[1](20:35:09 01/05/17)(cxx fortran multilib nls nptl openmp sanitize vtv -ada -altivec -awt -cilk -debug -doc -fixed-point -gcj -go -graphite -hardened -jit -libssp -mpx -nopie -nossp -objc -objc++ -objc-gc -regression-test -vanilla) 5.4.0(5.4.0)^s[1](22:08:39 01/05/17)(ada cxx fortran multilib nls nptl openmp sanitize vtv -altivec -awt -cilk -debug -doc -fixed-point -gcj -go -graphite -hardened -jit -libssp -mpx -nopie -nossp -objc -objc++ -objc-gc -regression-test -vanilla)
     Homepage:            https://gcc.gnu.org/
     Description:         The GNU Compiler Collection

[1] "ada" /opt/ada-overlay
```

The binary tree should look like:

```bash
# ls -l /usr/x86_64-pc-linux-gnu/gcc-bin/5.4.0/
total 27532
lrwxrwxrwx 1 root root      23 May  1 22:08 c++ -> x86_64-pc-linux-gnu-c++
lrwxrwxrwx 1 root root      23 May  1 22:08 cpp -> x86_64-pc-linux-gnu-cpp
lrwxrwxrwx 1 root root      23 May  1 22:08 g++ -> x86_64-pc-linux-gnu-g++
lrwxrwxrwx 1 root root      23 May  1 22:08 gcc -> x86_64-pc-linux-gnu-gcc
-rwxr-xr-x 2 root root   26888 May  1 22:08 gcc-ar
-rwxr-xr-x 2 root root   26888 May  1 22:08 gcc-nm
-rwxr-xr-x 2 root root   26888 May  1 22:08 gcc-ranlib
lrwxrwxrwx 1 root root      24 May  1 22:08 gcov -> x86_64-pc-linux-gnu-gcov
-rwxr-xr-x 1 root root  437528 May  1 22:08 gcov-tool
lrwxrwxrwx 1 root root      28 May  1 22:08 gfortran -> x86_64-pc-linux-gnu-gfortran
lrwxrwxrwx 1 root root      24 May  1 22:08 gnat -> x86_64-pc-linux-gnu-gnat
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatbind -> x86_64-pc-linux-gnu-gnatbind
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatchop -> x86_64-pc-linux-gnu-gnatchop
lrwxrwxrwx 1 root root      29 May  1 22:08 gnatclean -> x86_64-pc-linux-gnu-gnatclean
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatfind -> x86_64-pc-linux-gnu-gnatfind
lrwxrwxrwx 1 root root      26 May  1 22:08 gnatkr -> x86_64-pc-linux-gnu-gnatkr
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatlink -> x86_64-pc-linux-gnu-gnatlink
lrwxrwxrwx 1 root root      26 May  1 22:08 gnatls -> x86_64-pc-linux-gnu-gnatls
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatmake -> x86_64-pc-linux-gnu-gnatmake
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatname -> x86_64-pc-linux-gnu-gnatname
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatprep -> x86_64-pc-linux-gnu-gnatprep
lrwxrwxrwx 1 root root      28 May  1 22:08 gnatxref -> x86_64-pc-linux-gnu-gnatxref
-rwxr-xr-x 2 root root  874240 May  1 22:08 x86_64-pc-linux-gnu-c++
-rwxr-xr-x 1 root root  874240 May  1 22:08 x86_64-pc-linux-gnu-cpp
-rwxr-xr-x 2 root root  874240 May  1 22:08 x86_64-pc-linux-gnu-g++
-rwxr-xr-x 1 root root  874240 May  1 22:08 x86_64-pc-linux-gnu-gcc
lrwxrwxrwx 1 root root      23 May  1 22:08 x86_64-pc-linux-gnu-gcc-5.4.0 -> x86_64-pc-linux-gnu-gcc
-rwxr-xr-x 2 root root   26888 May  1 22:08 x86_64-pc-linux-gnu-gcc-ar
-rwxr-xr-x 2 root root   26888 May  1 22:08 x86_64-pc-linux-gnu-gcc-nm
-rwxr-xr-x 2 root root   26888 May  1 22:08 x86_64-pc-linux-gnu-gcc-ranlib
-rwxr-xr-x 1 root root  474432 May  1 22:08 x86_64-pc-linux-gnu-gcov
-rwxr-xr-x 1 root root  874240 May  1 22:08 x86_64-pc-linux-gnu-gfortran
-rwxr-xr-x 1 root root 3067168 May  1 22:08 x86_64-pc-linux-gnu-gnat
-rwxr-xr-x 1 root root 1417720 May  1 22:08 x86_64-pc-linux-gnu-gnatbind
-rwxr-xr-x 1 root root 1008064 May  1 22:08 x86_64-pc-linux-gnu-gnatchop
-rwxr-xr-x 1 root root 3239648 May  1 22:08 x86_64-pc-linux-gnu-gnatclean
-rwxr-xr-x 1 root root  991680 May  1 22:08 x86_64-pc-linux-gnu-gnatfind
-rwxr-xr-x 1 root root  649984 May  1 22:08 x86_64-pc-linux-gnu-gnatkr
-rwxr-xr-x 1 root root  793808 May  1 22:08 x86_64-pc-linux-gnu-gnatlink
-rwxr-xr-x 1 root root 2632192 May  1 22:08 x86_64-pc-linux-gnu-gnatls
-rwxr-xr-x 1 root root 3527552 May  1 22:08 x86_64-pc-linux-gnu-gnatmake
-rwxr-xr-x 1 root root 2702336 May  1 22:08 x86_64-pc-linux-gnu-gnatname
-rwxr-xr-x 1 root root 1676800 May  1 22:08 x86_64-pc-linux-gnu-gnatprep
-rwxr-xr-x 1 root root  991680 May  1 22:08 x86_64-pc-linux-gnu-gnatxref
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

You can (optionally) add this overlay with layman:

$ layman -f -a ada -o https://raw.github.com/sarnold/ada-overlay/master/configs/layman.xml

# Contributions

Luke A. Guest (aka Lucretia)

Steve Arnold (aka nerdboy)
