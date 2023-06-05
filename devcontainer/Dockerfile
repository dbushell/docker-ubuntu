FROM mcr.microsoft.com/devcontainers/base:ubuntu

# ARG DENO_TAG
# ENV DENO_TAG ${DENO_TAG:-v1.34.1}

ENV VSCODE_USER vscode
ENV VSCODE_HOME /home/vscode

ENV TZ ${TZ:-Europe/London}

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and localisation
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

RUN locale-gen en_GB.UTF-8 \
  && update-locale LANG=en_GB.UTF-8

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    dnsutils iputils-ping \
    screen vim

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Setup home directory and dotfiles
COPY home/ ${VSCODE_HOME}/
RUN usermod --shell /usr/bin/zsh $VSCODE_USER \
  && mkdir -p \
  $VSCODE_HOME/.vim/backup \
  $VSCODE_HOME/.vim/swap \
  $VSCODE_HOME/.vim/undo \
  $VSCODE_HOME/.npm

# Install and update NPM and Node
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash
RUN apt update \
  && apt upgrade -y \
  && apt install -y nodejs

# Install Deno
# RUN if [ "$(uname -m)" = "aarch64" ]; then \
#     wget -c -O deno.zip "https://github.com/LukeChannings/deno-arm64/releases/download/${DENO_TAG}/deno-linux-arm64.zip"; \
#   else \
#     wget -c -O deno.zip "https://github.com/denoland/deno/releases/download/${DENO_TAG}/deno-x86_64-unknown-linux-gnu.zip"; \
#   fi \
#   && unzip -o deno.zip \
#   && rm -f deno.zip \
#   && mv deno /usr/local/bin

# Fix permissions
RUN chown -R $VSCODE_USER:$VSCODE_USER $VSCODE_HOME

USER ${VSCODE_USER}

# Install NPM packages
RUN npm install -g npm npm-check-updates

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
