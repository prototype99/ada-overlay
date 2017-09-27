# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.1"
PATCH_GCC_VER="7.1.0"
#UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	toolchain_src_prepare

	epatch "${FILESDIR}"/0001-Remove-P-macro-gnat-makefile.patch \
		"${FILESDIR}"/${PV}/${P}-fix-arm-platform-def.patch

	# fails the build if this  tries -fself-test=foo too early;
	# this is just a brute-force removal of the offending argument
	# to get past the early fail
	#epatch "${FILESDIR}"/${PV}/${P}-disable-fself-test.patch
}
