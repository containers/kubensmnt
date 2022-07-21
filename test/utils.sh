#!/bin/bash

function setup_namespaces() {
    TESTDIR=$(mktemp -d)
    # Bound mount namespaces must be in an unbindable parent, so make sure our
    # testdir is unbindable
    mount --make-unbindable --bind "$TESTDIR" "$TESTDIR"

    # Set up a new mount namespace
    MOUNT_NAMESPACE=${TESTDIR}/mnt
    touch "$MOUNT_NAMESPACE"
    unshare --mount="$MOUNT_NAMESPACE" --propagation slave mount --make-rshared /
    NEW_NS=$(nsenter -m"$MOUNT_NAMESPACE" readlink /proc/self/ns/mnt)
    OLD_NS=$(readlink /proc/self/ns/mnt)

    # Set up a non-mount namespace for negative tests
    ALT_NAMESPACE=${TESTDIR}/net
    touch "$ALT_NAMESPACE"
    unshare --net="$ALT_NAMESPACE" true

    export TESTDIR MOUNT_NAMESPACE NEW_NS OLD_NS ALT_NAMESPACE
}

function teardown_namespaces() {
    [ -z "$TESTDIR" ] && return
    # Because both ALT_NAMESPACE and MOUNT_NAMESPACE root in $TESTDIR, a single
    # recursive unmount is enough to clean everything up:
    umount -R "$TESTDIR" || true
    rm -rf "$TESTDIR"
    unset TESTDIR MOUNT_NAMESPACE NEW_NS OLD_NS ALT_NAMESPACE
}
