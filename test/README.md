# kubensmnt testing

Uses [bats](https://bats-core.readthedocs.io/) as a test engine.

Requires sudo to run in order to create new namespaces.

Bakes 2 flavors of the same executable, one with cgo enabled, and one without, to exercise both variants of the library.
