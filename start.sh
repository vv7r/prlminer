#!/usr/bin/env bash
# prlminer - Pearl (PRL). Fill in WALLET, WORKER and POOL below, then run this file.
# POOL needs its scheme, e.g. stratum+ssl://prl-eu.kryptex.network:8048
WALLET=YOUR_WALLET
WORKER=worker
POOL=YOUR_POOL

DIR="$(cd "$(dirname "$0")" && pwd)"

while true; do
  "$DIR/prlminer" -o "$POOL" -u "$WALLET" -w "$WORKER"
  code=$?
  # A clean exit (code 0) is a deliberate stop (Ctrl-C): leave it stopped. Anything else is a
  # crash, and the launcher brings the miner back.
  if [ "$code" -eq 0 ]; then
    break
  fi
  echo "prlminer exited ($code), restarting in 10 s..."
  sleep 10
done
