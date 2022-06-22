#!/usr/bin/env bats
# vim:set ft=bash :

function setup_file() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    export PATH="$DIR:$PATH"

    export TESTDIR=$(mktemp -d)

    export MOUNT_NAMESPACE=${TESTDIR}/mnt
    mount --make-unbindable --bind $TESTDIR $TESTDIR
    touch $MOUNT_NAMESPACE
    unshare --mount=$MOUNT_NAMESPACE --propagation slave mount --make-rshared /
    export NEW_NS=$(nsenter -m"$MOUNT_NAMESPACE" readlink /proc/self/ns/mnt)
    export OLD_NS=$(readlink /proc/self/ns/mnt)

    export ALT_NAMESPACE=${TESTDIR}/time
    touch $ALT_NAMESPACE
    unshare --time=$ALT_NAMESPACE sleep infinity &
    export ALT_PID=$!
}

function teardown_file() {
    echo $output
    [ -z "$TESTDIR" ] && return
    kill $ALT_PID
    umount $ALT_NAMESPACE || true
    umount $MOUNT_NAMESPACE || true
    umount $TESTDIR || true
    rm -rf "$TESTDIR"
    unset TESTDIR
}

@test "With cgo: No config" {
    ns=$(test-linux)
    echo "NS:$ns OLD:$OLD_NS"
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
    echo $output
}
