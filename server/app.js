const express = require('express');
require('dotenv').config({
    path: process.env.NODE_ENV ? '../.env' : '../.env.dev',
})

const app = express();

app.use(express.json());

app.get('/status', (req, res) => {
    res.json({
        status: 'Running',
        timestamp: new Date().toISOString()
    });
});

const PORT = process.env.SERVER_PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
