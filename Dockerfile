FROM node:16-alpine

ARG LIGHTHOUSE_VERSION=8.2.0

# Installs latest Chromium package.
RUN  echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories \
    && apk upgrade -U -a \
    && apk add --no-cache \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    bash \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk


RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

#https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json
COPY chrome.json /usr/src/chrome.json

RUN export CHROME_PATH=/usr/lib/chromium/

RUN yarn global add lighthouse@$LIGHTHOUSE_VERSION

COPY audit.sh /usr/local/bin/audit
RUN chmod +x /usr/local/bin/audit

ENTRYPOINT ["audit"]
