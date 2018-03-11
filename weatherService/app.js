const http = require('http');
const db = require('./db');

const openweathermapURL = `http://api.openweathermap.org/data/2.5/find?lat=-36.87&lon=174.77&cnt=50&APPID=${process.env.OPENWEATHERMAP_API}`;
const weatherDataCollectInterval = 5 * 60 * 1000; // 5 minutes

let weatherStationArray = [];

function collectWeatherData(url, callback) {
  http.get(url, (res) => {
    res.setEncoding('utf8');
    let body = '';
    res.on('data', (data) => {
      body += data;
      console.log(`got some data! : ${data}`);
    });
    res.on('end', () => {
      body = JSON.parse(body);
      callback(body);
    });
  });
}

function insertWeatherStation(body, callback) {
  const queryString = `
    INSERT INTO weather_station(id,name,lat,lon)
    VALUES($1,$2,$3,$4);`;
  const values = [body.id, body.name, body.coord.lat, body.coord.lon];

  db.query(queryString, values)
    .then((res) => {
      // console.log(`insert weather_station worked: ${res}`);
      callback(null, res);
    })
    .catch((e) => {
      // console.error(e.stack);
      callback(e);
    });
}

function insertWeatherData(bodyValues) {
  const queryString = `
    INSERT INTO
    weather_data(timestamp, weather_station_id, temp, pressure, humidity,
      wind_speed, wind_deg, clouds, rain, snow, weather_condition_id)
    VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11);`;

  // Casting object to new body object and applying 'null' checks
  const body = {
    dt: bodyValues.dt,
    id: bodyValues.id,
    main: {
      temp: bodyValues.main.temp,
      pressure: bodyValues.main.pressure,
      humidity: bodyValues.main.humidity,
    },
    wind: {
      speed: bodyValues.wind.speed,
      deg: bodyValues.wind.deg,
    },
    clouds: {
      all: bodyValues.clouds.all,
    },
    rain: {
      '3h': (bodyValues.rain == null ? 0 : bodyValues.rain['3h']),
    },
    snow: {
      '3h': (bodyValues.snow == null ? 0 : bodyValues.snow['3h']),
    },
    weather: {
      id: bodyValues.weather[0].id,
    },
  };

  const values = [body.dt, body.id, body.main.temp, body.main.pressure,
    body.main.humidity, body.wind.speed, body.wind.deg, body.clouds.all,
    body.rain['3h'], body.snow['3h'], body.weather.id];

  db.query(queryString, values)
  /* eslint-disable no-console */
    .then((res) => {
      console.log(`insert weather_data worked: ${res}`);
    })
    .catch((e) => {
      console.error(e.stack);
    });
  /* eslint-enable no-console */
}

// execute a first weather station insert followed by weather data
function firstInsert(body) {
  insertWeatherStation(body, () => {
    insertWeatherData(body);
  });
}

// Check every every n minutes for new weather data
function checkNewWeatherData() {
  setTimeout(() => {
    console.log('started checking for new data already!');
    collectWeatherData(openweathermapURL, (res) => {
      // check timestamp for new data
      if (res.list[0].dt !== weatherStationArray[0].dt) {
        weatherStationArray = res.list;
        for (let i = 0; i < weatherStationArray.length; i += 1) {
          insertWeatherData(weatherStationArray[i]);
        }
      }
    });
    checkNewWeatherData();
  }, weatherDataCollectInterval);
}


function startWeatherService() {
  collectWeatherData(openweathermapURL, (res) => {
    weatherStationArray = res.list;
    // insert weather_station data
    for (let i = 0; i < weatherStationArray.length; i += 1) {
      firstInsert(weatherStationArray[i]);
    }
    // Start the interval loop
    checkNewWeatherData();
  });
}

// Wait 5 seconds to let db start
setTimeout(startWeatherService, 5000);
