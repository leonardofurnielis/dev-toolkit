FROM node:14.15.1-alpine AS builder

WORKDIR /usr

COPY package.json ./

RUN npm install

COPY . .

RUN npm -g config set user root
RUN npm install -g @angular/cli@7.3.9
RUN ng build --prod

FROM nginx:1.16.0-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /usr/dist /usr/share/nginx/html
COPY --from=builder /usr/src/static/Staticfile /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# COPY --from=builder /usr/src/static/nginx.config /etc/nginx/conf.d/

COPY . .

CMD ["nginx", "-g", "daemon off;"]
