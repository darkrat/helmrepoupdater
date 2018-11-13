FROM dtzar/helm-kubectl

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-repo-updater" \
      org.label-schema.url="https://hub.docker.com/r/icevirm1/helm-repo-updater/" \
      org.label-schema.vcs-url="https://github.com/darkrat/helmrepoupdater" \
      org.label-schema.build-date=$BUILD_DATE

ENV KUBE_LATEST_VERSION="v1.11.3"
ENV HELM_VERSION="v2.11.0"
ENV DOCKER_BASE_VERSION=0.0.4
ENV DOCKER_BASE_SHA256SUM=5262aa8379782d42f58afbda5af884b323ff0b08a042e7915eb1648891a8da00

RUN apk add sshfs util-linux
    && modprobe fuse
    && echo fuse | sudo tee -a /etc/modules
