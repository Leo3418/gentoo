#!/usr/bin/env bash

run_test() {
    # USE="headless-awt"
    emerge --info dev-java/openjdk-bin
    emerge dev-java/zstd-jni
}
