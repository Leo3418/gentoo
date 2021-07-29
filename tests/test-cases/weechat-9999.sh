#!/usr/bin/env bash

run_test() {
    # Generate required locale for test
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen

    emerge --onlydeps --with-test-deps =net-irc/weechat-9999
    FEATURES="test" emerge =net-irc/weechat-9999
}
