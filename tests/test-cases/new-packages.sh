#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/new-packages )

run_test() {
    emerge dev-java/glassfish-xmlrpc-api
}
