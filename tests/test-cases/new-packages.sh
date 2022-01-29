#!/usr/bin/env bash

run_test() {
    # Install desired version of JDK and JRE
    emerge --quiet-build --noreplace @world
    # Install for Java package checking
    emerge --quiet-build dev-java/javatoolkit dev-java/java-dep-check

    emerge --onlydeps --with-test-deps \
        dev-java/jol-core dev-java/antlr-tool:4
    FEATURES="test" emerge \
        dev-java/jol-core dev-java/antlr-tool:4
}
