#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/ant-core-doc )

run_test() {
    # Some dependencies for building Javadoc need Ant to build
    USE="-doc" emerge dev-java/ant-core
    emerge dev-java/ant-core
}
