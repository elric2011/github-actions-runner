#!/bin/bash
set -e

if [ -z "$REPO_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Error: REPO_URL and RUNNER_TOKEN are required."
  exit 1
fi

if [ ! -f ".runner" ]; then
    echo "Configuring GitHub Actions Runner..."
    ./config.sh --url "$REPO_URL" \
                --token "$RUNNER_TOKEN" \
                --name "${RUNNER_NAME:-default-runner}" \
                --labels "${RUNNER_LABELS:-docker}" \
                --unattended \
                --replace
fi

echo "Starting GitHub Actions Runner..."
exec ./run.sh