# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org/
	https://github.com/keepassxreboot/keepassxc/"

if [[ "${PV}" = *9999* ]] ; then
	inherit git-r3

	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
else
	if [[ "${PV}" == *_beta* ]] ; then
		SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz
			-> ${P}.gh.tar.gz"
		S="${WORKDIR}/${P/_/-}"
	else
		SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz"
	fi

	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="X autotype browser doc keeshare +keyring +network +ssh-agent test yubikey"

RESTRICT="!test? ( test )"
REQUIRED_USE="autotype? ( X )"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-gfx/qrencode:=
	sys-libs/readline:0=
	sys-libs/zlib:=[minizip]
	X? (
		dev-qt/qtx11extras:5
	)
	autotype? (
		x11-libs/libX11
		x11-libs/libXtst
	)
	yubikey? (
		dev-libs/libusb:1
		sys-apps/pcsc-lite
	)
"
DEPEND="
	${RDEPEND}
	dev-qt/qttest:5
"
BDEPEND="
	dev-qt/linguist-tools:5
	doc? (
		dev-ruby/asciidoctor
	)
"

PATCHES=( "${FILESDIR}/${PN}-2.7.10-tests.patch" )

src_prepare() {
	if [[ "${PV}" != *_beta* ]] && [[ "${PV}" != *9999 ]] ; then
		printf '%s' "${PV}" > .version || die
	fi

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
		# other means. We don't want the build system to enable it for us.
		-DWITH_CCACHE="OFF"
		-DWITH_GUI_TESTS="OFF"
		-DWITH_XC_BOTAN3="ON"
		-DWITH_XC_UPDATECHECK="OFF"

		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_BROWSER="$(usex browser)"
		-DWITH_XC_BROWSER_PASSKEYS="$(usex browser)"
		-DWITH_XC_DOCS="$(usex doc)"
		-DWITH_XC_FDOSECRETS="$(usex keyring)"
		-DWITH_XC_KEESHARE="$(usex keeshare)"
		-DWITH_XC_NETWORKING="$(usex network)"
		-DWITH_XC_SSHAGENT="$(usex ssh-agent)"
		-DWITH_XC_X11="$(usex X)"
		-DWITH_XC_YUBIKEY="$(usex yubikey)"
	)

	if [[ "${PV}" == *_beta* ]] ; then
		mycmakeargs+=(
			-DOVERRIDE_VERSION="${PV/_/-}"
		)
	fi

	cmake_src_configure
}
