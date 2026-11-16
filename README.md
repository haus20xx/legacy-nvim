# Legacy Linux Neovim build

Build an **x86-64** Neovim installation against the glibc 2.17-era
manylinux2014 userspace, using its newer compiler. This is an unofficial build;
compatibility with a particular RHEL 7 machine must be tested on that machine.
The Docker image and downloaded dependencies require network access.

## Build

From this directory:

```sh
./build.sh                  # build and extract v0.12.6
./check.sh                  # smoke-test the extracted installation in Docker
```

To select another upstream tag or commit, use `./build.sh v0.12.5`, for
example. The script builds the image and extracts the installation into
`output/nvim`, with the resolved source commit in `output/nvim-source-commit`.
It refuses to overwrite an existing installation. Moving branches are allowed
but are not reproducible. The base image tag and upstream dependency downloads
can also change; this recipe does not pin every input by digest. Some revisions
may need a different compiler, CMake, or other changes.

On Apple Silicon, `--platform linux/amd64` requires Docker's x86-64 emulation;
the resulting binary is for x86-64 Linux, not ARM64.

## Extract and use

Copy **all** of `output/nvim` to the target, not only the executable.
`check.sh` checks the relocated installation inside the build image; it does not
replace testing on the target system.

On the target machine:

```sh
/path/to/nvim/bin/nvim --version
ldd /path/to/nvim/bin/nvim
readelf --version-info /path/to/nvim/bin/nvim | grep -E 'GLIBC_|GLIBCXX_'
/path/to/nvim/bin/nvim --clean
```

Check for missing libraries and symbols requiring a newer glibc. This does not
prove that every dynamically loaded library is compatible; test the features
and plugins you need. Plugins and external language servers may have their own
runtime requirements. Do not replace the system glibc to run this build.

## Cleanup

```sh
./clean.sh --output  # permanently remove the entire output directory
./clean.sh --image   # remove the legacy-nvim:local Docker image
```

These operations are separate. Neither removes Docker's shared build cache.
