#!/usr/bin/env bash

set -eo pipefail

if [[ $BUILDKITE ]]; then
  readarray -t PACKAGE_LIST < <( buildkite-agent meta-data package-names )
else
  readarray -td ' ' PACKAGE_LIST < <( printf "docker packer vault" )
fi

if [[ -z $PACKAGE_LIST ]]; then
  echo "No packages provided"
  exit 0
fi

function generate_steps() {
cat <<GROUP
- group: ":buildkite: :bash: Packages"
  steps:
GROUP
for package in "${PACKAGE_LIST[@]}"; do
cat <<STEP
    - label: 'Install $package'
      command: brew install $package
      agents:
        queue: build

STEP
done
}

if [[ $BUILDKITE ]]; then
  generate_steps | buildkite-agent pipeline upload
else
  generate_steps
fi
