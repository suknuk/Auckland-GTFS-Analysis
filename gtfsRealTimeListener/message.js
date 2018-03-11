const http = require('http');
const db = require('./db');

// map that holds all marker information
const positions = {};

// Function to create the HTTP get request query to the distance calculator service
function makeDistanceCalculatorQuery(lat1, lon1, lat2, lon2) {
  let query = 'http://distance_calculator_service:3002/';
  query += `?lat1=${lat1}&lon1=${lon1}&lat2=${lat2}&lon2=${lon2}`;
  return query;
}

function makeDistanceQueryCall(lat1, lon1, lat2, lon2, callback) {
  const distanceQuery = makeDistanceCalculatorQuery(lat1, lon1, lat2, lon2);
  http.get(distanceQuery, (res) => {
    res.setEncoding('utf8');
    let body = '';
    res.on('data', (data) => {
      body += data;
    });
    res.on('end', () => {
      body = JSON.parse(body);
      callback(body);
    });
  });
}

module.exports = {
  processGTFS(msg) {
    try {
      // vehicle id
      const { id } = msg.entity[0].vehicle.vehicle;
      // position with: pos.latitude, pos.longitude and sometimes bearing
      const { position } = msg.entity[0].vehicle;
      const { timestamp } = msg.entity[0].vehicle;

      // Does msg has position data?
      if (position !== undefined) {
        // Does entry exist? If not, create new entry
        if (positions[id] === undefined) {
          positions[id] = position;
          positions[id].timestamp = timestamp;
          // console.log(`got vehicle id ${id}`);
        // else call distance calculator
        } else {
          // console.log('got occuring id');
          makeDistanceQueryCall(positions[id].latitude, positions[id].longitude, position.latitude, position.longitude, (distance) => {
            // console.log(distance);

            const timeDiff = timestamp - positions[id].timestamp;
            let kmh = (distance / timeDiff) * 3.6;
            // handling special cases of kmh
            if (kmh < 0) {
              kmh -= kmh;
            } else if (Number.isNaN(kmh)) {
              kmh = 0;
            } else if (!Number.isFinite(kmh)) {
              return;
            }

            // here insertion of point into the db

            // console.log(`vehicle update. kmh: ${kmh} ,traveling ${distance} meters in ${timeDiff} seconds.`);

            positions[id] = position;
            positions[id].timestamp = timestamp;
          });
        }
      }
    } catch (e) {
      // console.log(`error: ${e}`);
    }
  },
};
