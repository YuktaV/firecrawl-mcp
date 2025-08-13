#!/usr/bin/env python3
import requests
import json

# Your deployed API URL
API_URL = "https://firecrawl-mcp-production-0593.up.railway.app/v0/scrape"

def test_scraper(url):
    """Test the scraping API with a given URL"""
    print(f"\n🔍 Testing scraper with: {url}")
    print("-" * 50)
    
    try:
        # Make the request
        response = requests.post(
            API_URL,
            json={"url": url},
            headers={"Content-Type": "application/json"},
            timeout=60  # 60 second timeout
        )
        
        # Parse response
        data = response.json()
        
        if data.get('success'):
            print("✅ Success!")
            print(f"Title: {data['data'].get('title', 'N/A')}")
            print(f"Description: {data['data'].get('description', 'N/A')[:100]}...")
            
            markdown = data['data'].get('markdown', '')
            print(f"\nMarkdown content (first 500 chars):")
            print(markdown[:500])
        else:
            print(f"❌ Failed: {data.get('error')}")
            print(f"Message: {data.get('message')}")
            
    except requests.exceptions.Timeout:
        print("⏱️ Request timed out")
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    # Test with different URLs
    test_urls = [
        "https://httpbin.org/html",  # Simple HTML page for testing
        "https://news.ycombinator.com",  # Hacker News
        "https://en.wikipedia.org/wiki/Web_scraping"  # Wikipedia article
    ]
    
    for url in test_urls:
        test_scraper(url)
        print("\n" + "="*50)