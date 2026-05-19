import { ApiError } from "../helpers/ApiError";

/**
 * Formats error details for development responses.
 * Includes full stack trace and internal details
 */
const formatDevError = (err, req) => {
    return {
        success: false,
        error: {
            code: err.errorCode || 'INTERNAL_ERROR',
            message: err.message,
            stack: err.stack,
            path: req.originalUrl,
            method: req.method,
            timestamp: new Date().toISOString()
        }
    };
};

/**
 * Formats error details for production responses.
 * Hides internal details and stack traces.
 */
const formatProdError = (err, req) => {
    // Only expose details for operational errors
    if (err.isOperational) {
        const response = {
            success: false,
            error: {
                code: err.errorCode,
                message: err.message
            }
        };
        
        // Include validation errors if present
        if (err.errors) {
            response.error.details = err.errors;
        }

        // Include retry header for rate limit errors
        if (err.retryAfter) {
            response.error.retryAfter = err.retryAfter;
        }

        return response;
    }

    // Generic message for programming errors
    return {
        success: false,
        error: {
            code: 'INTERNAL_ERROR',
            message: 'Something went wrong'
        }
    };
};

/**
 * Central error handling middleware.
 */
export const errorHandler = (err, req, res, next) => {
    // Default to 500 if no status code is set
    err.statusCode = err.statusCode || 500;

    // Log all errors for debugging
    console.error(`[${new Date().toISOString()}] ${err.statusCode} - ${err.message}`);
    console.error(`Path: ${req.method} ${req.originalUrl}`);

    // Log stack trace for non-operational errors
    if (!err.isOperational) {
        console.error('Stack: ', err.stack);
    }

    // Format response based on enviornment
    const response = process.env.NODE_ENV === 'production'
        ? formatProdError(err, req)
        : formatDevError(err, req);
    
    // Set retry-after header for rate limit errors
    if (err.retryAfter) {
        res.set('Retry-After', err.retryAfter);
    }

    res.status(err.statusCode).json(response);
};