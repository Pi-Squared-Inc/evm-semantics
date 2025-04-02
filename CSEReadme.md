Building & Testing
------------------

Build and test using the `Test` script.
This depends on K, that may be installed using `kup`:

    kup shell k --version v$(cat deps/k_release)

See [K's installation instructions](https://github.com/runtimeverification/k/blob/master/k-distribution/INSTALL.md)
for more details. *In particular it is useful to have the binary nix cache setup.*

Currently this script can only run the ULM test suite.

    ./Test

It also supports a `-v` option for more verbose building.

    ./Test -v

We integrate the semantics with the VLM, and so depend on clang/llvm 16 and Go
1.23.1. If your local versions differ form these we recommend using the
`dockerShell` script provided, that builds all dependencies in a Docker image,
while bind-mounting this repository. See the comment at the top `dockerShell`
for usage instruction.
