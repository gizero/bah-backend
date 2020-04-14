# builder image
FROM node:12 AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --no-optional

COPY . .

RUN npm run build

FROM node:12 AS prod-builder

ENV NODE_ENV=production

WORKDIR /app

COPY package*.json ./

RUN npm i --no-optional &&\
    npm cache clean --force

# production image
FROM node:12-alpine

LABEL name="hbbtv-cs-restart"
LABEL description="HbbTV CS Restart"
LABEL maintainer="technology.scc@skytv.it"

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV NODE_ENV=production

WORKDIR /app

COPY package.json ./
COPY --from=builder /usr/src/app/build ./build/
COPY --from=prod-builder /app/node_modules ./node_modules/

EXPOSE 8080

CMD [ "node", "build/main.js" ]

# Metadata
LABEL org.opencontainers.image.vendor="ButtonsAgainstHumanity" \
        org.opencontainers.image.url="https://buttonsagainsthumanity.com/" \
        org.opencontainers.image.source="https://github.com/buttons-against-humanity/bah-backend" \
        org.opencontainers.image.title="bah-backend" \
        org.opencontainers.image.description="Buttons Against Humanity Backend" \
        org.opencontainers.image.version="0.2.2" \
        org.opencontainers.image.documentation="https://github.com/buttons-against-humanity/bah-backend" \
        org.opencontainers.image.licenses='Apache-2.0'
