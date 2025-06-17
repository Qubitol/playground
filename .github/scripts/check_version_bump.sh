#!/bin/bash
set -e

PR_VERSION=$1
BASE_VERSION=$2

if [[ -z "$PR_VERSION" || -z "$BASE_VERSION" ]]; then
  echo "Usage: $0 <pr_version> <base_version>"
  exit 1
fi

echo "PR version: $PR_VERSION"
echo "Base version: $BASE_VERSION"

if [[ "$PR_VERSION" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  PR_MAJOR=${BASH_REMATCH[1]}
  PR_MINOR=${BASH_REMATCH[2]}
  PR_PATCH=${BASH_REMATCH[3]}
else
  echo "ERROR: PR version '$PR_VERSION' does not match semantic versioning format vX.Y.Z"
  exit 1
fi

if [[ "$BASE_VERSION" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  BASE_MAJOR=${BASH_REMATCH[1]}
  BASE_MINOR=${BASH_REMATCH[2]}
  BASE_PATCH=${BASH_REMATCH[3]}
else
  echo "ERROR: Base version '$BASE_VERSION' does not match semantic versioning format vX.Y.Z"
  exit 1
fi

echo "PR version parsed as: major=$PR_MAJOR minor=$PR_MINOR patch=$PR_PATCH"
echo "Base version parsed as: major=$BASE_MAJOR minor=$BASE_MINOR patch=$BASE_PATCH"

if (( PR_MAJOR > BASE_MAJOR )); then
  echo "Version major bumped from $BASE_MAJOR to $PR_MAJOR. OK."
  exit 0
elif (( PR_MAJOR == BASE_MAJOR )); then
  if (( PR_MINOR > BASE_MINOR )); then
    echo "Version minor bumped from $BASE_MINOR to $PR_MINOR. OK."
    exit 0
  elif (( PR_MINOR == BASE_MINOR )); then
    if (( PR_PATCH > BASE_PATCH )); then
      echo "Version patch bumped from $BASE_PATCH to $PR_PATCH. OK."
      exit 0
    else
      echo "ERROR: Version must be bumped."
      exit 1
    fi
  else
    echo "ERROR: Minor version must not decrease."
    exit 1
  fi
else
  echo "ERROR: Major version must not decrease."
  exit 1
fi

