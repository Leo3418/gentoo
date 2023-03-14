# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-pkg-simple desktop xdg

DESCRIPTION="Draw UML diagrams using a simple and human readable text description"
HOMEPAGE="https://plantuml.com"
# Only the GitHub archive has test sources
SRC_URI="https://github.com/plantuml/plantuml/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="
	dev-java/ant-core:0"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	media-gfx/graphviz"

# Restore the default value of 'S' overridden by java-pkg-simple.eclass
S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

# https://github.com/plantuml/plantuml/blob/v1.2022.7/build.gradle.kts#L75
JAVA_MAIN_CLASS="net.sourceforge.plantuml.Run"
JAVA_LAUNCHER_FILENAME="${PN}"

src_compile() {
	java-pkg-simple_src_compile

	pushd "${JAVA_SRC_DIR}" > /dev/null || die "Failed to enter JAVA_SRC_DIR"
	# https://github.com/plantuml/plantuml/blob/v1.2022.7/build.gradle.kts#L47-L50
	find . -type f \
		\( -name 'graphviz.dat' -o -name '*.png' -o -name '*.svg' -o -name '*.txt' \) \
		-exec "$(java-config --jar)" -uvf "${S}/${JAVA_JAR_FILENAME}" {} + ||
		die "Failed to add extra files to JAR"
	popd > /dev/null || die "Failed to leave JAVA_SRC_DIR"
	# https://github.com/plantuml/plantuml/blob/v1.2022.7/build.gradle.kts#L80-L83
	"$(java-config --jar)" -uvf "${S}/${JAVA_JAR_FILENAME}" \
		{skin,stdlib,svg,themes} || die "Failed to add extra files to JAR"
}

src_install() {
	java-pkg-simple_src_install
	make_desktop_entry plantuml PlantUML
}
