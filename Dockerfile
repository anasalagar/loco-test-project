# Stage 1: Build the React application
FROM node:14 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React application for production
RUN npm run build

# Stage 2: Serve the built application with a simple HTTP server
FROM node:14-slim AS production

# Install a simple HTTP server to serve the static files
RUN npm install -g serve

# Set the working directory for the production image
WORKDIR /app

# Copy the build artifacts from the first stage to the production stage
COPY --from=build /app/build ./build

# Expose the port the app runs on
EXPOSE 3000

# Start the server and serve the built application
CMD ["serve", "-s", "build", "-l", "3000"]
