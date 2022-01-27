# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:jakarta.mail:1.6.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Mail API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.mail"
SRC_URI="https://github.com/eclipse-ee4j/mail/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( EPL-2.0 GPL-2-with-classpath-exception )"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jakarta-activation:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/mail-${PV}/mail"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_ENCODING="iso-8859-1"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXTRA_ARGS=( -ea )
JAVA_TEST_EXCLUDES=(
	# Only *Test.java and *TestSuite.java would be run by upstream
	# https://github.com/eclipse-ee4j/mail/blob/1.6.7/mail/pom.xml#L132-L141
	com.sun.mail.test.TestSSLSocketFactory
	com.sun.mail.test.TestServer
	com.sun.mail.test.TestSocketFactory
	# "Permission denied" when creating temp files for tests
	com.sun.mail.util.logging.MailHandlerTest
)

src_prepare() {
	java-pkg_clean
	cp "${JAVA_RESOURCE_DIRS}/javax/mail/Version.java" \
		"${JAVA_SRC_DIR}/javax/mail" || die "Failed to copy Version.java"
	sed -i -e "s/\${mail.version}/${PV}/g" \
		"${JAVA_SRC_DIR}/javax/mail/Version.java" ||
		die "Failed to write package version to Version.java"
	java-pkg-2_src_prepare
}
