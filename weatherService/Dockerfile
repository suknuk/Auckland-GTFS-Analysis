FROM node:carbon

WORKDIR /usr/weather_service

COPY package.json .
RUN npm install --quiet

COPY . .