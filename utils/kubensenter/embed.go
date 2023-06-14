package kubensenter

import (
	_ "embed"
)

//go:embed kubensenter
var Script string

//go:embed Makefile
var Makefile string
