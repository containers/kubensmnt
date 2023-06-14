package main

import (
	"fmt"

	kubensmnt "github.com/containers/kubensmnt/utils"
	nsenter "github.com/containers/kubensmnt/utils/kubensenter"
	systemd "github.com/containers/kubensmnt/utils/systemd"
)

func main() {
	fmt.Println(kubensmnt.Makefile)
	fmt.Println(systemd.Service)
	fmt.Println(nsenter.Script)
}
