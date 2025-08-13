FROM node:18-alpine

WORKDIR /app

# Install dependencies for Firecrawl
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    git \
    python3 \
    make \
    g++

# Set Puppeteer to use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Clone Firecrawl repository
RUN git clone https://github.com/mendableai/firecrawl.git /tmp/firecrawl && \
    cp -r /tmp/firecrawl/* . && \
    rm -rf /tmp/firecrawl

# Check if package.json exists in apps/api directory (Firecrawl's structure)
RUN if [ -f "apps/api/package.json" ]; then \
        cd apps/api && npm install; \
    elif [ -f "package.json" ]; then \
        npm install; \
    else \
        echo "No package.json found"; \
    fi

# Copy custom files
COPY gemini-adapter.js /app/
COPY package.json /app/package-custom.json

# Expose ports
EXPOSE 3000 3001

# Start the application
CMD if [ -f "apps/api/package.json" ]; then \
        cd apps/api && npm start; \
    else \
        npm start; \
    fi