# hadolint global ignore=DL3059 # multiple RUN commands make things easier to debug
FROM debian:stable-slim

# install mise (from https://mise.jdx.dev/mise-cookbook/docker.html)
# hadolint ignore=DL3008 # yes, ok, we should lock them...but not yet
RUN apt-get update  \
    && apt-get -y --no-install-recommends install  \
    # install any other dependencies you might need
    sudo curl git ca-certificates build-essential \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"
# ENV MISE_VERSION="..."

RUN curl https://mise.run | sh

WORKDIR /app

# Copy tool definitions first so this layer is cached until versions change.
COPY mise.toml ./
RUN mise trust --yes /app/mise.toml
RUN mise install --verbose

ENV PATH="/root/.cargo/bin:$PATH"
