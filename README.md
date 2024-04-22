# miyoshi-backend

Requirements:

- [Docker Desktop for windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- [Docker Desktop for mac](https://docs.docker.com/desktop/install/mac-install)

First, run for bootstrap:

```bash
bash provision.sh
```

run for clean:

```bash
bash clean.sh
```

for container up:

```bash
docker-compose up -d
```

for enter into backend container:

```bash
docker exec -it miyoshi_backend bash
```

for parking summarize:

```bash
bin/rails c
ParkingSummarizeJob.perform_now
```

for container stop:

```bash
docker-compose stop
```

VSCode setting:

Recommended extension:
- Ruby
- VSCode Ruby
- Remote - Containers
- Ruby Solargraph
- Ruby on Rails
- Rails
- Rails DB Schema

Solargraph setting: add the following into settings.json of VS Code
```bash
"solargraph.useBundler": true,
"solargraph.transport": "external",
"solargraph.logLevel": "debug",
"solargraph.hover": true,
"solargraph.diagnostics": true,
"solargraph.externalServer": {
    "host": "localhost",
    "port": 7658
}
```

Local environment URLs:
* Backend application server : http://localhost:8000
* Solargraph                 : http://localhost:7658

Docker containers:
* backend: Backend application server
* tools: Solargraph
* scheduler: Scheduler application server
* db: MSSQL
