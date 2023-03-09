# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests not enabled: Need JUnit 5 and several unpackaged dependencies
JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.ws.rs:jakarta.ws.rs-api:3.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta RESTful Web Services API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.rest"
SRC_URI="https://github.com/jakartaee/rest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( EPL-2.0 GPL-2-with-classpath-exception )"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jakarta-activation-api:2
	dev-java/jaxb-api:3
"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
"
#DEPEND+="
#	test? (
#		dev-java/istack-commons-runtime:0
#		dev-java/jaxb-runtime:4
#		dev-java/hamcrest:0
#		dev-java/mockito:4
#	)
#"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/rest-${PV}/${PN}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="istack-commons-runtime,jaxb-runtime-4,hamcrest,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
