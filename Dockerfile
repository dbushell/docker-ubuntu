FROM ubuntu:22.04 as ubuntu-base

ARG TARGETARCH

ARG DENO_TAG
ENV DENO_TAG ${DENO_TAG:-v1.33.4}

ARG USER
ENV USER ${USER:-user}
ARG PUID
ENV PUID ${PUID:-1000}
ARG PGID
ENV PGID ${PGID:-1000}
ENV HOME /home/${USER}
ARG TZ
ENV TZ ${TZ:-Europe/London}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

# Update system and install packages
RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    dnsutils iproute2 iputils-ping locales lsb-release net-tools sudo tzdata \
    curl htop screen unzip vim wget zsh \
    exiftool ffmpeg git sqlite3

# Configure localisation
RUN locale-gen en_GB.UTF-8 \
  && update-locale LANG=en_GB.UTF-8

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

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

FROM ubuntu-base as ubuntu-node

# Install NPM and Node
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash
RUN apt update \
  && apt upgrade -y \
  && apt install -y nodejs

# Update NPM
RUN npm install -g npm

RUN chown -R ${PUID}:${PGID} $HOME/.npm

FROM ubuntu-node as ubuntu-deno

# Install Deno
RUN if [ "$TARGETARCH" = "arm64" ]; then \
    wget -c -O deno.zip "https://github.com/LukeChannings/deno-arm64/releases/download/${DENO_TAG}/deno-linux-arm64.zip"; \
  else \
    wget -c -O deno.zip "https://github.com/denoland/deno/releases/download/${DENO_TAG}/deno-x86_64-unknown-linux-gnu.zip"; \
  fi \
  && unzip -o deno.zip \
  && rm -f deno.zip \
  && mv deno /usr/local/bin

FROM ubuntu-deno as ubuntu-bun

# Ready default user
WORKDIR ${HOME}
USER ${USER}

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Keep container alive
CMD tail -f /dev/null
