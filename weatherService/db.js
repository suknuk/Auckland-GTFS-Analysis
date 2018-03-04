const { Pool } = require('pg');

// DB Connect String
const config = {
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT,
};
const pool = new Pool(config);

module.exports = {
  query: (text, params, callback) => {
    return pool.query(text, params, callback);
  },
};
