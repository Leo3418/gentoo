# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools flag-o-matic python-any-r1

MY_P=qp${PV}

DESCRIPTION="Extended Prolog supporting quantifiers, object-variables and substitutions"
HOMEPAGE="https://staff.itee.uq.edu.au/pjr/HomePages/QuPrologHome.html"
SRC_URI="https://staff.itee.uq.edu.au/pjr/HomePages/QPFiles/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="Apache-2.0 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug doc examples pcre pedro readline threads"

COMMON_DEPEND="
	pcre? ( dev-libs/libpcre2 )
	pedro? ( net-misc/pedro )
	readline? ( app-misc/rlwrap )"
RDEPEND="${COMMON_DEPEND}
	!dev-util/rej"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-lang/perl"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-10.x-qt5.patch
	eapply "${FILESDIR}"/${PN}-10.8-compiler-flags.patch
	eapply "${FILESDIR}"/${PN}-10.x-qa-compiler-flags.patch
	eapply_user

	eautoconf

	python_fix_shebang bin/qc.in
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/924768
	# Upstream's sole provided contact method is email. I have sent an email
	# describing the issue with a fairly rapid response saying there will be
	# a new release "shortly" and that hopefully it will include a fix. -- Eli
	append-flags -fno-strict-aliasing
	filter-lto

	econf \
		--libdir=/usr/$(get_libdir) \
		$(use_enable debug) \
		$(use_enable threads multiple-threads)
}

src_compile() {
	emake OPTIMISATION="${CXXFLAGS}"
}

src_install() {
	sed \
		-e "s|${S}|/usr/$(get_libdir)/qu-prolog|g" \
		-i bin/qc bin/qc1.qup bin/qecat bin/qg bin/qp || die

	dobin bin/{qc,qecat,qp,kq}

	into /usr/$(get_libdir)/${PN}
	dobin bin/{qa,qc1.qup,qdeal,qem,qg,ql,qppp}

	insinto /usr/$(get_libdir)/${PN}/bin
	doins bin/rl_commands
	doins bin/{qc1.qup,qecat,qg,qp}.qx

	insinto /usr/$(get_libdir)/${PN}/library
	doins prolog/library/*.qo

	insinto /usr/$(get_libdir)/${PN}/compiler
	doins prolog/compiler/*.qo

	doman doc/man/man1/*.1

	dodoc README

	if use doc ; then
		docinto reference-manual
		dodoc doc/manual/*.html
		docinto user-guide
		dodoc doc/user/main.pdf
	fi

	if use examples ; then
		docinto examples
		newdoc examples/README README.examples
		dodoc examples/*.ql
	fi
}
