FROM node:15-alpine

# Installs latest Chromium package.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
    && apk upgrade -U -a \
    && apk add --no-cache \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    wqy-zenhei \
    bash \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk


RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

#https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json
COPY chrome.json /usr/src/chrome.json

RUN export CHROME_PATH=/usr/lib/chromium/

RUN yarn global add lighthouse@6.4.1

COPY audit.sh /usr/local/bin/audit
RUN chmod +x /usr/local/bin/audit

ENTRYPOINT ["audit"]