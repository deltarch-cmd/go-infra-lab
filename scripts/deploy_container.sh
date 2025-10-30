#!/usr/bin/env sh

# --env-file .env \
# --network go-infra-app-network \ # If it needs a database or smth

trap 'podman stop go-infra-app; exit 1' INT  # Ctrl+C
trap 'podman stop go-infra-app; exit 1' QUIT # Ctrl+\

podman run \
    --rm \
    --name go-infra-app \
    --publish 8080:8080 \
    go_infra_lab &

while true; do
    read -p "Server running! Ctrl+C or Ctrl+\\ to quit..."
done
