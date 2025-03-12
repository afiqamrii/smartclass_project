/**
 * This module sets up a MySQL connection pool using mysql2/promise and dotenv.
 * The pool is configured using environment variables for sensitive information.
 * 
 * Environment Variables:
 * - DB_USER: The user to authenticate as.
 * - DB_PASSWORD: The password of that MySQL user.
 * - DB_HOST: The host where the database server is running.
 * - DB_PORT: The port on which the database server is listening.
 * - DB_DATABASE: The name of the database to use.
 * 
 * Exports:
 * - pool: A MySQL connection pool instance.
 */

const mysql = require("mysql2/promise");
require("dotenv").config();

const pool = mysql.createPool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_DATABASE,
});

module.exports = pool;
