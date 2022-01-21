#!/usr/bin/env bash

run_test() {
    # Install for Java package checking
    emerge --quiet-build dev-java/javatoolkit dev-java/java-dep-check

    emerge --onlydeps --with-test-deps \
        dev-java/antlr-tool:3.5 dev-java/stringtemplate:4
    FEATURES="test" emerge \
        dev-java/antlr-tool:3.5 dev-java/stringtemplate:4
}
