import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_uri_get.dart';

class CheckToken {
  final UriGet _getUri = UriGet();

  Future checkToken() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";
    // print(basicAuth);

    Response respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth});

    final body = respons.body;
    final json = jsonDecode(body);
    // print(json);
    return respons.statusCode;
  }

  Future simpanPresensi(dynamic dataJam) async {
    final prefs = await SharedPreferences.getInstance();

    String? absensiID = prefs.getString('absensiID');
    // String? absensiID = prefs.getString('absensiID');

    Response result = await _getUri.uriPostCheck(dataJam, absensiID);

    final body = result.body;

    final json = jsonEncode(body);
    print(json);

    return json;
  }
}
