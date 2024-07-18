ARG NODE_VERSION=20.15.1
ARG PNPM_VERSION=9.5.0

FROM node:${NODE_VERSION}-alpine as base

WORKDIR /usr/app
COPY . .
USER ${UID:-0}:${GID:-0}
RUN npm install -g pnpm@${PNPM_VERSION}

FROM base as dev
# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.local/share/pnpm/store to speed up subsequent builds.
# Leverage a bind mounts to package.json and pnpm-lock.yaml to avoid having to copy them into
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
  --mount=type=bind,source=pnpm-lock.yaml,target=pnpm-lock.yaml \
  --mount=type=cache,target=/pnpm/store \
  pnpm install

EXPOSE 5173
CMD pnpm dev --host

FROM base as production
# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.local/share/pnpm/store to speed up subsequent builds.
# Leverage a bind mounts to package.json and pnpm-lock.yaml to avoid having to copy them into
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
  --mount=type=bind,source=pnpm-lock.yaml,target=pnpm-lock.yaml \
  --mount=type=cache,target=/root/.local/share/pnpm/store \
  pnpm install --frozen-lockfile

ENV NODE_ENV production
RUN pnpm build
EXPOSE 4173
CMD pnpm preview --host
