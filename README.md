# Manus AI Agent

This repository contains a simple Docker Compose setup for the Manus AI project (frontend, backend, sandbox, MongoDB, Redis).

This README documents how to configure the Deepseek API key (if you want to use Deepseek as the search provider), secure environment usage, and how to run and verify the services.

## What this repo contains

- `docker-compose.yml` — Compose file for all services (frontend, backend, sandbox, mongodb, redis).
- `.env` — Local environment file (should contain secrets like DEEPSEEK_API_KEY). This file is ignored by Git.
- `.env.example` — Example values for env variables (do not store real secrets here).

## Deepseek API key configuration

The backend service loads environment variables from `.env` (see `env_file: - .env` in `docker-compose.yml`). To enable Deepseek as the search provider, set the following:

1. Open (or create) `.env` in the repo root and add or update the Deepseek key:

```env
DEEPSEEK_API_KEY=sk_live_your_real_key_here
```

2. Enable Deepseek as the search provider by either setting the var in `.env` or editing `docker-compose.yml` to change the default `SEARCH_PROVIDER` value for the backend service:

```env
SEARCH_PROVIDER=deepseek
```

or edit `docker-compose.yml` under the `backend` service environment list and set:

- `SEARCH_PROVIDER=deepseek`

Note: your repository already contains a `.env` file. Replace its placeholder value with your real key. Keep `.env` private and do not commit it.

## Security notes

- `.env` is included in `.gitignore` by default in this repo. Do not commit `.env`.
- For production, prefer Docker Secrets or a proper secret manager rather than plaintext `.env` files.
  - If you'd like, I can convert `docker-compose.yml` to use `secrets:` with `docker secret` instructions.

## Running the project locally

From the repo root, run:

```bash
docker compose up -d
```

This starts the frontend (port 5173 -> 80), backend, sandbox, mongodb, and redis services.

## Verify the Deepseek API key is available in the backend

To verify the backend service receives the `DEEPSEEK_API_KEY` value from `.env`:

```bash
# Show the environment variable inside the running backend container
docker compose exec backend sh -c 'env | grep DEEPSEEK_API_KEY || echo "DEEPSEEK_API_KEY not set inside service"'
```

If the variable prints, the service has access to the key. If you see the `not set` message, ensure `.env` is present in the project root and contains `DEEPSEEK_API_KEY=...`.

## Example `.env.example`

A safe example file to commit is provided as `.env.example`:

```env
# Example .env file showing required variables (do not store real secrets here)
DEEPSEEK_API_KEY=replace_with_real_key
```

## Troubleshooting

- If the backend doesn't pick up env vars, check that `docker compose` is run from the repo root where `docker-compose.yml` and `.env` live.
- After changing `.env`, recreate the backend container:

```bash
docker compose up -d backend
# or
docker compose restart backend
```

- For production-grade deployments, consider using Docker secrets, HashiCorp Vault, AWS Secrets Manager, or similar.

## Next steps (optional)

- Convert `.env` usage to Docker secrets for production safety.
- Add a runtime check in the backend to fail fast if a required key (like `DEEPSEEK_API_KEY` when `SEARCH_PROVIDER=deepseek`) is missing.
- Add a short health-check script to confirm the backend can reach Deepseek when configured.

---

If you'd like, I can convert this repo to use secrets, add the fail-fast check in the backend, or securely insert your key into `.env` for you (paste it privately).