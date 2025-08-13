# Firecrawl MCP Server Deployment on Railway

## Quick Deployment Steps

### 1. Push to GitHub
First, create a GitHub repository and push these files:
```bash
git init
git add .
git commit -m "Initial Firecrawl MCP setup with Gemini"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

### 2. Deploy on Railway

1. Go to [Railway](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Connect your GitHub account and select your repository
5. Railway will automatically detect the Dockerfile

### 3. Configure Environment Variables

In Railway dashboard:
1. Click on your service
2. Go to "Variables" tab
3. Add these environment variables:

```
GEMINI_API_KEY=AIzaSyBlyEBHE4ndn0T69-d9lhjXMklfMlvWF-c
LLM_PROVIDER=gemini
PORT=3000
NODE_ENV=production
RATE_LIMIT_MAX=100
RATE_LIMIT_WINDOW_MS=60000
MAX_CRAWL_DEPTH=3
MAX_CRAWL_PAGES=100
SCRAPE_TIMEOUT=30000
MCP_SERVER_PORT=3001
MCP_SERVER_NAME=firecrawl-mcp
```

### 4. Add Redis (Optional but Recommended)

1. In Railway dashboard, click "New"
2. Select "Database" → "Redis"
3. Railway will automatically inject REDIS_URL

### 5. Deploy

Railway will automatically deploy when you:
- Push changes to GitHub
- Update environment variables
- Click "Redeploy"

## Alternative: Direct GitHub Deployment

You can also deploy directly from Firecrawl's repository:

1. In Railway, select "Deploy from GitHub repo"
2. Use: `https://github.com/mendableai/firecrawl`
3. Add environment variables as above
4. Modify the start command to use Gemini instead of OpenAI

## Accessing Your MCP Server

Once deployed, Railway will provide you with a URL like:
- `https://your-app.railway.app` - Main Firecrawl API
- `https://your-app.railway.app:3001` - MCP Server endpoint

## MCP Client Configuration

To use with an MCP client, configure:
```json
{
  "mcpServers": {
    "firecrawl": {
      "url": "https://your-app.railway.app:3001",
      "apiKey": "your-optional-api-key"
    }
  }
}
```

## Testing the Deployment

```bash
# Test Firecrawl API
curl https://your-app.railway.app/health

# Test MCP endpoint
curl https://your-app.railway.app:3001/status
```