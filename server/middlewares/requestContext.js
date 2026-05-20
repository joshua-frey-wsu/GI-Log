import crypto from 'node:crypto';

/**
 * Attaches a unique request ID and captures context.
 * Enters early in the middleware chain
 */
export const requestContext = (req, res, next) => {
    // Generate or use existing request ID
    req.requestId = req.headers['x-request-id'] || crypto.randomUUID();

    // Add request ID to response headers
    res.set('X-Request-ID', req.requestId);

    // Store start time for duration calculation
    req.startTime = Date.now();

    next();
};