#!/usr/bin/env bash

run_test() {
    emerge --onlydeps --with-test-deps =dev-java/jansi-1.13::gentoo
    FEATURES="test" emerge =dev-java/jansi-1.13::gentoo
}
