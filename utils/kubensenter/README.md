# kubensenter

A command line wrapper to run commands or shells inside the `kubens.service`
mount namespace.

## Usage

```
kubensenter [options] [command ...]
```

Autodetect whether the `kubens.service` has pinned a mount namespace in a
well-known location, and if so, join it by passing it and the user-specified
command to nsenter(1). If `kubens.service` has not set up the mount namespace,
the user-specified command is still executed by nsenter(1) but no namespace is
entered.

If $KUBENSMNT is set in the environment, skip autodetection and attempt to join
that mount namespace by passing it and the user-specified command to
nsenter(1). If the mount namespace is missing or invalid, the command will
fail.

In either case, if no command is given on the command line, nsenter(1) will
spawn a new interactive shell which will be inside the mount namespace if
detected.

## Options

`-q` | `--quiet`: Do not print anything to stderr (default: print a few autodetect log messages to stderr)

`-v` | `--verbose`: Print more debug messages to stderr

## Examples

Run `mount` in the autodetected kubens.service mount namespace, or the default
namespace if it isn't running:

```
kubensenter mount
```

Start a new interactive shell in the autodetected kubens.service mount
namespace, or the default namespace if it isn't running:

```
kubensenter
```

## See Also

`nsenter(1)`

# Installation

We recommend running the installation scripts from the [parent utils
directory](../README.md)

However, you can install only the kubensenter script at this level:

```
sudo make install
```

This will copy the kubensenter script into /usr/local/bin.

## Go vendoring

If you are using vendored go modules, you may also include this via
go embed inclusion. Just set up a tools.go like this:

```go
//go:build tools
// +build tools

// tools is a dummy package that will be ignored for builds, but included for dependencies.
package tools

import (
	_ "github.com/containers/kubensmnt/utils/kubensenter"
)
```

Then, as usual, run:
```bash
go get github.com/containers/kubensmnt@latest # or some tag
go mod tidy
go mod vendor
```

The kubensenter script will be in your local vendor/github.com/containers/kubensmnt/utils/kubensenter/ directory.
