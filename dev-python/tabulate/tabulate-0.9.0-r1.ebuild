# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Pretty-print tabular data"
HOMEPAGE="
	https://github.com/astanin/python-tabulate/
	https://pypi.org/project/tabulate/
"
SRC_URI="
	https://github.com/astanin/python-${PN}/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep 'sqlite')
		dev-python/colorclass[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		' 'python3*')
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=()
	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			test/test_input.py::test_pandas
			test/test_input.py::test_pandas_firstrow
			test/test_input.py::test_pandas_keys
			test/test_output.py::test_pandas_with_index
			test/test_output.py::test_pandas_without_index
			test/test_output.py::test_pandas_rst_with_index
			test/test_output.py::test_pandas_rst_with_named_index
		)
	fi
	epytest
}
