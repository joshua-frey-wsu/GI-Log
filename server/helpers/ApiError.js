/**
 * Base class for all API errors.
 * Extends the native Error class with HTTP-specific properties.
 */
class ApiError extends Error {
    constructor(message, statusCode, errorCode = null) {
        super(message);

        // HTTP status code for the response
        this.statusCode = statusCode;

        // Machine-readable error code for client-side handling
        this.errorCode = errorCode || this.constructor.name;

        // Distinguishes operational errros from programming errors
        this.isOperational = true;

        // Captures stack trace, excluding constructor call from it
        Error.captureStackTrace(this, this.constructor);
    }
}

/**
 * Use when a requested resource does not exist.
 * Returns 404 Not Found.
 */
class NotFoundError extends ApiError {
    constructor(resource = 'Resource') {
        super(`${resource} not found`, 404, 'NOT_FOUND');
    }
}

/**
 * Use for validation failures in request data.
 * Returns 400 Bad Request with field-level error details.
 */
class ValidationError extends ApiError {
    constructor(errors) {
        super('Validation Failed', 400, 'VALIDATION_ERRORS');
        // Array of {field, message} objects
        this.errors = errors;
    }
}

/**
 * Use when authentication is missing or invalid.
 * Returns 401 Unauthorized.
 */
class UnauthorizedError extends ApiError {
    constructor(message = 'Authentication required') {
        super(message, 401, 'UNAUTHORIZED');
    }
}

/**
 * Use when user lacks permission for the requested action.
 * Returns 403 Forbidden.
 */
class ForbiddenError extends ApiError {
    constructor(message = 'Access denied') {
        super(message, 403, 'FORBIDDEN');
    }
}

/**
 * Use for duplicate entries or constraint violations.
 * Returns 409 Conflict.
 */
class ConflictError extends ApiError {
    constructor(message = 'Resource already exists') {
        super(message, 409, 'CONFLICT');
    }
}

/**
 * Use when rate limits are exceeded.
 * Returns 429 Too Many Request.
 */
class RateLimitEerror extends ApiError {
    constructor(retryAfter = 60) {
        super('Too many requests', 429, 'RATE_LIMIT_EXCEEDED');
        this.retryAfter = retryAfter;
    }
}

export {
    ApiError,
    NotFoundError,
    ValidationError,
    UnauthorizedError,
    ForbiddenError,
    ConflictError,
    RateLimitEerror
};