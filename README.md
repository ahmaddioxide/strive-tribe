# My Express API

This repository contains an Nx monorepo with an Express API application.

## Prerequisites

- [Node.js](https://nodejs.org/) (LTS version recommended)
- [MongoDB](https://www.mongodb.com/try/download/community)
- [Nx CLI](https://nx.dev/getting-started/nx-setup) (installed globally)

## Getting Started

Follow these steps to set up and run the project:

### 1. Install Nx CLI globally

```bash
npm install -g nx
```

### 2. Ensure MongoDB is running

Make sure your MongoDB server is up and running. If you need to install MongoDB, follow the instructions on the [MongoDB website](https://www.mongodb.com/try/download/community).

### 3. Configure Environment Variables

Create or modify the environment file at:

```
apps/my-express-api/.env.serve.development
```

Add the necessary environment variables, including your MongoDB connection URL:

```
# Example environment variables
PORT=3000
MONGODB_URI=mongodb://localhost:27017/my-database
# Add other required variables here
```

### 4. Install Dependencies

Run the following command in the repository root:

```bash
npm install
```

### 5. Start the API in Development Mode

Run the application in watch mode:

```bash
nx serve my-express-api
```

This will start the Express API with hot-reloading enabled. Any changes to the source code will automatically restart the server.

## Available Commands

- `nx serve my-express-api`: Run the API in development mode
- `nx build my-express-api`: Build the API for production
- `nx test my-express-api`: Run tests for the API
- `nx lint my-express-api`: Lint the API code

## Project Structure

This project is built using [Nx](https://nx.dev/), a smart, extensible build framework for monorepos.

```
├── apps/
│   └── my-express-api/    # Main Express API application
├── libs/                  # Shared libraries
├── tools/                 # Build and configuration tools
├── nx.json                # Nx configuration
└── package.json           # Project dependencies
```

## Additional Resources

- [Nx Documentation](https://nx.dev/getting-started/intro)
- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)