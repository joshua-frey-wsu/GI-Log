import express from 'express';
import memberRoutes from './routes/member.routes.js';

const app = express();

// Middleware
app.use(express.json());

// Routes
app.use('/api/members', memberRoutes);

// Health check
app.get('/status', (req, res) => {
    res.json({
        status: 'Running',
        timestamp: new Date().toISOString()
    });
});

const PORT = process.env.SERVER_PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
