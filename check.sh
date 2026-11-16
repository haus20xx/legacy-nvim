#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
if [ ! -x output/nvim/bin/nvim ]; then
  echo "No extracted installation found; run ./build.sh first." >&2
  exit 1
fi

# Exercise the extracted installation at a different path, not the image copy.
docker run --rm --platform linux/amd64 \
  -v "$PWD/output/nvim:/check-nvim:ro" legacy-nvim:local \
  bash -c 'set -euo pipefail
    /check-nvim/bin/nvim --version | head -3
    /check-nvim/bin/nvim --headless --clean \
      +"lua assert(vim.env.VIMRUNTIME:match(\"^/check%-nvim/\")); print(vim.env.VIMRUNTIME)" +qa
    printf "\nDynamic libraries:\n"
    ldd /check-nvim/bin/nvim
    echo "glibc and libstdc++ symbol versions:"
    readelf --version-info /check-nvim/bin/nvim | grep -oE "GLIBC(X{2})?_[0-9.]+" | sort -Vu'
