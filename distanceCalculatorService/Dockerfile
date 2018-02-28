FROM node:carbon

WORKDIR /usr/distance_calculator_service

COPY package.json .
RUN npm install --quiet

COPY . .