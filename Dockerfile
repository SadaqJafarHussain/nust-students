# Step 1: Use an official base image with a suitable version of Dart
FROM ubuntu:22.04 AS build

# Step 2: Install dependencies for Flutter
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Install Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"

# Step 4: Get Flutter dependencies
WORKDIR /app
COPY . .
RUN flutter pub get

# Step 5: Build the Flutter web app
RUN flutter build web --release

# Step 6: Use a lighter web server to serve the web app
FROM nginx:alpine

# Copy the build output to Nginx's public directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose the default Nginx port
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
