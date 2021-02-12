LABEL org.opencontainers.image.source https://github.com/dbushell/ubuntu

FROM ubuntu:20.04

ARG USER
ENV USER ${USER:-user}
ARG PUID
ENV PUID ${PUID:-1000}
ARG PGID
ENV PGID ${PGID:-1000}
ARG TZ
ENV TZ ${TZ:-Europe/London}

WORKDIR /root

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

# Update system and install packages
RUN apt update
RUN apt upgrade -y
RUN apt install -y tzdata locales sudo zsh htop vim git curl

# Configure localisation
RUN locale-gen en_GB.UTF-8
RUN update-locale LANG=en_GB.UTF-8

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

# Install NPM and Node
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash
RUN apt install -y nodejs

# Setup default user in sudo group
ENV HOME /home/${USER}
RUN useradd -u ${PUID} -U -d ${HOME} -s /bin/zsh ${USER}
RUN groupmod -o -g ${PUID} ${USER}
RUN usermod -o -u ${PGID} ${USER}
RUN usermod -aG sudo ${USER}

# Set root and user passwords
RUN echo ${USER}:${USER} | chpasswd
RUN echo root:root | chpasswd

# Copy home directory config files
RUN mkdir -p ${HOME} $HOME/.vim/backup -p $HOME/.vim/swap -p $HOME/.vim/undo
COPY home/ ${HOME}/
RUN chown -R ${PUID}:${PGID} $HOME

# Ready default user
WORKDIR ${HOME}
USER ${USER}

# Keep container alive
CMD tail -f /dev/null
