import express from 'express';
import memberRoutes from './routes/member.routes.js';
import { asyncHandler } from './middlewares/asyncHandler.js';
import { errorConverter } from './middlewares/errorConverter.js';
import { errorHandler } from './middlewares/errorHandler.js';
import { NotFoundError } from './helpers/ApiError.js';

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

// 404 Handler (Catch-all)
app.use((req, res, next) => {
    next(new NotFoundError(`Route ${req.originalUrl}`));
});

// Error handling middleware pipeline
app.use(errorConverter); // Convert library/db erros to ApiError first
app.use(errorHandler); // Format and send error response

const PORT = process.env.SERVER_PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
