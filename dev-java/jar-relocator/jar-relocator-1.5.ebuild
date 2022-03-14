# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

# Upstream does not tag releases; the commit that marks a
# release can only be inferred from the commit messages
GIT_COMMIT="2f05f3bee5ae88e4fd76a1f84ba458b5e7d266df"

DESCRIPTION="A Java program to relocate classes within a JAR using ASM"
HOMEPAGE="https://github.com/lucko/jar-relocator"
SRC_URI="https://github.com/lucko/jar-relocator/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	>=dev-java/asm-9.2:9
	>=dev-java/asm-commons-9.2:9
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
