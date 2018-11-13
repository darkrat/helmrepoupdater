FROM alpine

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-repo-updater" \
      org.label-schema.url="https://hub.docker.com/r/icevirm1/helm-repo-updater/" \
      org.label-schema.vcs-url="https://github.com/darkrat/helmrepoupdater" \
      org.label-schema.build-date=$BUILD_DATE

RUN apk update && apk add sshfs util-linux
RUN modprobe fuse && echo fuse | sudo tee -a /etc/modules

