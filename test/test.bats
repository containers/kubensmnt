#!/usr/bin/env bats
# vim:set ft=bash :

type bats_require_minimum_version &>/dev/null && \
  bats_require_minimum_version 1.5.0

DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
. $DIR/utils.sh

function setup_file() {
    setup_namespaces
    export PATH="$DIR:$PATH"
}

function teardown_file() {
    teardown_namespaces
}

@test "With cgo: No config" {
    ns=$(test-linux)
    [[ "$ns" == "$OLD_NS" ]]
}

@test "With cgo: Good config" {
    export KUBENSMNT="$MOUNT_NAMESPACE"
    ns=$(test-linux)
    [[ "$ns" == "$NEW_NS" ]]
}

@test "With cgo: Missing file" {
    export KUBENSMNT="$TESTDIR/nosuchfile"
    run ! test-linux
}

@test "With cgo: Not a bindmount" {
    export KUBENSMNT="$TESTDIR/plainfile"
    touch $KUBENSMNT
    run ! test-linux
}

@test "With cgo: Mismatched bindmount" {
    export KUBENSMNT="$ALT_NAMESPACE"
    run ! test-linux
}

@test "Without cgo: No config" {
    ns=$(test-nonlinux)
    [[ "$ns" == "$OLD_NS" ]]
}

@test "Without cgo: Good config" {
    export KUBENSMNT="$MOUNT_NAMESPACE"
    run ! test-nonlinux
}

@test "Without cgo: Missing file" {
    export KUBENSMNT="$TESTDIR/nosuchfile"
    run ! test-nonlinux
}

@test "Without cgo: Not a bindmount" {
    export KUBENSMNT="$TESTDIR/plainfile"
    touch $KUBENSMNT
    run ! test-nonlinux
}

@test "Without cgo: Mismatched bindmount" {
    export KUBENSMNT="$ALT_NAMESPACE"
    run ! test-nonlinux
}
