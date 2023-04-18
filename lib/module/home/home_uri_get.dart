import 'dart:convert';

import 'package:http/http.dart' as http;

class UriGet {
  Future<http.Response> urigetToken(token) {
    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    return http.get(Uri.parse('https://api-presensi.itp.ac.id/?token = $token'),
        headers: <String, String>{'authorization': basicAuth});
  }

  Future<http.Response> uriPostCheck(dataJam, absensiID) {
    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    return http.post(Uri.parse("https://api-presensi.itp.ac.id/APIPut"),
        headers: <String, String>{
          'authorization': basicAuth
        },
        body: {
          'DateTime': dataJam,
          'AbsensiID': absensiID,
        });
  }
}
