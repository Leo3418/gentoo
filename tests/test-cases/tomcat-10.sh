#!/usr/bin/env bash

PORTAGE_CONFIGS=( tests/portage-configs/tomcat )

run_test() {
    # Explicitly install a JDK first for automatic eselect
    emerge -1 virtual/jdk
    emerge www-servers/tomcat:10
}
