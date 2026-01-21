import 'dart:convert';
import 'dart:developer';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "AIzaSyBIfIRj8Oj31ncc1tr41ds-1UI-Eas3iEM";
  late final GenerativeModel _model;
  late ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
    _chat = _model.startChat();
  }

  void startNewChat(String systemContext) {
    _chat = _model.startChat(
      history: [
        Content.system("""
You are a POS system assistant. Your goal is to help the user create a new menu item through conversation.

Required fields to identify:
- item_name (String)
- item_description (String)
- category_id (int)
- base_unit (int)
- cost_price (double)
- sales_price (double)
- tax_type (double)
- tax_amount (double)
- taxable_amount (double)
- min_qty (double)
- food_tags (List of int IDs)
- add_ons (List of int IDs)

Available Options (USE THESE IDs):
$systemContext

Rules:
1. Start by greeting the user and asking what they want to add.
2. Converse naturally. Analyze the user's input to extract the fields.
3. If information is missing, you can suggest defaults or ask the user.
4. IMPORTANT: Do NOT set "is_complete" to true until the user explicitly says "save", "confirm", "finish", or something similar indicating they are ready to save the item.
5. Even if you have all the data, keep chatting until the user gives the command to save.
6. When the user says "save", return the JSON object with ALL collected fields and "is_complete": true.
7. If the user is still providing details or just chatting, return "is_complete": false and a helpful "message".

Response format:
{
  "message": "your response to the user",
  "is_complete": boolean,
  "data": {
    "item_name": "string",
    "item_description": "string",
    "category_id": int,
    "base_unit": int,
    "cost_price": double,
    "sales_price": double,
    "tax_type": double,
    "tax_amount": double,
    "taxable_amount": double,
    "min_qty": double,
    "food_tags": [int],
    "add_ons": [int]
  }
}
"""),
      ],
    );
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text ?? "{}";
      return jsonDecode(text);
    } catch (e) {
      log("Gemini Error: $e");
      return {"message": "Error: $e", "is_complete": false};
    }
  }
}
