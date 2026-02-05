# Use a specific, stable version (not 'latest') for security consistency
FROM nginx:stable-alpine

# Security: Run as a non-root user to prevent container escape exploits
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx

# Copy your website files
COPY index.html /usr/share/nginx/html/index.html

# Switch to the non-privileged user
USER nginx

EXPOSE 8080