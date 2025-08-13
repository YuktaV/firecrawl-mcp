FROM node:18-alpine

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

# Clone and setup Firecrawl
WORKDIR /firecrawl
RUN git clone https://github.com/mendableai/firecrawl.git . && \
    ls -la

# Navigate to the API directory where the actual application is
WORKDIR /firecrawl/apps/api

# Install dependencies
RUN npm install

# Install additional packages for Gemini support
RUN npm install @google/generative-ai dotenv

# Copy custom Gemini adapter
COPY gemini-adapter.js /firecrawl/apps/api/src/lib/

# Set working directory for runtime
WORKDIR /firecrawl/apps/api

# Expose ports
EXPOSE 3002

# Start the application with proper command
CMD ["npm", "run", "start:production"]