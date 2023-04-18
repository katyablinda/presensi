import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<http.Response> login(String username, String password) {
    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    return http.post(Uri.parse("https://api-presensi.itp.ac.id/APIGet"),
        headers: <String, String>{
          'authorization': basicAuth
        },
        body: {
          'username': username,
          'password': password,
        });
  }
}
