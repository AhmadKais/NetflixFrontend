# Use an official Node.js image as the base image
FROM node:14-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Set environment variable for the movie catalog service
ENV MOVIE_CATALOG_SERVICE=http://localhost:8080

# Start the application
CMD ["npm", "start"]
