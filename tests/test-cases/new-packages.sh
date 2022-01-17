#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/new-packages )

run_test() {
    # Explicitly install a JDK first for automatic eselect
    emerge -1 virtual/jdk
    emerge dev-java/javax-xml-rpc-api
}
