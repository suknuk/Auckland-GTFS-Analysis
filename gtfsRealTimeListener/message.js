const http = require('http');
const db = require('./db');

// map that holds all marker information
let positions = {};

function makeDistanceCalculatorQuert(lat1, lon1, lat2, lon2) {
  const query = 'http://distance_calculator_service:3002';

  return query;
}

module.exports = {
  processGTFS: ((msg) => {
    try {
      // vehicle id
      const { id } = msg.entity[0].vehicle.vehicle;
      // position with: pos.latitude, pos.longitude and sometimes bearing
      const { pos } = msg.entity[0].vehicle;

      const { timestamp } = msg.entity[0].vehicle;

      // Does msg has position data?
      if (pos !== undefined) {

        // Does entry exist? If not, create new entry
        if (positions[id] === undefined) {
          positions[id] = pos;
          positions[id].timestamp = timestamp;
        }
        // else call distance calculator
        else {
          http.get()
        }

      }



    } catch (e) {
      // console.log(e)
    }
  }),
};
