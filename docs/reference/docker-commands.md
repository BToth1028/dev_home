# Docker & Docker Compose Reference

Quick reference for Docker commands.

---

## Docker Basics

```bash
# Pull image
docker pull postgres:16

# List images
docker images

# Remove image
docker rmi <image-id>

# Run container
docker run -d --name myapp -p 3000:3000 myimage

# List running containers
docker ps
docker ps -a  # Include stopped

# Stop container
docker stop <container-id>

# Start container
docker start <container-id>

# Remove container
docker rm <container-id>
docker rm -f <container-id>  # Force remove

# View logs
docker logs <container-id>
docker logs -f <container-id>  # Follow

# Execute command in container
docker exec -it <container-id> bash
docker exec -it <container-id> sh
```

---

## Docker Compose

```bash
# Start services
docker compose up
docker compose up -d  # Detached (background)
docker compose up --build  # Rebuild images

# Stop services
docker compose stop

# Stop and remove
docker compose down
docker compose down -v  # Remove volumes too

# View logs
docker compose logs
docker compose logs -f  # Follow
docker compose logs <service-name>

# List services
docker compose ps

# Execute command
docker compose exec <service-name> bash

# Rebuild specific service
docker compose build <service-name>

# Restart service
docker compose restart <service-name>
```

---

## Building Images

```bash
# Build from Dockerfile
docker build -t myapp:latest .
docker build -t myapp:v1.0.0 -f Dockerfile.prod .

# Build with compose
docker compose build
docker compose build --no-cache
```

---

## Cleanup

```bash
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune
docker image prune -a  # Remove all unused

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused
docker system prune
docker system prune -a --volumes  # Nuclear option
```

---

## Volumes

```bash
# List volumes
docker volume ls

# Create volume
docker volume create mydata

# Inspect volume
docker volume inspect mydata

# Remove volume
docker volume rm mydata
```

---

## Networks

```bash
# List networks
docker network ls

# Create network
docker network create mynetwork

# Inspect network
docker network inspect mynetwork

# Connect container to network
docker network connect mynetwork <container-id>
```

---

## Troubleshooting

```bash
# Check if Docker is running
docker version
docker info

# View resource usage
docker stats

# Inspect container
docker inspect <container-id>

# View container processes
docker top <container-id>

# Get container IP
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-id>
```

---

## Common Patterns

### PostgreSQL
```bash
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16
```

### Redis
```bash
docker run -d \
  --name redis \
  -p 6379:6379 \
  redis:7
```

### Access DB from Host
```bash
# PostgreSQL
docker exec -it postgres psql -U postgres

# Redis
docker exec -it redis redis-cli
```

---

## Docker Compose Health Checks

```yaml
services:
  db:
    image: postgres:16
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  app:
    depends_on:
      db:
        condition: service_healthy
```

---

## Environment Variables

```bash
# From .env file
docker compose --env-file .env.prod up

# In compose.yml
services:
  app:
    env_file: .env
    environment:
      - APP_PORT=3000
```

---

## Useful Tips

**Rebuild everything:**
```bash
docker compose down -v && docker compose up --build
```

**View all container IPs:**
```bash
docker ps -q | xargs -n 1 docker inspect --format '{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

**Clean slate:**
```bash
docker compose down -v
docker system prune -a --volumes
docker compose up --build
```


