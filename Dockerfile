# syntax=docker/dockerfile:1.3
# Etap 1: Budowanie aplikacji
FROM scratch AS builder
ADD alpine-minirootfs-3.19.1-x86_64.tar /
ARG VERSION
ARG AUTOR="Patryk Sowa"
ENV AUTOR = $AUTOR
RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs=20.12.1-r0 \
    npm=10.2.5-r0 \
    rm -rf /etc/apk/cache
COPY ./src /zadanie1/src



# RUN --mount=type=ssh,id=veximek git clone git@github.com:Veximek/Zadanie1.git zadanie1 

WORKDIR /zadanie1/src

RUN npm install



# syntax=docker/dockerfile:1.3
# Etap 2: Uruchomienie aplikacji w kontenerze
FROM node:alpine as prod

ARG VERSION

LABEL org.opencontainers.image.authors="Patryk Sowa"
LABEL org.opencontainers.image.version="$VERSION"

WORKDIR /app

COPY --from=builder /zadanie1/src .


ENV PORT=3000

EXPOSE ${PORT}
CMD ["node", "index.js"]
