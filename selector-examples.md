# CSS Selector Examples for Firecrawl

Your Firecrawl service now supports CSS selectors for targeted content extraction!

## Basic Usage

### Extract specific elements
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://news.ycombinator.com", 
    "selector": ".titleline a"
  }'
```

### Get multiple elements
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://news.ycombinator.com", 
    "selector": ".athing",
    "multiple": true
  }'
```

### Wait for dynamic content
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com", 
    "waitForSelector": ".dynamic-content"
  }'
```

## Real-World Examples

### 1. Extract Dinamalar News Headlines
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.dinamalar.com", 
    "selector": ".news-title a",
    "multiple": true
  }'
```

### 2. Get Article Content Only
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://medium.com/@username/article", 
    "selector": "article"
  }'
```

### 3. Extract Product Prices
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example-store.com/product", 
    "selector": ".price",
    "multiple": true
  }'
```

### 4. Get Table Data
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com/data", 
    "selector": "table tbody tr"
    "multiple": true
  }'
```

### 5. Extract Navigation Links
```bash
curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com", 
    "selector": "nav a",
    "multiple": true
  }'
```

## Common Selectors

| Purpose | Selector | Example |
|---------|----------|---------|
| Headlines | `h1, h2, h3` | All headings |
| Articles | `article, .post, .content` | Main content areas |
| Links | `a[href]` | All links |
| Images | `img` | All images |
| Tables | `table` | All tables |
| Lists | `ul li, ol li` | List items |
| Forms | `form input` | Form inputs |
| Navigation | `nav a, .menu a` | Navigation links |
| Prices | `.price, .cost, .amount` | Common price classes |
| Dates | `.date, .time, time` | Date/time elements |

## Response Format with Selectors

When using selectors, the response includes additional information:

```json
{
  "success": true,
  "data": {
    "url": "https://example.com",
    "title": "Page Title",
    "description": "Meta description",
    "markdown": "Extracted content...",
    "selectedElements": {
      "text": "Clean text content",
      "html": "<div>Original HTML</div>",
      "attributes": {
        "class": "example-class",
        "id": "example-id"
      }
    },
    "selectorUsed": ".example-selector",
    "metadata": {
      "elementsFound": 5
    }
  }
}
```

## Tips for Effective Selectors

1. **Be Specific**: Use class names and IDs for precise targeting
2. **Test First**: Use browser dev tools to test selectors
3. **Handle Multiple**: Use `"multiple": true` for lists of items
4. **Wait for Content**: Use `waitForSelector` for dynamic content
5. **Combine Selectors**: Use CSS selector combinators (` `, `>`, `+`, `~`)

## Use Cases

- **News Aggregation**: Extract headlines and summaries
- **Price Monitoring**: Track specific product prices
- **Content Analysis**: Get only article text, not navigation
- **Data Extraction**: Pull structured data from tables
- **Link Harvesting**: Collect specific types of links
- **Social Media**: Extract posts, comments, or user info