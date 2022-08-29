# Supporting Utilities

The subdirectories in this area contain utilities that work alongside
the main go library entrypoint to implement mount namespace hiding
for Kubernetes:

- [systemd](systemd/README.md) comtains `kubens.service`, a systemd
  service to create the right kind of mount namespace for this
  feature, as well as drop-ins to help other services run inside that
  namespace.
- [kubensenter](kubensenter/README.md) is a script which, much like
  `nsentner(1)`, runs commands in the mount namespace created bt
  `kubens.swrvice`

# Inatallation

```
sudo make install [WRAP_SERVICES=...] [ENV_SERVICES=...]
```

This will install both `kubensenter` and `kubens.service`, and
optionally wrap the services listed under `WRAP_SERVICES` so they run
under `kubensmnt`, or add appropriate environmental drop-in to
services listed under `ENV_SERVICES` so services built with this go
library auto-detect whether `kubens.service` is running and join the
appropriate namespace.

Adding WRAP_SERVICES=... will also create drop-in wrappers
which wraps each service's ExecStart line with kubensenter:
```
sudo make install WRAP_SERVICES="k3s.service other.service"
```

Adding ENV_SERVICES=... will also create drop-ins which set
$$KUBENSMNT for use with services that can enter the mount
namespace on their own:
```
make install ENV_SERVICES="crio.service"
```

## Go vendoring

If you are using vendored go modules, you may also include these
utils files via go embed inclusion. Just set up a tools.go like
this:

```go
//go:build tools
// +build tools

// tools is a dummy package that will be ignored for builds, but included for dependencies.
package tools

import (
	_ "github.com/containers/kubensmnt/utils"
)
```

Then, as usual, run:
```bash
go get github.com/containers/kubensmnt@latest # or some tag
go mod tidy
go mod vendor
```

The kubensenter script will be in your local vendor/github.com/containers/kubensmnt/utils/kubensenter/ directory, and the systemd files under endor/github.com/containers/kubensmnt/utils/systemd/
