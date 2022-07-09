#!/bin/bash

function setup_namespaces() {
    export TESTDIR=$(mktemp -d)

    export MOUNT_NAMESPACE=${TESTDIR}/mnt
    mount --make-unbindable --bind $TESTDIR $TESTDIR
    touch $MOUNT_NAMESPACE
    unshare --mount=$MOUNT_NAMESPACE --propagation slave mount --make-rshared /
    export NEW_NS=$(nsenter -m"$MOUNT_NAMESPACE" readlink /proc/self/ns/mnt)
    export OLD_NS=$(readlink /proc/self/ns/mnt)

    export ALT_NAMESPACE=${TESTDIR}/net
    touch $ALT_NAMESPACE
    unshare --net=$ALT_NAMESPACE true
}

function teardown_namespaces() {
    [ -z "$TESTDIR" ] && return
    umount $ALT_NAMESPACE || true
    umount $MOUNT_NAMESPACE || true
    umount $TESTDIR || true
    rm -rf "$TESTDIR"
    unset TESTDIR
}
