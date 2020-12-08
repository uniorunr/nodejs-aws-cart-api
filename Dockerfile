FROM node:12-alpine as build

WORKDIR /build
COPY package*.json ./
RUN npm ci && npm cache clean --force

COPY . .
RUN npm run prebuild && npm run build
RUN npm prune --production

FROM node:12-alpine
WORKDIR /build

COPY package*.json ./
COPY --from=build /build/node_modules ./node_modules
COPY --from=build /build/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD [ "npm", "run", "start:prod" ] 