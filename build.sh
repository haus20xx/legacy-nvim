#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
image=legacy-nvim:local
ref=${1:-v0.12.6}

if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [neovim-git-ref]" >&2
  exit 2
fi
if [ -e output/nvim ] || [ -e output/nvim-source-commit ]; then
  echo "Output already exists; move it or run ./clean.sh --output first." >&2
  exit 1
fi

docker build --platform linux/amd64 --build-arg "NVIM_REF=$ref" -t "$image" .
container=$(docker create --platform linux/amd64 "$image")
trap 'docker rm "$container" >/dev/null' EXIT
mkdir -p output
docker cp "$container:/opt/nvim" output/nvim
docker cp "$container:/nvim-source-commit" output/nvim-source-commit

echo "Built output/nvim from $(<output/nvim-source-commit)"
