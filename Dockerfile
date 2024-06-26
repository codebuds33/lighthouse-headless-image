FROM node:21.7.3-alpine3.19

ARG LIGHTHOUSE_VERSION=12.0.0

# Installs latest Chromium package.
RUN apk upgrade -U -a \
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
