import { app } from "./app";

// Handle uncaught exceptions (synchronous errors outside Express)
process.on('uncaughtException', (err) => {
    console.error('UNCAUGHT EXCEPTION - Shutting down...');
    console.error(err.name, err.message);
    console.error(err.stack);

    // Exit immediately - the process is in an undefined state
    process.exit(1);
});

const server = app.listen(process.env.PORT || 3000);

// Handle unhandled promise rejections (async errors outside Express)
process.on('unhandledRejection', (err) => {
    console.error('UNHANDLED REJECTION - Shutting down...');
    console.error(err.name, err.message);
    console.error(err.stack);

    // Close server gracefully before exiting
    server.close(() => {
        process.exit(1);
    });
});

// Handle SIGTERM for graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received. Shutting down gracefully...');
    server.close(() => {
        console.log('Process terminated');
    })
})