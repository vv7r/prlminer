#!/usr/bin/env bash
# Packages the release binary and the HiveOS scripts into prlminer-<version>.tar.gz, ready to be
# uploaded from the HiveOS web UI (Miners -> Custom -> upload).
#
# Usage: build.sh <version> [path-to-prlminer-binary]
#   <version>                  release version, e.g. 0.1.0
#   [path-to-prlminer-binary]  default: ./prlminer (next to this repo's root)
#
# The archive is written to the current working directory.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 <version> [path-to-prlminer-binary]" >&2
  exit 2
fi

version="$1"
here="$(cd "$(dirname "$0")" && pwd)"
bin="${2:-$(cd "$here/.." && pwd)/prlminer}"

[ -x "$bin" ] || { echo "no executable at $bin (pass the path as the 2nd argument)" >&2; exit 1; }

stage="$(mktemp -d)"
pkg="$stage/prlminer-$version"
mkdir -p "$pkg"
cp "$bin" "$pkg/prlminer"
cp "$here/h-config.sh" "$here/h-run.sh" "$pkg/"
chmod +x "$pkg/prlminer" "$pkg/h-config.sh" "$pkg/h-run.sh"

out="$PWD/prlminer-$version.tar.gz"
tar -C "$stage" -czf "$out" "prlminer-$version"
rm -rf "$stage"
echo "built $out"
tar -tzf "$out"
