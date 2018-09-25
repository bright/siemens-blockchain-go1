#!/usr/bin/env bash

set -e


if [[ -z IMAGE_TO_RUN ]]; then
    echo "Building parity node"
    docker build --no-cache -t siemensprivate .
fi

IMAGE_TO_RUN="${IMAGE_TO_RUN:-siemensprivate}"

echo "Running parity node: ${IMAGE_TO_RUN}"

function ctrl_c() {
    echo "Committing container: ${container_id}"
    commit_repository_tag="siemensprivate_$(whoami):$(date '+%Y-%m-%d-%H-%M-%S')"
    docker commit --message "siemensprivate $(date)" ${container_id} "${commit_repository_tag}"
    echo "Committed: ${commit_repository_tag}"
    docker stop ${container_id}
}

trap ctrl_c SIGINT

docker run -p 8080:8080 -p 8545:8545 -p 8546:8546 ${IMAGE_TO_RUN} &
container_pid=$!
sleep 1
container_id=$(docker ps -q --filter ancestor=${IMAGE_TO_RUN})

echo "Waiting for pid: ${container_pid} of container ${container_id}"

wait ${container_pid}