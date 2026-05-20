/**
 * Handles specific error types like errors from libraries or databases.
 * These type of errors nee to be converted to fit the custom error format created.
 */

import { ApiError, ValidationError, ConflictError } from "../helpers/ApiError.js";

/**
 * Converts known error types to ApiError instances.
 * This middleware sits before the main error handler
 */
export const errorConverter = (err, req, res, next) => {
    let convertedError = err;

    // TODO - Handle Postgres errors

    // Handle JSON parse errors
    if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
        convertedError = new ApiError('Invalid JSON in request body', 400, 'INVALID_JSON');
    }

    // Handle JWT errors
    if (err.name === 'JsonWebTokenError') {
        convertedError = new ApiError('Invalid token', 401, 'INVALID_TOKEN');
    }

    if (err.name === 'TokenExpiredError') {
        convertedError = new ApiError('Token expired', 401, 'TOKEN_EXPIRED');
    }

    next(convertedError); // passes it down to next middleware (errorHandler)
}