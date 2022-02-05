#!/usr/bin/env bash

EMERGE_OPTS="${DEFAULT_EMERGE_OPTS} --quiet-build --autounmask-continue=y"

run_test() {
    emerge sci-mathematics/coq
}
