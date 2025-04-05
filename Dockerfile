# Step 1: Use an official Flutter image to build the app
FROM cirrusci/flutter:stable AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy the Flutter project files into the container
COPY . .

# Step 4: Get Flutter dependencies
RUN flutter pub get

# Step 5: Build the Flutter web app
RUN flutter build web --release

# Step 6: Use an official Nginx image to serve the built app
FROM nginx:alpine

# Step 7: Copy the build folder to the Nginx server's directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Step 8: Expose the default Nginx port
EXPOSE 80

# Step 9: Start the Nginx server to serve the Flutter app
CMD ["nginx", "-g", "daemon off;"]