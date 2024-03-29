# 🐳 Ubuntu Docker Sandbox

A configured Ubuntu sandbox container with Zsh and Starship shell prompt. Also with Vim, Git, Deno, Bun, and Node.

[Why does this exists?](https://dbushell.com/2021/02/22/macos-big-reinstall-docker-traefik-localhost/)

## Usage

```sh
docker pull ghcr.io/dbushell/ubuntu
```

Docker CLI:

```sh
docker run -d \
  --name=ubuntu_sandbox \
  ghcr.io/dbushell/ubuntu \
  && docker exec -it ubuntu_sandbox zsh
```

Docker Compose:

```yml
services:
  ubuntu:
    container_name: ubuntu_sandbox
    image: ghcr.io/dbushell/ubuntu
```

```sh
docker compose up -d \
  && docker exec -it ubuntu_sandbox zsh
```

(Enter `exit` to escape the container.)

### Shell Access

```sh
docker exec -it ubuntu_sandbox zsh
```

### Clean Up

```sh
docker stop ubuntu_sandbox && docker rm ubuntu_sandbox
```

* * *

[MIT License](/LICENSE) | Copyright © 2024 [David Bushell](https://dbushell.com)
