package utils

import (
	_ "embed"

	_ "github.com/containers/kubensmnt/utils/kubensenter"
	_ "github.com/containers/kubensmnt/utils/systemd"
)

//go:embed Makefile
var Makefile string
