# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="javax.xml.soap:javax.xml.soap-api:1.4.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="javax.xml.soap API (SAAJ API)"
HOMEPAGE="https://javaee.github.io/javaee-spec/"
SRC_URI="https://github.com/javaee/javax.xml.soap/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( CDDL GPL-2-with-classpath-exception )"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/jakarta-activation-api:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/javax.xml.soap-${PV}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )

src_test() {
	if ver_test "$(java-config -g PROVIDES_VERSION)" -lt 9; then
		# https://github.com/javaee/javax.xml.soap/blob/1.4.0/pom.xml#L134-L143
		JAVA_TEST_EXTRA_ARGS=( -Xbootclasspath/p:target/classes )
	else
		# '-Xbootclasspath/p' removed since JDK 9; '-Xbootclasspath/a' remains
		# https://openjdk.java.net/jeps/261
		JAVA_TEST_EXTRA_ARGS=( -Xbootclasspath/a:target/classes )
	fi
	java-pkg-simple_src_test
}
