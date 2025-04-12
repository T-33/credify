import OpenAI from 'openai';

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});


//currently AkylAI api is not available, so we used openai.
async function getLoanSupportResponse(userMessage, userContext = {}) {
  try {
    const response = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: prompts.bankingLoanAssistant
            .replace('[Your Bank Name]', userContext.bankName || 'Our Bank')
        },
        {
          role: 'user',
          content: userMessage,
        }
      ],
      temperature: 0.3,
      max_tokens: 500
    });

    return {
      answer: response.choices[0].message.content,
      tokensUsed: response.usage.total_tokens
    };
  } catch (error) {
    console.error('OpenAI error:', error);
    throw new Error('Failed to get loan support');
  }
}
