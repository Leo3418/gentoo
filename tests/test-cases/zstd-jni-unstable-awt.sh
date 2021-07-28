#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/unstable )

run_test() {
    USE="-headless-awt" emerge -1 dev-java/openjdk-bin:8 virtual/jdk:1.8
    emerge --info dev-java/openjdk-bin
    emerge dev-java/zstd-jni
}
