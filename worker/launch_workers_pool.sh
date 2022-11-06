#!/bin/bash
set -e

size=1
cre="${cre:-"podman"}"

usage() {
    cat << EOF
Usage: $0
To launch a pool of workers with the desired number of workers in individual
containers.
Options:
 -h, --help            display this help
 -s, --size=NUM        number of workers (by default is 1)
EOF
    exit "$1"
}

opts=$(getopt -o hs: --long help,size: -n "$0" -- "$@") || usage 1
eval set -- "$opts"

while true; do
  case "$1" in
    -h | --help ) usage 0; shift ;;
    -s | --size ) size=$2; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

for i in $(seq "$size"); do
  echo "Creating worker $i"
  $cre run \
    --detach --rm \
    --hostname "openqa_worker_$i" --name "openqa_worker_$i" \
    -v "$OPENQA_SITE_HOME/data/conf:/data/conf:ro" \
    -v "$OPENQA_SITE_HOME/data/work/factory:/data/factory:rw" \
    -v "$OPENQA_SITE_HOME/data/work/tests:/data/tests:ro" \
    --privileged openqa_worker \
    -e OPENQA_WORKER_INSTANCE="$i"
done
