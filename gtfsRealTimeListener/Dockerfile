FROM node:carbon

WORKDIR /usr/gtfs_realtime_listener

COPY package.json .
RUN npm install --quiet

COPY . .