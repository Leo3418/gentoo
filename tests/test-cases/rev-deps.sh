#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/rev-deps )

run_test() {
    # Prepare to find reverse dependencies with pquery

    echo "Preparing metadata cache..."
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

    emerge --quiet-build sys-apps/pkgcore

    # Install for Java package checking
    emerge --quiet-build dev-java/javatoolkit dev-java/java-dep-check

    emerge \
        dev-java/antlr:3.5 dev-java/stringtemplate:4

    echo -e "\nEnumerating reverse dependencies..."
    pquery --atom --raw --unfiltered --restrict-revdep \
        dev-java/antlr:3.5 >> rev-deps.txt
    pquery --atom --raw --unfiltered --restrict-revdep \
        dev-java/stringtemplate:4 >> rev-deps.txt
    # Remove duplicates
    sort -Vu rev-deps.txt > tmp.txt
    mv tmp.txt rev-deps.txt
    # Remove older version of dev-java/antlr:3.5
    sed -i -e '/=dev-java\/antlr-3.5.2-r1/d' rev-deps.txt
    echo -e "\nReverse dependencies to be tested:"
    cat rev-deps.txt

    # Required by app-text/build-docbook-catalog
    # https://github.com/gentoo/gentoo-docker-images/issues/115
    mkdir -p /run/lock

    # Install reverse dependencies one by one
    # in case some reverse dependencies have slot conflict with others
    xargs -n 1 -a rev-deps.txt emerge --onlydeps --with-test-deps --quiet-build
    FEATURES="test" xargs -n 1 -a rev-deps.txt emerge
}
