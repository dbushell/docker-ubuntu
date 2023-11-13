FROM ubuntu:22.04 as ubuntu-base

ARG TARGETARCH

ARG NODE_TAG
ENV NODE_TAG ${NODE_TAG:-21.x}
ARG DENO_TAG
ENV DENO_TAG ${DENO_TAG:-v1.38.1}

ARG USER
ENV USER ${USER:-user}
ARG PUID
ENV PUID ${PUID:-1000}
ARG PGID
ENV PGID ${PGID:-1000}
ENV HOME /home/${USER}
ARG LANG
ENV LANG ${LANG:-en_GB}
ARG TZ
ENV TZ ${TZ:-Europe/London}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Update system and install packages
RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    ca-certificates dnsutils iproute2 iputils-ping locales lsb-release net-tools sudo tzdata \
    curl git gnupg htop screen unzip vim wget zsh
    # exiftool ffmpeg sqlite3

# Configure timezone and localisation
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && echo $LANG.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen $LANG.UTF-8 \
  && update-locale LANG=$LANG.UTF-8

# Setup user and home directory
RUN useradd -u ${PUID} -U -d ${HOME} -s /bin/zsh ${USER} \
  && groupmod -o -g ${PUID} ${USER} \
  && usermod -o -u ${PGID} ${USER} \
  && usermod -aG sudo ${USER} \
  && echo ${USER}:${USER} | chpasswd \
  && echo root:root | chpasswd \
  && mkdir -p ${HOME} $HOME/.vim/backup -p $HOME/.vim/swap -p $HOME/.vim/undo

COPY home/ ${HOME}/
RUN chown -R ${PUID}:${PGID} $HOME

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Install NPM and Node
FROM ubuntu-base as ubuntu-node

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_TAG} nodistro main" \
    | tee /etc/apt/sources.list.d/nodesource.list \
  && apt update \
  && apt install -y nodejs \
  && npm install -g npm \
  && chown -R ${PUID}:${PGID} $HOME/.npm

# Install Deno
FROM ubuntu-node as ubuntu-deno

RUN if [ "$TARGETARCH" = "arm64" ]; then \
    wget -c -O deno.zip "https://github.com/LukeChannings/deno-arm64/releases/download/${DENO_TAG}/deno-linux-arm64.zip"; \
  else \
    wget -c -O deno.zip "https://github.com/denoland/deno/releases/download/${DENO_TAG}/deno-x86_64-unknown-linux-gnu.zip"; \
  fi \
  && unzip -o deno.zip \
  && rm -f deno.zip \
  && mv deno /usr/local/bin

# Install Bun
FROM ubuntu-deno as ubuntu-bun

# Ready default user
WORKDIR ${HOME}
USER ${USER}

RUN curl -fsSL https://bun.sh/install | bash

FROM ubuntu-bun as ubuntu

# Keep container alive
CMD tail -f /dev/null
