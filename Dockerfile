FROM node:22-alpine AS build

WORKDIR /myapp

COPY package*.json ./

RUN npm ci

COPY app.js ./

RUN npm test

#production stage
FROM node:22-alpine AS production

WORKDIR /myapp

ENV NODE_ENV=production

COPY --from=build /myapp/package*.json ./
COPY --from=build /myapp/app.js ./

EXPOSE 3000

CMD [ "npm", "start"]
