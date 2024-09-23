# Stage 1: Build the React application
FROM node:14 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
#Copies the package.json and package-lock.json files from your local machine to the working directory in the container.
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
# Copies all the remaining files from your local directory (the context) into the working directory of the container.
COPY . .

# Build the React application for production
RUN npm run build

# Stage 2: Serve the built application with a simple HTTP server
FROM node:14-slim AS production

#nstalls the serve package globally. serve is a simple static file server for serving the built React app.
# Install a simple HTTP server to serve the static files
RUN npm install -g serve

# Set the working directory for the production image
WORKDIR /app

# Copy the build artifacts from the first stage to the production stage
COPY --from=build /app/build ./build

# Expose the port the app runs on
EXPOSE 3000

#Specifies the command to run when the container starts. Here, it starts the serve server, serving the contents of the build directory on port 3000.
# Start the server and serve the built application
CMD ["serve", "-s", "build", "-l", "3000"]

#CMD This instruction defines the default command to run when the container is started. It's the last command that is executed when the container runs, 
#and it can be overridden by providing a command when starting the container.
#-s This flag stands for "single page application" mode. It tells serve to handle client-side routing properly
#-l "listen". It allows you to specify the port that the server should listen on.
#3000 This is the port number on which the serve command will listen for incoming requests.
