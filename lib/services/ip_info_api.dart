import 'package:http/http.dart' as http;

class IpInfoApi {
  static Future<String?> getIPAddress() async {
    final url = Uri.parse('https:api.ipify.org');
    final response = await http.get(url);

    return response.body;
  }
}
