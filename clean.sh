#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
case ${1:-} in
  --output)
    if [ -d output ]; then
      echo "Removing $(pwd)/output and its contents."
      rm -r -- output
    else
      echo "No output directory to remove."
    fi
    ;;
  --image)
    docker image rm legacy-nvim:local
    ;;
  *)
    echo "Usage: $0 --output | --image" >&2
    echo "--output removes the entire output directory; --image removes the local build image." >&2
    exit 2
    ;;
esac
