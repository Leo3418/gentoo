# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit cmake desktop optfeature wxwidgets xdg

MY_PV="${PV/_beta/BETA}"
DESCRIPTION="Password manager with wxGTK based frontend"
HOMEPAGE="https://pwsafe.org/ https://github.com/pwsafe/pwsafe/"
SRC_URI="https://github.com/pwsafe/pwsafe/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/pwsafe-${MY_PV}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="qr test +xml yubikey"
RESTRICT="!test? ( test )"

RDEPEND="
	net-misc/curl
	sys-apps/util-linux
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
	qr? ( media-gfx/qrencode )
	xml? ( dev-libs/xerces-c:= )
	yubikey? ( sys-auth/ykpers )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-arch/zip
	dev-lang/perl
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-cpp/gtest )"

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DNO_QR=$(usex !qr)
		-DNO_GTEST=$(usex !test)
		-DGTEST_BUILD=OFF
		-DXML_XERCESC=$(usex xml)
		-DNO_YUBI=$(usex !yubikey)
	)

	cmake_src_configure
}

src_install() {
	pushd "${BUILD_DIR}" || die

	dobin pwsafe
	dobin cli/pwsafe-cli
	dosym pwsafe /usr/bin/${PN}
	dosym pwsafe-cli /usr/bin/${PN}-cli

	insinto /usr/share/locale
	doins -r src/ui/wxWidgets/I18N/mos/*

	insinto /usr/share/${PN}/help
	doins help/*.zip

	popd || die

	newman docs/pwsafe.1 ${PN}.1

	dodoc README.md README.LINUX.* SECURITY.md docs/{ReleaseNotes.md,ChangeLog.txt}

	insinto /usr/share/${PN}
	doins -r xml

	doicon -s 48 install/graphics/pwsafe.png
	newmenu install/desktop/pwsafe.desktop ${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	optfeature "on-screen keyboard for password entry" x11-misc/xvkbd
}
