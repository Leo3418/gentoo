# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple bash-completion-r1

# Upstream has not started to make releases yet
GIT_COMMIT="d39237e66deff22cb912462bcaa61ffeb208990e"

DESCRIPTION="A command-line interface for jar-relocator"
HOMEPAGE="https://github.com/Leo3418/jar-relocator-cli"
SRC_URI="https://github.com/Leo3418/jar-relocator-cli/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	>=dev-java/jar-relocator-1.5:0
	>=dev-java/picocli-4.6.2:0
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

JAVA_LAUNCHER_FILENAME="${PN}"
JAVA_MAIN_CLASS="io.github.leo3418.jarrelocatorcli.JarRelocatorCli"

src_compile() {
	java-pkg-simple_src_compile

	# Generate Bash completion file
	# https://picocli.info/autocomplete.html#_generate_completion_script
	local java="$(java-config -J)"
	local cp="${JAVA_JAR_FILENAME}:$(java-pkg_getjars \
		--build-only --with-dependencies "${JAVA_GENTOO_CLASSPATH}")"
	"${java}" -cp "${cp}" picocli.AutoComplete "${JAVA_MAIN_CLASS}" ||
		die "Failed to generate Bash completion file"
	MY_BASH_COMP="${PN}_completion"
	# Remove reference to files that would not be installed by this ebuild
	sed -i -e "s/${PN}\.\(bash\|sh\)//g" "${MY_BASH_COMP}" ||
		die "Failed to sanitize Bash completion file for QA"
}

src_install() {
	java-pkg-simple_src_install
	newbashcomp "${MY_BASH_COMP}" "${PN}"
	einstalldocs # https://bugs.gentoo.org/789582
}
