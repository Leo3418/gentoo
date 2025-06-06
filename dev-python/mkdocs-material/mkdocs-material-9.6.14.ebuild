# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-material-extensions
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs-redirects
"

inherit distutils-r1 docs

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="
	https://github.com/squidfunk/mkdocs-material/
	https://pypi.org/project/mkdocs-material/
"
SRC_URI="
	https://github.com/squidfunk/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
# bundled icons
LICENSE+=" Apache-2.0 CC0-1.0 CC-BY-4.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="social"

RDEPEND="
	>=dev-python/babel-2.10.3[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.6[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.5.3[${PYTHON_USEDEP}]
	>=dev-python/paginate-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.16[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-10.2[${PYTHON_USEDEP}]
	>=dev-python/readtime-2.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/regex-2022.4.24[${PYTHON_USEDEP}]
	' 'python*')
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	social? (
		>=dev-python/pillow-10.2[${PYTHON_USEDEP}]
		>=media-gfx/cairosvg-2.5[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/trove-classifiers-2023.10.18[${PYTHON_USEDEP}]
"
# mkdocs-material-extensions depends on mkdocs-material creating a circular dep
PDEPEND="
	>=dev-python/mkdocs-material-extensions-1.2[${PYTHON_USEDEP}]
"

PATCHES=(
	# simplify pyproject to remove extra deps for metadata
	"${FILESDIR}/${PN}-8.5.7-simplify-build.patch"
	# import backrefs only when used (i.e. never)
	"${FILESDIR}/${PN}-9.6.7-backrefs.patch"
)

src_prepare() {
	distutils-r1_src_prepare
	echo "__version__ = '${PV}'" > gentoo_version.py || die
}
