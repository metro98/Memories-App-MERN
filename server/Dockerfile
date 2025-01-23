# Use Node.js base image
FROM node:23-alpine3.20


# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the backend code
COPY . .


# Expose port 5000 for the backend API
EXPOSE 5000

# Start the backend server
CMD ["npm", "start"]
