# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.0"
#UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

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
		"${FILESDIR}"/${PV}/${P}-fix-linux-platform-def.patch \
		"${FILESDIR}"/${PV}/${P}-add-finalization-size-for-Ada-objects.patch

	epatch "${FILESDIR}"/${PV}/${P}-Document-with-multilib-list-for-arm-targets.patch \
		"${FILESDIR}"/ARM-2-3-Error-out-for-incompatible-ARM-multilibs.patch \
		"${FILESDIR}"/ARM-3-3-Add-multilib-support-for-bare-metal-ARM-architectures.patch
}
