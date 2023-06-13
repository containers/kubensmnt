#!/usr/bin/env bats
# vim:set ft=bash :
# shellcheck disable=1091,2030,2031
# ^- Disable checks around exports within subshells; that's how these tests must work
# ^- Also disable import checks; we check utils.sh explicitly

type bats_require_minimum_version &>/dev/null && \
  bats_require_minimum_version 1.5.0

DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
. "$DIR/../../../test/utils.sh"

function setup_file() {
    setup_namespaces

    # Ensure kubensenter (in the parent directory) is in the path
    export PATH="$DIR/..:$PATH"
}

function teardown_file() {
    teardown_namespaces
}

@test "KUBENSMNT: success" {
    export KUBENSMNT="$MOUNT_NAMESPACE"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$NEW_NS" ]]
}

@test "KUBENSMNT: no such file" {
    export KUBENSMNT="$TESTDIR/no_such_file"
    run ! kubensenter readlink /proc/self/ns/mnt
}

@test "KUBENSMNT: no namespace" {
    export KUBENSMNT="$TESTDIR/empty_file"
    touch "$KUBENSMNT"
    run ! kubensenter readlink /proc/self/ns/mnt
}

@test "KUBENSMNT: bad namespace" {
    export KUBENSMNT="$ALT_NAMESPACE"
    run ! kubensenter readlink /proc/self/ns/mnt
}

@test "Autodetect: success" {
    unset KUBENSMNT
    export DEFAULT_KUBENSMNT="$MOUNT_NAMESPACE"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$NEW_NS" ]]
}

@test "Autodetect: no such file" {
    unset KUBENSMNT
    export DEFAULT_KUBENSMNT="$TESTDIR/no_such_file"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$OLD_NS" ]]
}

@test "Autodetect: no namespace" {
    unset KUBENSMNT
    export DEFAULT_KUBENSMNT="$TESTDIR/empty_file"
    touch "$DEFAULT_KUBENSMNT"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$OLD_NS" ]]
}

@test "Autodetect: bad namespace" {
    unset KUBENSMNT
    export DEFAULT_KUBENSMNT="$ALT_NAMESPACE"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$OLD_NS" ]]
}

@test "Precedence: success" {
    export KUBENSMNT="$MOUNT_NAMESPACE"
    export DEFAULT_KUBENSMNT="$ALT_NAMESPACE"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$NEW_NS" ]]
}

@test "Precedence: failure" {
    export KUBENSMNT="$ALT_NAMESPACE"
    export DEFAULT_KUBENSMNT="$MOUNT_NAMESPACE"
    run ! kubensenter readlink /proc/self/ns/mnt
}

@test "Precedence: success when file is not mounted correctly" {
    touch "$TESTDIR/file_without_mount"
    export KUBENSMNT="$TESTDIR/file_without_mount"
    ns=$(kubensenter readlink /proc/self/ns/mnt)
    [[ "$ns" == "$OLD_NS" ]]
}
