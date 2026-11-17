---
name: dockerized-tools
description: Run node/npm/npx commands in a transient docker container when the agent lacks host node. Use when npm, npx, or node is missing or command-not-found, when a repo has .nvmrc or package.json and a node command must run, or when asked to run npm install/ci/update in docker.
---

# dockerized-tools

Run node commands in a throwaway docker container. Agent runs inside a container with no host toolchain; this mounts the repo into a `node:VERSION-alpine` container and runs the command there.

## Steps

1. Run the wrapper with the command as args (from the repo root, so `$PWD` is the repo):

   ```bash
   .agents/skills/dockerized-tools/scripts/docker-node.sh <command> [args...]
   ```

   The script resolves the node version, preflights docker, then runs the command. Agent never hand-builds the `docker run` line.

2. Wait for exit. Completion criterion: exit code 0, and for installs the repo's `node_modules` / lockfile on the host (`$PWD`) reflect the change.

## Recipes

- **Reproducible install** (lockfile respected):

  ```bash
  .agents/skills/dockerized-tools/scripts/docker-node.sh npm ci
  ```

- **Update all dependencies** (bumps majors, rewrites lockfile):

  ```bash
  .agents/skills/dockerized-tools/scripts/docker-node.sh npx --yes npm-check-updates -u
  .agents/skills/dockerized-tools/scripts/docker-node.sh npm install
  ```

- **One-off script / check**:

  ```bash
  .agents/skills/dockerized-tools/scripts/docker-node.sh npm run <script>
  .agents/skills/dockerized-tools/scripts/docker-node.sh node -e '<code>'
  ```

- **Env vars for a script** (`npm run dev` needs `NEXT_PUBLIC_*`): pass them through `env` — the image runs it:

  ```bash
  .agents/skills/dockerized-tools/scripts/docker-node.sh env NEXT_PUBLIC_SANITY_DATASET=preview npm run dev
  ```

## Reference

- **Version resolution**: `.nvmrc` (whitespace trimmed, leading `v` stripped) → `package.json` `engines.node` (first number) → `lts`. Image is `node:VERSION-alpine`.
- **Flags baked into the script**: `--rm -i` (throwaway, no TTY), `-e CI=true`, `--platform linux/x86_64` (prod/CI parity — native deps like sharp resolve identically; on an aarch64 agent this means qemu emulation, slow but correct), `-v npm-cache:/root/.npm` (npm cache persists across `--rm` runs).
- **Ownership**: container runs as root, so files it writes (`node_modules`, lockfile) are root-owned. Consistent with the agent's own root writes. If the repo must stay host-user-owned, add `--user "$(stat -c %u:%g .)"` to the `docker run` line in the script.
- **Auth**: `.npmrc` (if present) is mounted with `$PWD` and read by container npm. Public registry only — no private-package env passthrough needed.
- **Preflight**: script checks docker CLI + daemon, then verifies `$PWD` is visible to the daemon by testing a known file (`package.json`, `.nvmrc`, etc.) inside a scratch run. Fail loud instead of writing into an empty bind-mount.

## Gotchas

- Never use `-it`: agents have no TTY; `-it` hangs. The script uses `-i` only.
- `npx` prompts "Ok to proceed?": always pass `--yes`.
- Bind-mount broken = empty dir: the sentinel check catches it before any command runs.
