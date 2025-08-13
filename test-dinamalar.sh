#!/bin/bash

echo "Scraping Dinamalar website..."
echo "=============================="

curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.dinamalar.com"}' \
  -s | python3 -m json.tool

echo ""
echo "=============================="
echo "To save the output to a file, run:"
echo "curl -X POST https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape -H \"Content-Type: application/json\" -d '{\"url\": \"https://www.dinamalar.com\"}' -s > dinamalar-content.json"