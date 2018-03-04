// console.log(process.env.openweathermap_api);

// Update weather data every 5 minutes
// provide

const http = require('http');
const db = require('./db');

const openweathermapURL = `http://api.openweathermap.org/data/2.5/find?lat=-36.87&lon=174.77&cnt=5&APPID=${process.env.OPENWEATHERMAP_API}`;
const weatherDataCollectInterval = 5 * 60 * 1000; // 5 minutes

/* global weatherStationNumber */
let weatherStationNumber = 0;
let weatherStationArray = [];

function collectWeatherData(url) {
  http.get(url, (res) => {
    res.setEncoding('utf8');
    let body = '';
    res.on('data', (data) => {
      body += data;
      console.log(`got some data! : ${data}`);
    });
    res.on('end', () => {
      body = JSON.parse(body);
      return body;
    });
  });
}

function getStations() {
  // const body = collectWeatherData(openweathermapURL);
  // weatherStationNumber = body.count;
}

getStations();

console.log(process.env.OPENWEATHERMAP_API);
console.log(process.env.TEST_ENV_VAL);
