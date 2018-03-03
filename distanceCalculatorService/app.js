const express = require('express');

const app = express();

// fast lat/lon distance calculation
// from https://stackoverflow.com/a/21623206
function distance(lat1given, lon1given, lat2given, lon2given) {
  const deg2rad = 0.017453292519943295; // === Math.PI / 180

  const lat1 = lat1given * deg2rad;
  const lon1 = lon1given * deg2rad;
  const lat2 = lat2given * deg2rad;
  const lon2 = lon2given * deg2rad;

  const diam = 12742; // Diameter of the earth in km (2 * 6371)
  const dLat = lat2 - lat1;
  const dLon = lon2 - lon1;
  const a = (
    (1 - Math.cos(dLat)) +
    ((1 - Math.cos(dLon)) * (Math.cos(lat1) * Math.cos(lat2)))
  ) / 2;

  return diam * Math.asin(Math.sqrt(a));
}

app.get('/', (req, res) => {
  const lat1 = (+req.query.lat1);
  const lon1 = (+req.query.lon1);
  const lat2 = (+req.query.lat2);
  const lon2 = (+req.query.lon2);

  // cast number to string as it will be seen as a HTTP code otherwise
  res.send(`${distance(lat1, lon1, lat2, lon2)}`);
});

app.listen(3002, () => console.log('Listening on port 3002'));
