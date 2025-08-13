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
    git

# Set Puppeteer to use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Clone Firecrawl repository
RUN git clone https://github.com/mendableai/firecrawl.git .

# Install dependencies
RUN npm install

# Copy custom Gemini adapter
COPY gemini-adapter.js /app/lib/llm/

# Expose ports
EXPOSE 3000 3001

# Start the application
CMD ["npm", "start"]