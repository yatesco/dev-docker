# hadolint global ignore=DL3059 # multiple RUN commands make things easier to debug
# hadolint global ignore=DL3008 # yes, ok, we should lock them...but not yet
FROM debian:stable-slim

# install mise (from https://mise.jdx.dev/mise-cookbook/docker.html)
RUN apt-get update  \
    && apt-get -y --no-install-recommends install  \
    # install any other dependencies you might need
    sudo curl git ca-certificates build-essential \
    # NOTE: because this is used as a base docker for CI, it must also satisfy those assumptions, specifically that certain tools are available.
    # These *should not and will not* be used for application development, only to provide a CI environment.
    && apt-get -y --no-install-recommends install nodejs npm \
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

# DO NOT remove mise.toml as the base CI environment requires it, even if actual CI _steps_ override this
# RUN rm mise.toml

ENV PATH="/root/.cargo/bin:$PATH"
