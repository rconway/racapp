FROM node:alpine as builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY public ./public
COPY src ./src
RUN npm run build

# ---

FROM nginx:alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=builder /app/build .

COPY nginx/nginx.conf /etc/nginx
COPY nginx/default.conf /etc/nginx/conf.d

ENTRYPOINT ["nginx", "-g", "daemon off;"]
