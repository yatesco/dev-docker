FROM alpine:3

WORKDIR /app
ENV PATH="/root/.local/bin:${PATH}"

# Copy tool definitions first so this layer is cached until versions change.
COPY mise.toml ./

# Install mise, trust config, install tools, then remove build-only packages.
RUN set -eux; \
    apk add --no-cache bash ca-certificates curl git libgcc xz; \
    curl -fsSL https://mise.run | sh; \
    mise trust --yes /app/mise.toml; \
    mise install; \
    apk del --no-network curl git xz
