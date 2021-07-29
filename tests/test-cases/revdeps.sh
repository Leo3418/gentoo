#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/revdeps )

run_test() {
    # Prepare to find reverse dependencies with pquery

    # /var/db/repos/gentoo is mounted read-only in the Docker container
    cp -r /var/db/repos/gentoo /tmp
    echo 'PORTDIR="/tmp/gentoo"' >> /etc/portage/make.conf
    # pquery requires ::gentoo to be defined in repos.conf
    echo "[gentoo]" >> /etc/portage/repos.conf/gentoo.conf
    echo "location = /tmp/gentoo" >> /etc/portage/repos.conf/gentoo.conf
    # Extract metadata cache to speed up emerge and pquery
    wget -qO - "https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz" \
        | tar -xz --strip-components=1 -C /tmp/gentoo \
        gentoo-master/metadata/md5-cache

    emerge -1 --quiet-build sys-apps/pkgcore

    emerge =dev-java/jansi-1.13::gentoo

    echo -e "\nReverse dependencies to be tested:"
    pquery --atom --raw --unfiltered --restrict-revdep dev-java/jansi:0 | \
        tee revdeps.txt

    xargs -a revdeps.txt emerge --onlydeps --with-test-deps
    FEATURES="test" xargs -a revdeps.txt emerge
}
