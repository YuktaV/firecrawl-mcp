const express = require('express');
const puppeteer = require('puppeteer');
const TurndownService = require('turndown');
require('dotenv').config();

const app = express();
app.use(express.json());

// Serve static files from public directory
app.use(express.static('public'));

const PORT = process.env.PORT || 3002;
const HOST = process.env.HOST || '0.0.0.0';

// Initialize Turndown for HTML to Markdown conversion
const turndownService = new TurndownService({
  headingStyle: 'atx',
  codeBlockStyle: 'fenced'
});

// Health check endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'Firecrawl MCP Server (Simplified)',
    version: '1.0.0',
    endpoints: {
      scrape: 'POST /v0/scrape',
      health: 'GET /'
    }
  });
});

// Simple scrape endpoint
app.post('/v0/scrape', async (req, res) => {
  let browser;
  
  try {
    const { url } = req.body;
    
    if (!url) {
      return res.status(400).json({ 
        success: false, 
        error: 'URL is required' 
      });
    }

    console.log(`Scraping URL: ${url}`);

    // Launch Puppeteer
    browser = await puppeteer.launch({
      headless: 'new',
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu'
      ],
      executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || '/usr/bin/google-chrome-stable'
    });

    const page = await browser.newPage();
    
    // Set user agent
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
    
    // Navigate to URL
    await page.goto(url, { 
      waitUntil: 'networkidle2',
      timeout: 30000 
    });

    // Get page content
    const content = await page.evaluate(() => {
      // Remove script and style elements
      const scripts = document.querySelectorAll('script, style, noscript');
      scripts.forEach(el => el.remove());
      
      // Get title
      const title = document.title;
      
      // Get meta description
      const metaDesc = document.querySelector('meta[name="description"]');
      const description = metaDesc ? metaDesc.getAttribute('content') : '';
      
      // Get main content
      const body = document.body.innerHTML;
      
      return {
        title,
        description,
        html: body
      };
    });

    // Convert HTML to Markdown
    const markdown = turndownService.turndown(content.html);

    // Close browser
    await browser.close();

    // Return response
    res.json({
      success: true,
      data: {
        url,
        title: content.title,
        description: content.description,
        markdown,
        metadata: {
          sourceURL: url,
          pageStatusCode: 200,
          pageError: null
        }
      }
    });

  } catch (error) {
    console.error('Scraping error:', error);
    
    if (browser) {
      await browser.close();
    }
    
    res.status(500).json({
      success: false,
      error: 'Failed to scrape URL',
      message: error.message
    });
  }
});

// Start server
app.listen(PORT, HOST, () => {
  console.log(`🔥 Firecrawl MCP Server (Simplified) running at http://${HOST}:${PORT}`);
  console.log(`📝 Scraping endpoint: POST http://${HOST}:${PORT}/v0/scrape`);
  console.log(`❤️  Health check: GET http://${HOST}:${PORT}/`);
});