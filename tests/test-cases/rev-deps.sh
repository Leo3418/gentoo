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

    # Install desired version of JDK and JRE
    emerge --quiet-build --noreplace @world
    # Install for Java package checking
    emerge --quiet-build dev-java/javatoolkit dev-java/java-dep-check

    emerge dev-java/antlr:4

    echo -e "\nEnumerating reverse dependencies..."
    pquery --atom --restrict-revdep \
        dev-java/antlr:4 >> rev-deps.txt
    # Remove duplicates
    sort -Vu rev-deps.txt > tmp.txt
    mv tmp.txt rev-deps.txt
    echo -e "\nReverse dependencies to be tested:"
    cat rev-deps.txt

    # Install reverse dependencies one by one
    # in case some reverse dependencies have slot conflict with others
    xargs -n 1 -r -a rev-deps.txt \
        emerge --onlydeps --with-test-deps --quiet-build
    FEATURES="test" xargs -n 1 -r -a rev-deps.txt emerge
}
