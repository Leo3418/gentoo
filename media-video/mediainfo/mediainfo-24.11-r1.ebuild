# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# - media-libs/libzen (if a release is available)
# - media-libs/libmediainfo
# - media-video/mediainfo

WX_GTK_VER="3.2-gtk3"
inherit xdg-utils autotools wxwidgets

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="https://mediaarea.net/en/mediainfo/ https://github.com/MediaArea/MediaInfo"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"
S="${WORKDIR}/MediaInfo"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="curl mms wxwidgets"

# The libzen dep usually needs to be bumped for each release!
RDEPEND="
	~media-libs/libmediainfo-${PV}[curl=,mms=]
	>=media-libs/libzen-0.4.41
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}=[X] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	TARGETS="CLI"

	if use wxwidgets; then
		TARGETS+=" GUI"
		setup-wxwidgets
	fi
}

src_prepare() {
	default

	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		sed -i -e "s:-O2::" configure.ac || die
		eautoreconf
	done
}

src_configure() {
	local target

	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		local args=""
		[[ ${target} == "GUI" ]] && args="--with-wxwidgets --with-wx-gui"
		econf ${args}
	done
}

src_compile() {
	local target

	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		default
	done
}

src_install() {
	local target

	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		default
		dodoc "${S}"/History_${target}.txt
	done
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
