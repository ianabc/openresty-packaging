#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

Fatal() {
  echo "ERROR: ${1}" >&2
  exit 1
}

for specfile in ~/rpmbuild/SPECS/*.spec; do

  if ! spectool -g -R $specfile; then
    Fatal "Spectool unable to process specfile: $specfile"
  fi

  if ! rpmbuild -ba $specfile; then
    Fatal "Error building RPM: $specfile"
  fi

done
