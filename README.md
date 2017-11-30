# Gentoo Ada overlay

This overlay contains a modified set of packages and toolchain.eclass to enable
Ada based on a USE flag.  The gnat bootstrap compilers are currently hosted in
devspace and should eventually be moved to distfiles.

## To download

Find a place to put the overlay and clone it, note the name of the overlay is
*ada* when using layman, not *ada-overlay*.

```bash
git clone git@github.com:sarnold/ada-overlay.git
```

Note you can also install this overlay with layman;

Quick'n dirty way:

```
$ layman -f -a ada -o https://raw.github.com/sarnold/ada-overlay/master/configs/layman.xml
```

Cleaner way:

Edit /etc/layman.cfg and add the above URL to the "overlays" list, then sync
the layman overlays and list them.  You should see "ada" in the list of
overlays (sorted alphabetically).  Do a "layman -a ada" and you should be all
set.  Note that layman stores overlays under /var/lib/layman by default, and
adds a layman.conf under /etc/portage/repos.conf/ if you want to edit it.

## The source

There is a copy of the system toolchain.eclass in the eclass directory, this
has been modified for both USE=ada and crossdev (crossdev-99999999 also supports
the "ada" use flag).

If you install with layman, it will add a new config for you, however, if
you cloned this overlay somewhere manually, you should add the following to
```/etc/portage/repos.conf/local.conf``` or similar:

```bash
[ada]
priority = 20
location = /usr/local/overlays/ada
masters = gentoo
auto-sync = no
```

After installing with either method, add the following to
```/etc/portage/package.use```:

```bash
>=sys-devel/gcc-5.4.0::ada ada
```

Also add the following to ```/etc/portage/package.accept_keywords```:

```bash
>=sys-devel/gcc-5.4.0::ada **
```

On some arches, you may also need to add the following to
```/etc/portage/package.use.mask```:

```bash
sys-devel/gcc::ada -ada -vtv -sanitize -pie -hardened
```
(adjust as needed)

### WARNING!!!

You should make a backup of the system compiler, even though this has been
fairly well tested so far:

```bash
quickpkg sys-devel/gcc
```

Then rebuild your current toolchain vesion using, for example:

```bash
emerge -av =sys-devel/gcc-6.4.0
```

If you tried a newer version, the ebuild may advise you to change compilers
and then update the environment:

```bash
emerge -av =sys-devel/gcc-5.4.0::ada
gcc-config -l x86_64-pc-linux-gnu-5.4.0
. /etc/profile && env-update
```

Repeat for other versions as desired.

The binary tree for 5.4.0 should look like:

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

Once GCC-5.4.0 has been built with Ada support, gcc can then use itself
to bootstrap newer GCC's, as in 5.4.0 -> 6.4.0 -> 7.2.0

## Roadmap and Status

See [this bug report](https://bugs.gentoo.org/show_bug.cgi?id=592060) for the
status of the inclusion of this overlay into the main Gentoo toolchain.eclass.


1. Build a normal system toolchain including GNAT with ```USE=ada``` - done
2. Add a basic/default environment to gcc-config (note gprbuild doesn't use this) - done
3. Crossdev support for Ada - done
4. Add gprbuild, xmlada, ASIS, other base AdaCore tools - done,
   see [dev-ada-overlay](https://github.com/sarnold/dev-ada-overlay)
5. Additional Ada packages - in progress
6. Possible eclass for Ada ebuilds when .gpr support is dropped from gnatmake
7. More??

## Contributions

Luke A. Guest (aka Lucretia)

Steve Arnold (aka nerdboy)


