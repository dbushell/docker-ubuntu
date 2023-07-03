FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV VSCODE_USER vscode
ENV VSCODE_HOME /home/vscode

ENV LANG ${LANG:-en_GB}
ENV TZ ${TZ:-Europe/London}

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and localisation
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

RUN echo $LANG.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen $LANG.UTF-8 \
  && update-locale LANG=$LANG.UTF-8

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    dnsutils iputils-ping \
    screen vim

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Setup home directory and dotfiles
RUN usermod --shell /usr/bin/zsh $VSCODE_USER \
  && mkdir -p \
  $VSCODE_HOME/.config \
  $VSCODE_HOME/.vim/backup \
  $VSCODE_HOME/.vim/swap \
  $VSCODE_HOME/.vim/undo

COPY home/.config/ ${VSCODE_HOME}/.config/
COPY home/.vimrc ${VSCODE_HOME}/.vimrc
COPY home/.zshrc ${VSCODE_HOME}/.zshrc

# Fix permissions
RUN chown -R $VSCODE_USER:$VSCODE_USER $VSCODE_HOME

USER ${VSCODE_USER}
