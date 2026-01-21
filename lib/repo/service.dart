import 'dart:convert';
import 'dart:developer' show log;
import 'package:http/http.dart' as http;
import '../core/api_constant.dart';
import '../model/meniitem.dart';

class MenuItems {
  Future<http.Response> addItem(MenuItem item, String token) async {
    var baseUrl = "https://devatithi.intradeplus.com";
    // var token = "EB2F0F66-5369-41A8-A5CA-5B4C0A96721A";
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(baseUrl + ApiEndPoints.addMenuItem);
      Map body = item.toJson();
      log(jsonEncode(body));
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      log(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAIResponse(String description) async {
    // Note: The backend endpoint /AI/ProcessDescription is currently unavailable.
    // Implementing a mock response for testing purposes.
    log("Mocking AI response for: $description");
    await Future.delayed(const Duration(seconds: 1));

    // Simple mock parsing logic
    double salePrice = 0;
    final priceMatch = RegExp(
      r'(\d+)',
      caseSensitive: false,
    ).allMatches(description);
    if (priceMatch.isNotEmpty) {
      salePrice = double.tryParse(priceMatch.last.group(0)!) ?? 0;
    }

    String itemName = "";
    final words = description.split(' ');
    if (words.length >= 2) {
      itemName = "${words[0]} ${words[1]}".toUpperCase();
    } else {
      itemName = description.toUpperCase();
    }

    return {
      "item_name": itemName,
      "description": description,
      "price": salePrice > 0 ? salePrice * 0.7 : 0.0,
      "sale_price": salePrice,
      "tax": 13.0,
      "quantity": 1,
    };
  }
}
