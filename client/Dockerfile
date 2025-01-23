# Stage 1: Build React app
FROM node:23-alpine3.20 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./

RUN npm install

# Copy application code and build it
COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build



# Stage 2: Serve React app with Nginx
FROM nginx:alpine

# Copy built files to Nginx's default directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for the frontend app
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
