FROM ubuntu:20.04 as ubuntu-base

ENV DEBIAN_FRONTEND=noninteractive

ARG USER
ENV USER ${USER:-user}
ARG PUID
ENV PUID ${PUID:-1000}
ARG PGID
ENV PGID ${PGID:-1000}
ENV HOME /home/${USER}
ARG TZ
ENV TZ ${TZ:-Europe/London}

WORKDIR /root

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

# Update system and install packages
RUN apt update \
  && apt upgrade -y \
  && apt install -y curl dnsutils git htop iproute2 iputils-ping locales lsb-release net-tools sudo screen tzdata vim wget zsh

# Configure localisation
RUN locale-gen en_GB.UTF-8 \
  && update-locale LANG=en_GB.UTF-8

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

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

FROM ubuntu-base as ubuntu-deno

ARG DENO_TAG
ENV DENO_TAG ${DENO_TAG:-v1.17.1}

# Install build tools
RUN apt update \
  && apt upgrade -y \
  && apt install -y build-essential

WORKDIR ${HOME}
USER ${USER}

# Install Rust
ENV PATH "${HOME}/.cargo/bin:$PATH"
RUN curl https://sh.rustup.rs -o rustup.sh \
  && chmod +x rustup.sh \
  && ./rustup.sh -y

# Download and build Deno
RUN git clone https://github.com/denoland/deno.git -b ${DENO_TAG}
WORKDIR ${HOME}/deno
RUN cargo build --release --bin deno

FROM ubuntu-node

COPY --from=ubuntu-deno ${HOME}/deno/target/release/deno /usr/local/bin

# Ready default user
WORKDIR ${HOME}
USER ${USER}

# Update NPM
RUN npm install -g npm

# Keep container alive
CMD tail -f /dev/null
