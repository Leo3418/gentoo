#!/usr/bin/env bash

# ebuild Installation Test Launcher Script
#
# When running the script, please make sure the working directory is the root
# directory of this repository.

DEFAULT_EMERGE_OPTS="--color y --verbose --keep-going"

main() {
    for script in "$@"; do
        unset DOCKER_IMAGE PROFILE GENTOO_REPO THREADS EMERGE_OPTS PULL
        unset STORAGE_OPTS PORTAGE_CONFIGS CUSTOM_REPOS SKIP_CLEANUP

        . "${script}"

        args=(
            ebuild-cmder
            --gentoo-repo .
            --emerge-opts "${EMERGE_OPTS:-"${DEFAULT_EMERGE_OPTS}"}"
            --portage-config tests/portage-configs/default
            ${DOCKER_IMAGE:+--docker-image ${DOCKER_IMAGE}}
            ${PROFILE:+--profile ${PROFILE}}
            ${THREADS:+--threads ${THREADS}}
            ${PULL:+--pull}
            ${STORAGE_OPTS:+--storage-opts ${STORAGE_OPTS}}
            ${SKIP_CLEANUP:+--skip-cleanup ${SKIP_CLEANUP}}
        )
        for config in "${PORTAGE_CONFIGS[@]}"; do
            args+=( --portage-config "${config}" )
        done
        for repo in "${CUSTOM_REPOS[@]}"; do
            args+=( --custom-repo "${repo}" )
        done

        # Pipe the run_test function's body into ebuild-commander
        type run_test | sed '1,3d;$d' | "${args[@]}"
    done
}

if [[ -n "$@" ]]; then
    main "$@"
else
    main tests/test-cases/*
fi
