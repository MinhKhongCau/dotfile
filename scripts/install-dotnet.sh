#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating package lists..."
sudo apt-get update

echo "==> Installing dependencies..."
sudo apt-get install -y \
  zlib1g \
  tzdata \
  libstdc++6 \
  libssl3t64 \
  libicu74 \
  libgssapi-krb5-2 \
  libgcc-s1 \
  libc6 \
  ca-certificates

echo "==> Installing .NET SDK 10.0..."
sudo apt-get install -y dotnet-sdk-10.0

echo "==> Done! Verifying installation:"
dotnet --version
