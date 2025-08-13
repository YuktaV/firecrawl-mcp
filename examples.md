# Firecrawl API Usage Examples

## Your API Endpoint
```
https://firecrawl-mcp-production-0593.up.railway.app
```

## 1. Using with cURL

### Scrape a webpage
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.wikipedia.org"}'
```

## 2. Using with Python

```python
import requests
import json

# Your API URL
api_url = "https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape"

# Scrape a webpage
response = requests.post(api_url, json={"url": "https://example.com"})
data = response.json()

# Get the markdown content
if data['success']:
    markdown_content = data['data']['markdown']
    title = data['data']['title']
    print(f"Title: {title}")
    print(f"Content: {markdown_content[:500]}...")  # First 500 chars
```

## 3. Using with JavaScript/Node.js

```javascript
const axios = require('axios');

async function scrapeWebpage(url) {
    const apiUrl = 'https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape';
    
    try {
        const response = await axios.post(apiUrl, { url });
        
        if (response.data.success) {
            console.log('Title:', response.data.data.title);
            console.log('Markdown:', response.data.data.markdown);
        }
    } catch (error) {
        console.error('Error:', error.message);
    }
}

// Example usage
scrapeWebpage('https://news.ycombinator.com');
```

## 4. Using as MCP Server with Claude

You can configure this as an MCP server in Claude Desktop:

1. Edit your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "firecrawl": {
      "url": "https://firecrawl-mcp-production-0593.up.railway.app",
      "description": "Web scraping service"
    }
  }
}
```

## 5. Common Use Cases

### Extract article content
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://medium.com/@username/article-title"}'
```

### Scrape product information
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.amazon.com/dp/B08N5WRWNW"}'
```

### Get documentation
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://docs.python.org/3/tutorial/"}'
```

## Response Format

The API returns JSON with this structure:

```json
{
  "success": true,
  "data": {
    "url": "https://example.com",
    "title": "Page Title",
    "description": "Meta description",
    "markdown": "# Content in Markdown format...",
    "metadata": {
      "sourceURL": "https://example.com",
      "pageStatusCode": 200,
      "pageError": null
    }
  }
}
```

## Error Handling

If scraping fails:

```json
{
  "success": false,
  "error": "Failed to scrape URL",
  "message": "Error details here"
}
```

## Rate Limits

Currently no rate limits are enforced, but be respectful of the service and the websites you're scraping.

## Next Steps

1. **Build a Chrome Extension**: Use the API to save articles for later reading
2. **Create a Discord Bot**: Summarize links shared in channels
3. **Research Tool**: Aggregate content from multiple sources
4. **Content Monitor**: Track changes on specific pages
5. **Data Pipeline**: Feed scraped content into your ML models