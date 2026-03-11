# hadolint global ignore=DL3008 # yes, ok, we should lock them...but not yet
FROM debian:stable-slim@sha256:85dfcffff3c1e193877f143d05eaba8ae7f3f95cb0a32e0bc04a448077e1ac69 AS builder

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    bash \
    ca-certificates \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"

RUN curl https://mise.run | sh

WORKDIR /app

# Copy tool definitions first so this layer is cached until versions change.
COPY mise.toml ./
RUN mise trust --yes /app/mise.toml && mise install --verbose

# Drop installer caches before copying into runtime image.
RUN rm -rf /mise/cache /root/.cache

FROM debian:stable-slim@sha256:85dfcffff3c1e193877f143d05eaba8ae7f3f95cb0a32e0bc04a448077e1ac69

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    bash git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"

COPY --from=builder /usr/local/bin/mise /usr/local/bin/mise
COPY --from=builder /mise /mise
COPY --from=builder /root/.cargo /root/.cargo
COPY --from=builder /root/.rustup /root/.rustup

# DO NOT remove mise.toml as the base CI environment requires it, even if actual CI _steps_ override this
WORKDIR /app
COPY mise.toml ./
# Trust the local copy and also install it as the global config so that mise
# shims resolve the correct tool versions from any working directory (e.g. CI
# container jobs that checkout into a different path than /app).
RUN mise trust --yes /app/mise.toml \
    && cp /app/mise.toml /mise/config.toml \
    && mise trust --yes /mise/config.toml
