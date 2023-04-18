import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/my_response.dart';
import '../module/login/login_controller.dart';
import '../utils.dart/app_styles.dart';
import '../utils.dart/assets_locations.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import 'check_page_salah.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const nameRoute = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final availableLocalesForDateFormatting = const ['id'];

  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeight = 0; //untuk mendapatkan ukuran screen
  double screenWidth = 0;
  final LoginController _controller = LoginController();
  // bool _isVisible = true;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting("id");
    checkTokenLogin();
  }

  void checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";
    // print(basicAuth);

    Response respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth});
    // print(respons.statusCode);
    // print(token);
    final body = respons.body;
    final json = jsonDecode(body);
    // print(json);

    if (respons.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckLogPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.bgColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.fromLTRB(20, 150, 20, 100),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Image(
                        image: AssetsLocation.imageLocation('login2'),
                        width: 235,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _showDate(DateFormat("EEEE, d MMMM yyyy ", "id")
                          .format(DateTime.now())),
                      // _showTime(),
                      _showTime(),
                    ],
                  ),
                ),
                _formLogin(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DigitalClock _showTime() {
    return DigitalClock(
      hourMinuteDigitTextStyle: TextStyle(
        fontFamily: "Montserrat-Medium",
        fontSize: screenWidth / 21,
        color: Colors.black,
      ),
      secondDigitTextStyle: TextStyle(
        fontFamily: "Montserrat-Bold",
        fontSize: screenWidth / 35,
        color: Colors.black,
      ),
      colon: Text(
        ":",
        style: TextStyle(
          fontFamily: "Montserrat-Medium",
          fontSize: screenWidth / 21,
          color: Colors.black,
        ),
      ),
    );
  }

  Container _showDate(date) {
    return Container(
      alignment: Alignment.topCenter,
      child: RichText(
        text: TextSpan(
          text: date,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Montserrat-Regular",
            fontSize: screenWidth / 30,
          ),
        ),
      ),
    );
  }

  Container _formLogin(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle('Username'),
          customField('Masukkan Username Anda', loginController, false),
          fieldTitle('Password'),
          customField('Masukkan Password Anda', passController, true),
          GestureDetector(
            onTap: () async {
              setState(() {
                _controller.isLoading = true;
              });

              FocusScope.of(context).unfocus();
              // untuk sembunyikan keyboard ketika klik tombol login

              // FocusScopeNode currentFocus = FocusScope.of(context);

              // if (!currentFocus.hasPrimaryFocus) {
              //   currentFocus.unfocus();
              // }

              MyResponse response = await _controller.login(
                  loginController.text, passController.text);
              // debugPrint(response.message);

              setState(() {
                _controller.isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message),
                ),
              );

              if (response.status == 200) {
                //berhasil
                //simpan token

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response.message),
                  ),
                );

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CheckLogPage(),
                //   ),
                // );
                //coba del ini dlu

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (route) => false);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response.message),
                  ),
                );
              }
            },
            child: _bottonLogin("LOGIN"),
          ),
        ],
      ),
    );
  }

  Widget _bottonLogin(String title) {
    return (_controller.isLoading
        ? Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: CircularProgressIndicator(
              backgroundColor: Styles.lightOrangeColor,
              color: Styles.darkBlueColor,
              strokeWidth: 10,
            ))
        : Container(
            //tombol login
            height: 50,
            width: screenWidth,
            margin: EdgeInsets.only(top: screenHeight / 80),
            decoration: BoxDecoration(
              color: Styles.lightOrangeColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(35),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Arial",
                  fontSize: screenWidth / 26,
                  color: Styles.whiteColor,
                  letterSpacing: 2,
                ),
              ),
            ),
          ));
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 22,
          fontFamily: "MomcakePro",
          color: Styles.darkBlueColor,
        ),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 100),
              child: TextFormField(
                controller: controller,
                //panggil controller
                enableSuggestions: false,
                autocorrect: false,
                style: TextStyle(
                  fontSize: screenWidth / 22,
                  fontFamily: "MomcakePro",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 80,
                  ),
                  // border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
