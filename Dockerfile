FROM alpine

LABEL maintainer="Marek Dwulit <marek.dwulit@gmail.com>"

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/agilebeat/k8s-kubectl" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV KUBE_LATEST_VERSION="v1.31.4"

RUN apk update && apk upgrade \
 && apk add --update ca-certificates \
 && apk add -t deps \
 && apk add --update curl \
 && export ARCH="$(uname -m)" && if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; elif [[ ${ARCH} == "aarch64" ]]; then export ARCH="arm64"; fi && curl -L https://dl.k8s.io/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

WORKDIR /root
ENTRYPOINT ["kubectl"]
CMD ["help"]
