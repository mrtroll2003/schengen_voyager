# Use an official Flutter image from Docker Hub
# Choose a specific version to ensure consistent builds, e.g., flutter:3.19.0 or latest stable
FROM ghcr.io/cirruslabs/flutter:stable as builder

# Set the working directory
WORKDIR /app

# Copy the Flutter project files into the container
COPY . .

ARG GEMINI_API_KEY
ARG PEXELS_API_KEY

# Get Flutter dependencies
RUN flutter pub get

# Build the Flutter web application for release
# You can include --dart-define here if you're using that method for API keys
# e.g., RUN flutter build web --release --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY --dart-define=PEXELS_API_KEY=$PEXELS_API_KEY
RUN flutter build web --release \
    --dart-define=GEMINI_API_KEY=${GEMINI_API_KEY} \
    --dart-define=PEXELS_API_KEY=${PEXELS_API_KEY}

# --- Second stage: Use a lightweight web server to serve the static files ---
# This creates a smaller final image.
FROM nginx:alpine

# Remove default nginx config
RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the built Flutter web app from the 'build' stage
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port 80 (standard HTTP port)
EXPOSE 80

# Command to start nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]