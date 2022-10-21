FROM node:16.18.0-alpine3.15

WORKDIR /opt/app-root

COPY package.json ./

RUN npm install

COPY . .

CMD [ "npm", "start" ]