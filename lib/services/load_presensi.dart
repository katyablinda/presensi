import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_presensi.dart';

class LoadPresensi {
  // final List<dataPresensi> _presensi = [];
  Future<List<dataPresensi>> fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    var respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth});

    List<dataPresensi> uPresensi = [];

    if (respons.statusCode == 200) {
      //hapus as-nya
      var urjson = json.decode(respons.body) as Map;
      // print(urjson);
      var datajson = urjson['data']['dataPresensi'] as List;

      for (var jsondata in datajson) {
        uPresensi.add(
          dataPresensi.fromJson(jsondata),
        );
      }
    }
    return uPresensi;
  }
}
