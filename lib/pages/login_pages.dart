import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
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
    // cekIP();
  }

  // void cekIP() async {
  //   final ipv4json = await Ipify.ipv64(format: Format.JSON);
  //   print(ipv4json);
  // }

//untuk cek token valid/nggak
  void checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String user = 'bitkom-api';
    String pass = '#bitkom2023';
    String basicAuth = "Basic ${base64Encode(utf8.encode('$user:$pass'))}";

    Response respons = await get(
        Uri.parse('https://api-presensi.itp.ac.id/APIGet?token=$token'),
        headers: <String, String>{'authorization': basicAuth});

    final body = respons.body;
    // final json = jsonDecode(body);

    if (respons.statusCode == 200) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bool isKeyboardVisible =
    //     KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.bgColor,
      body: Column(
        children: [
          //bg Putih
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(30, screenHeight / 5, 30, 0),
            decoration: BoxDecoration(
              color: Styles.whiteColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            //isi di dalam bg Putih
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        //bg gambar siHadir
                        Image(
                          image: AssetsLocation.imageLocation('login2'),
                          height: screenHeight / 6.5,
                        ),
                        const Gap(10),
                        //TANGGAL REALTIME
                        _showDate(),
                        //JAM REALTIME
                        _showTime(),
                      ],
                    ),
                  ),
                  _formLogin(context),
                ],
              ),
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
        color: Styles.textBlack,
      ),
      secondDigitTextStyle: TextStyle(
        fontFamily: "Montserrat-Bold",
        fontSize: screenWidth / 35,
        color: Styles.textBlack,
      ),
      colon: Text(
        ":",
        style: TextStyle(
          fontFamily: "Montserrat-Medium",
          fontSize: screenWidth / 21,
          color: Styles.textBlack,
        ),
      ),
    );
  }

  RichText _showDate() {
    return RichText(
      text: TextSpan(
        text: DateFormat("EEEE, d MMMM yyyy ", "id").format(DateTime.now()),
        style: TextStyle(
          color: Styles.textBlack,
          fontFamily: "Montserrat-Regular",
          fontSize: screenWidth / 30,
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

              MyResponse response = await _controller.login(
                  loginController.text, passController.text);

              setState(() {
                _controller.isLoading = false;
              });

              if (response.status == 200) {
                //berhasil  simpan token login berhasil
                if (context.mounted) {
                  Fluttertoast.showToast(
                      msg: response.message,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Styles.greenColor,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (route) => false);
                }
              } else {
                if (context.mounted) {
                  //gagal login
                  Fluttertoast.showToast(
                      msg: response.message,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Styles.redColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
            },
            child: (_controller.isLoading
                ? Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(
                      backgroundColor: Styles.lightOrangeColor,
                      color: Styles.darkBlueColor,
                      strokeWidth: 10,
                    ),
                  )
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
                        "LOGIN",
                        style: TextStyle(
                          fontFamily: "Arial",
                          fontSize: screenWidth / 26,
                          color: Styles.whiteColor,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  )),
          ),
        ],
      ),
    );
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
      decoration: BoxDecoration(
        color: Styles.whiteColor,
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
