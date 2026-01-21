import '../model/addstyle.dart';

class AddedStyleService {
  final String baseUrl = "https://devatithi.intradeplus.com";
  final String token = "EB2F0F66-5369-41A8-A5CA-5B4C0A96721A";

  // Simulate fetching styles from an API or return the static list
  Future<List<AddedStyle>> fetchStyles() async {
    try {
      // If you have an endpoint:
      // final response = await http.get(Uri.parse('$baseUrl/api/styles'), headers: {...});
      // if (response.statusCode == 200) { ... parse json ... }
      // For now, returning your static list with a small delay to simulate a network call
      await Future.delayed(const Duration(milliseconds: 500));
      return AddedStyle.staticStyles;
    } catch (e) {
      rethrow;
    }
  }
}