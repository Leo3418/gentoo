# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.xml.rpc:javax.xml.rpc-api:1.1.2"

inherit java-pkg-2 java-pkg-simple

MY_PN="javax.xml.rpc-api"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java APIs for XML based RPC"
HOMEPAGE="https://javaee.github.io/javaee-spec/"
SRC_URI="https://github.com/javaee/javax.xml.rpc/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( CDDL GPL-2-with-classpath-exception )"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/javax-xml-soap-api:0
	dev-java/tomcat-servlet-api:4.0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/javax.xml.rpc-${MY_P}"

JAVA_SRC_DIR="src/main/java"
