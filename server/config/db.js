import pg from 'pg';
const { Pool } = pg;

import path from 'path';
import { fileURLToPath } from 'url';

// Get the current file directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load the .env file from parent directory
import dotenv from 'dotenv';
dotenv.config({ path: path.join(__dirname, '../../.env.dev') });

console.log("host: ", process.env.DB_HOST);

export const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: Number(process.env.DB_PORT)
});

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

// pool.connect((err, connection) => {
//     if (err) throw err;
//     console.log('Database is connected successfully!');
//     connection.release();
// });