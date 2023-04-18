import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart/app_styles.dart';
import 'title_header.dart';

class AppBarTitle extends StatefulWidget {
  const AppBarTitle({super.key});

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  double screenHeight = 0; //untuk mendapatkan ukuran screen
  double screenWidth = 0;

  String nama = "";
  String divisi = "";
  String jabatan = "";
  String foto = "";

  void checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    Response respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth});
    // print(token);
    final body = respons.body;
    final json = jsonDecode(body);

    setState(() {
      nama = json['data']['Nama'];
      divisi = json['data']['Posisi'];
      jabatan = json['data']['Jabatan'];
      foto = json['data']['Foto'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // debugPrint(hasilToken);
    // MyResponse response = await _controller.login("", "");

    return Container(
      padding: const EdgeInsets.only(left: 15),
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //foto profil
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Styles.whiteColor),
                    borderRadius: BorderRadius.circular(100)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Styles.whiteColor,
                      radius: 30,
                      backgroundImage:
                          foto.isNotEmpty ? NetworkImage(foto) : null,
                      //    backgroundImage:
                      // NetworkImage(foto) ,
                    )
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          TitleHeader(
            employeeName: nama,
            jobTitle: "$jabatan\n$divisi",
            absenceStatus: "Ambil presensi Anda hari ini !",
          ),
        ],
      ),
    );
  }
}
