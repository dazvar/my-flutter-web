import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  Future<Map<String, dynamic>> fetchUserData(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Помилка завантаження даних користувача');
    }
  }
}
