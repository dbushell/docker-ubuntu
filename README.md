# 🐳 Ubuntu Docker Sandbox

A configured Ubuntu sandbox container with Zsh and Starship shell prompt. Also with Vim, Git, and Node.js.

```sh
docker pull ghcr.io/dbushell/ubuntu:latest
```

## Usage

Docker CLI:

```sh
docker run -d \
  --name=sandbox \
  ghcr.io/dbushell/ubuntu:latest \
  && docker exec -it sandbox zsh
```

Docker Compose:

```yml
version: '3'
services:
  ubuntu:
    container_name: sandbox
    image: ghcr.io/dbushell/ubuntu:latest
```

```sh
docker-compose up -d \
  && docker exec -it sandbox zsh
```

(Enter `exit` to escape the container.)

### Shell Access

```sh
docker exec -it sandbox zsh
```

or:

```sh
docker-compose exec sandbox zsh
```

### Clean Up

```sh
docker stop sandbox && docker rm sandbox
```
