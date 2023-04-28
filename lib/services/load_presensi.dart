import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils.dart/app_styles.dart';
import 'data_presensi.dart';

class LoadPresensi {
  // final List<dataPresensi> _presensi = [];
  Future<List<dataPresensi>> fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";
    List<dataPresensi> uPresensi = [];

    // final respons = await get(
    //   Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
    //   headers: <String, String>{'authorization': basicAuth},
    // );

    // if (respons.statusCode == 200) {
    //   //hapus as-nya
    //   var urjson = json.decode(respons.body) as Map;
    //   // print(urjson);
    //   var datajson = urjson['data']['dataPresensi'] as List;

    //   for (var jsondata in datajson) {
    //     uPresensi.add(
    //       dataPresensi.fromJson(jsondata),
    //     );
    //   }
    // }

    try {
      final respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth},
      );
      if (respons.statusCode == 200) {
        //SUKSES
        //hapus as-nya
        var urjson = json.decode(respons.body) as Map;

        if (urjson['status'] == 404) {
          Future.delayed(Duration(seconds: 1));

          Fluttertoast.showToast(
              msg: urjson['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Styles.redColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        var datajson = urjson['data']['dataPresensi'] as List;

        for (var jsondata in datajson) {
          uPresensi.add(
            dataPresensi.fromJson(jsondata),
          );
        }
      }
    } catch (e) {
      if (e is SocketException && e.osError?.errorCode == 104) {
        // debugPrint("Tidak terhubung ke internet");
        Fluttertoast.showToast(
            msg: "Gagal terhubung ke internet. Silahkan login kembali",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Styles.redColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e is SocketException) {
        // debugPrint("Masalah koneksi: ${e.message}");
        Fluttertoast.showToast(
            msg: "Masalah koneksi: ${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Styles.redColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        debugPrint("Penanganan kesalahan lainnya: $e");
      }
    }
    return uPresensi;
  }
}
