FROM ubuntu:20.04

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
  && apt install -y tzdata locales sudo zsh htop vim git curl

# Configure localisation
RUN locale-gen en_GB.UTF-8 \
  && update-locale LANG=en_GB.UTF-8

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

# Install NPM and Node
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash
RUN apt install -y nodejs

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

# Ready default user
WORKDIR ${HOME}
USER ${USER}

RUN ["/bin/zsh", "-c", "npm install -g npm"]

# Keep container alive
CMD tail -f /dev/null
