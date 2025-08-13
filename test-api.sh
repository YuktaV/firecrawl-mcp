#!/bin/bash

# Test script for Firecrawl API

echo "Testing Firecrawl API..."
echo "========================"

# Your Railway URL
API_URL="https://firecrawl-mcp-production-0593.up.railway.app"

# Test 1: Health Check
echo "1. Health Check:"
curl -s "$API_URL/" | python3 -m json.tool
echo ""

# Test 2: Scrape a webpage
echo "2. Scraping example.com:"
curl -X POST "$API_URL/v0/scrape" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}' \
  | python3 -m json.tool

echo ""
echo "========================"
echo "API is working!"