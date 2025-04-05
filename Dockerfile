# Step 1: Use the official Flutter Docker image
FROM cirrusci/flutter:stable AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy your Flutter project files into the container
COPY . .

# Step 4: Get Flutter dependencies (now it will work with the latest Dart SDK)
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
