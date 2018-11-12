FROM alpine

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

RUN apk add --no-cache ca-certificates bash git \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

WORKDIR /config

RUN apk add --no-cache ca-certificates openssl && \
    cd /tmp && \
    wget -O docker-base.zip https://releases.hashicorp.com/docker-base/${DOCKER_BASE_VERSION}/docker-base_${DOCKER_BASE_VERSION}_linux_amd64.zip && \
    echo "${DOCKER_BASE_SHA256SUM}  docker-base.zip" | sha256sum -c && \
    unzip -d / docker-base.zip && \
    rm docker-base.zip

ENV PORT 22
ENV RECONNECT_OPTIONS reconnect,ServerAliveInterval=15,ServerAliveCountMax=20480
ENV MOUNT_OPTIONS allow_other,StrictHostKeyChecking=no
ENV MOUNTPOINT /mnt/sshfs-1

RUN apk update && apk add sshfs && rm -rf /var/cache/apk/*
RUN rm /sbin/halt /sbin/poweroff /sbin/reboot

ADD entry.sh /usr/local/bin/entry.sh
RUN chmod 755 /usr/local/bin/entry.sh

HEALTHCHECK --interval=5s --timeout=5s \
    CMD mountpoint -q $MOUNTPOINT || exit 1

ENTRYPOINT ["/usr/local/bin/entry.sh"]
RUN 

CMD bash