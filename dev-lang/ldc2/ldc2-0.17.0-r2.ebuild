# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator

MY_PV="$(replace_version_separator '_' '-')"
MY_P="ldc-${MY_PV}-src"
SRC_URI="https://github.com/ldc-developers/ldc/releases/download/v${MY_PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm"
LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)/0"
IUSE=""

RDEPEND="dev-libs/libconfig
	app-eselect/eselect-dlang"
DEPEND=">=dev-util/cmake-2.8
	<sys-devel/llvm-3.9
	>=sys-devel/llvm-3.5
	${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DCMAKE_INSTALL_PREFIX=/opt/ldc2-$(get_version_component_range 1-2)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion
}

pkg_postinst() {
	# Update active ldc2
	"${ROOT}"/usr/bin/eselect dlang update ldc2
}

pkg_postrm() {
	"${ROOT}"/usr/bin/eselect dlang update ldc2
}