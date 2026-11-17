#!/usr/bin/env bash
# Run a node command in a transient docker container.
#
# Usage:  docker-node.sh <command> [args...]
#   docker-node.sh npm install
#   docker-node.sh npm ci
#   docker-node.sh npx --yes npm-check-updates -u
#   docker-node.sh node -e 'console.log(process.version)'
#
# Baked-in flags (agent never hand-builds the docker run line):
#   --rm -i            throwaway, no TTY (agents are non-interactive)
#   -e CI=true         suppress interactive prompts
#   --platform x86_64  prod/CI parity (native deps resolve identically)
#   -v npm-cache       persist npm cache across --rm runs
#   -v $PWD:/usr/src/app -w /usr/src/app   mount repo, run there
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "dockerized-tools: docker CLI not found in PATH" >&2
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "dockerized-tools: docker daemon unreachable. Is /var/run/docker.sock mounted?" >&2
  exit 1
fi

# Resolve node version: .nvmrc -> engines.node -> lts
NODE_VERSION=""
if [[ -f .nvmrc ]]; then
  NODE_VERSION="$(tr -d '[:space:]' < .nvmrc | sed 's/^v//')"
fi
if [[ -z "$NODE_VERSION" && -f package.json ]]; then
  NODE_VERSION="$(sed -nE 's/.*"node"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p' package.json \
    | grep -oE '[0-9]+' | head -n1 || true)"
fi
if [[ -z "$NODE_VERSION" ]]; then
  NODE_VERSION="lts"
fi
if ! [[ "$NODE_VERSION" =~ ^[0-9]+$ || "$NODE_VERSION" == "lts" ]]; then
  echo "dockerized-tools: unrecognized node version '$NODE_VERSION', falling back to lts" >&2
  NODE_VERSION="lts"
fi

IMAGE="node:${NODE_VERSION}-alpine"

# Preflight: confirm the docker daemon sees $PWD (bind-mount from a shared host
# path). A mounted-but-unknown path silently yields an empty dir; detect it by
# checking a file we know exists on the host side.
sentinel=""
for f in package.json package-lock.json .nvmrc README.md .git; do
  [[ -e "$f" ]] && { sentinel="$f"; break; }
done
if [[ -n "$sentinel" ]]; then
  if ! docker run --rm -i \
      -v "$PWD:/usr/src/app" \
      -w /usr/src/app \
      --platform linux/x86_64 \
      --entrypoint sh "$IMAGE" \
      -c "test -e /usr/src/app/$sentinel"; then
    echo "dockerized-tools: bind-mount failed: \$PWD not visible to docker daemon as a host path." >&2
    echo "  \$PWD=$PWD" >&2
    exit 1
  fi
fi

exec docker run --rm -i \
  -v "$PWD:/usr/src/app" \
  -w /usr/src/app \
  -e CI=true \
  --platform linux/x86_64 \
  -v npm-cache:/root/.npm \
  "$IMAGE" "$@"
