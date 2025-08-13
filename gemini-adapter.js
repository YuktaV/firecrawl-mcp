const { GoogleGenerativeAI } = require('@google/generative-ai');

class GeminiAdapter {
  constructor(apiKey) {
    this.genAI = new GoogleGenerativeAI(apiKey);
    this.model = this.genAI.getGenerativeModel({ model: "gemini-pro" });
  }

  async generateText(prompt, options = {}) {
    try {
      const result = await this.model.generateContent(prompt);
      const response = await result.response;
      return response.text();
    } catch (error) {
      console.error('Gemini API error:', error);
      throw error;
    }
  }

  async extractStructuredData(text, schema) {
    const prompt = `Extract the following information from the text according to this schema: ${JSON.stringify(schema)}
    
    Text: ${text}
    
    Return the result as valid JSON.`;
    
    const result = await this.generateText(prompt);
    try {
      return JSON.parse(result);
    } catch (e) {
      return result;
    }
  }
}

module.exports = GeminiAdapter;