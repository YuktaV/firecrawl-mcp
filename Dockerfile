FROM node:18-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set Puppeteer to use installed Chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Clone Firecrawl repository
WORKDIR /app
RUN git clone https://github.com/mendableai/firecrawl.git .

# Navigate to the API directory
WORKDIR /app/apps/api

# Install dependencies
RUN npm install

# Build the application
RUN npm run build || true

# Create a startup script that handles the monorepo structure
RUN echo '#!/bin/sh\n\
echo "Starting Firecrawl API server..."\n\
cd /app/apps/api\n\
# Try to run the built version first\n\
if [ -f "dist/src/index.js" ]; then\n\
    echo "Running built version..."\n\
    node dist/src/index.js\n\
else\n\
    echo "Running development version..."\n\
    npm run start\n\
fi' > /start.sh && chmod +x /start.sh

# Expose the port
EXPOSE 3002

# Use the startup script
CMD ["/start.sh"]