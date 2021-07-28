#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/unstable )

run_test() {
    # USE="headless-awt"
    emerge --info dev-java/openjdk-bin
    emerge dev-java/zstd-jni
}
