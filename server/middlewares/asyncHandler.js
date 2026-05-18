/**
 * Wraps async route handlers to catch rejected promises
 * and foward them to Express error middleware.
 */

export const asyncHandler = (fn) => {
    return (req, res, next) => {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
};