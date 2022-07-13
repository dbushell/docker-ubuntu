# 🐳 Ubuntu Docker Sandbox

A configured Ubuntu sandbox container with Zsh and Starship shell prompt. Also with Vim, Git, Deno, and Node.

[Why does this exists?](https://dbushell.com/2021/02/22/macos-big-reinstall-docker-traefik-localhost/)

## Usage

```sh
docker pull ghcr.io/dbushell/ubuntu
```

Docker CLI:

```sh
docker run -d \
  --name=sandbox \
  ghcr.io/dbushell/ubuntu \
  && docker exec -it sandbox zsh
```

Docker Compose:

```yml
services:
  ubuntu:
    container_name: sandbox
    image: ghcr.io/dbushell/ubuntu
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

* * *

[MIT License](/LICENSE) | Copyright © 2021 [David Bushell](https://dbushell.com) | [@dbushell](https://twitter.com/dbushell)
