import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/home/home_check_token.dart';
import '../services/data_presensi.dart';
import '../services/load_presensi.dart';
import '../utils.dart/app_styles.dart';
import '../widgets/body/check_page.dart';
import 'login_pages.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  // static const nameRoute = '/checkpage';

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double screenHeight = 0; //untuk mendapatkan ukuran screen
  double screenWidth = 0;

  final CheckToken _simpanPresensi = CheckToken();
  final LoadPresensi _load = LoadPresensi();
  final List<dataPresensi> _presensi = [];
  final CheckToken _checktoken = CheckToken();
  final RefreshController _rfc = RefreshController();
  // bool _isLoading = false;

  @override
  void initState() {
    checkTokenPage();
    loadPresensi();
    // refresh();
    // cekIP();
    super.initState();
  }

  void checkTokenPage() async {
    _checktoken.checkToken().then((hasilToken) {
      setState(() {
        if (hasilToken != 200) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        }
      });
    });
  }

  void loadPresensi() async {
    print("AAAAAAAAAAAAAA");
    _presensi.clear();
    await _load.fetchJson().then((value) {
      setState(() {
        _presensi.addAll(value);
        // print(value);
        _rfc.refreshCompleted();
      });
    });
  }

  void simpanPresensi(dataJam) async {
    await _simpanPresensi.simpanPresensi(dataJam).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    // print(formattedDate);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        elevation: 0,
        titleSpacing: 5,
        title: Center(child: Text("Test Refresh Page")),
      ),
      body: SmartRefresher(
        controller: _rfc,
        onRefresh: loadPresensi,
        header: WaterDropHeader(
          waterDropColor: Styles.lightOrangeColor,
        ),
        child: ListView(
          children: [
            SliderPresensi(),
            Container(
              //card utk riwayat presensi dan bg biru
              height: screenHeight / 1.9,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Styles.darkBlueColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Container(
                // margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Riwayat PRESENSIIIIIIIIIIIII",
                            style: textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const Gap(10),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight / 9,
                                  margin: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Styles.greyblueColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _hariTanggal(index),
                                            //     "TERLAMBAT 5 MENIT", Styles.redColor),
                                            // _statusAbsen(
                                            _statusAbsen(index),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _jenisAbsen("Absen Masuk"),
                                                  const Gap(4),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    _presensi[index].waktuMasuk,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Montserrat-Bold",
                                                      color: Styles.textBlack,
                                                      fontSize:
                                                          screenWidth / 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  _jenisAbsen("Absen Pulang"),
                                                  const Gap(4),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    _presensi[index]
                                                        .waktuPulang,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Montserrat-Bold",
                                                      color: Styles.textBlack,
                                                      fontSize:
                                                          screenWidth / 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: _presensi.length,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> _actionButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.settings_applications_rounded,
        color: Styles.whiteColor,
        size: 30,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Styles.textBlack,
                size: 15,
              ),
              const Text(
                '  Log Out',
                style: TextStyle(
                  fontFamily: "Arial",
                  fontSize: 13,
                ),
              ),
            ],
          ),
          onTap: () async {
            //FUNGSI LOGOUT
            // SystemNavigator.pop();
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            await prefs.remove('absensiID');
            Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              Fluttertoast.showToast(
                  msg: "Anda telah Log Out",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Styles.redColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
        ),
      ],
    );
  }

  RoundedBackgroundText _statusAbsen(int index) {
    if (_presensi[index].status == 'red') {
      return RoundedBackgroundText(
        //notif terlambat/ontime
        _presensi[index].ket,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: "Montserrat-Bold",
          fontSize: 8,
        ),
        backgroundColor: Styles.redColor,
        innerRadius: 0,
        outerRadius: 0,
      );
    } else {
      return RoundedBackgroundText(
        //notif terlambat/ontime
        _presensi[index].ket,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: "Montserrat-Bold",
          fontSize: 8,
        ),
        backgroundColor: Styles.greenColor,
        innerRadius: 0,
        outerRadius: 0,
      );
    }
  }

  RichText _hariTanggal(int index) {
    return RichText(
      softWrap: true,
      maxLines: 1,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: _presensi[index].tanggal,
        style: TextStyle(
          color: Styles.textBlack,
          fontFamily: "Montserrat-SemiBold",
          fontSize: 12,
        ),
      ),
    );
  }

  RoundedBackgroundText _jenisAbsen(String statusAbsen) {
    return RoundedBackgroundText(
      //notif terlambat/ontime
      statusAbsen,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: "Montserrat-Regular",
        fontSize: 8,
      ),
      backgroundColor: Styles.lightYellowColor,
      innerRadius: 0,
      outerRadius: 0,
    );
  }
}

// //INI DIPAKAI
// class TestHistory extends StatefulWidget {
//   const TestHistory({
//     super.key,
//     required this.screenHeight,
//     required this.screenWidth,
//     required this.textTheme,
//   });

//   final double screenHeight;
//   final double screenWidth;
//   final TextTheme textTheme;

//   @override
//   State<TestHistory> createState() => _TestHistoryState();
// }

// class _TestHistoryState extends State<TestHistory> {
//   double i = 0;
//   final LoadPresensi _load = LoadPresensi();
//   // List<String> names = [];

//   final List<dataPresensi> _presensi = [];

//   void loadPresensi() async {
//     await _load.fetchJson().then((value) {
//       setState(() {
//         _presensi.addAll(value);
//       });
//     });
//   }

//   @override
//   void initState() {
//     loadPresensi();
//     super.initState;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     // String riwayat;
//     // String _color;
//     // print(_presensi[1].waktuMasuk.toString());
//     return Container(
//       //card utk riwayat presensi dan bg biru
//       height: widget.screenHeight / 1.9,
//       width: widget.screenWidth,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 20,
//       ),
//       decoration: BoxDecoration(
//         color: Styles.darkBlueColor,
//         borderRadius: const BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//       child: Container(
//         // margin: const EdgeInsets.only(left: 10, right: 10),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.only(top: 8, bottom: 8),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Riwayat PRESENSIIIIIIIIIIIII",
//                     style: textTheme.labelMedium,
//                   ),
//                 ],
//               ),
//               const Gap(10),
//               ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: const ScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: widget.screenHeight / 9,
//                           margin: const EdgeInsets.all(7),
//                           decoration: BoxDecoration(
//                             color: Styles.greyblueColor,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(10),
//                             ),
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 8,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     _hariTanggal(index),
//                                     //     "TERLAMBAT 5 MENIT", Styles.redColor),
//                                     // _statusAbsen(
//                                     _statusAbsen(index),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         // mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           _jenisAbsen("Absen Masuk"),
//                                           const Gap(4),
//                                           Text(
//                                             textAlign: TextAlign.center,
//                                             _presensi[index].waktuMasuk,
//                                             style: TextStyle(
//                                               fontFamily: "Montserrat-Bold",
//                                               color: Styles.textBlack,
//                                               fontSize: widget.screenWidth / 15,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           _jenisAbsen("Absen Pulang"),
//                                           const Gap(4),
//                                           Text(
//                                             textAlign: TextAlign.center,
//                                             _presensi[index].waktuPulang,
//                                             style: TextStyle(
//                                               fontFamily: "Montserrat-Bold",
//                                               color: Styles.textBlack,
//                                               fontSize: widget.screenWidth / 15,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: _presensi.length,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   RoundedBackgroundText _statusAbsen(int index) {
//     if (_presensi[index].status == 'red') {
//       return RoundedBackgroundText(
//         //notif terlambat/ontime
//         _presensi[index].ket,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontFamily: "Montserrat-Bold",
//           fontSize: 8,
//         ),
//         backgroundColor: Styles.redColor,
//         innerRadius: 0,
//         outerRadius: 0,
//       );
//     } else {
//       return RoundedBackgroundText(
//         //notif terlambat/ontime
//         _presensi[index].ket,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontFamily: "Montserrat-Bold",
//           fontSize: 8,
//         ),
//         backgroundColor: Styles.greenColor,
//         innerRadius: 0,
//         outerRadius: 0,
//       );
//     }
//   }

//   RichText _hariTanggal(int index) {
//     return RichText(
//       softWrap: true,
//       maxLines: 1,
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         text: _presensi[index].tanggal,
//         style: TextStyle(
//           color: Styles.textBlack,
//           fontFamily: "Montserrat-SemiBold",
//           fontSize: 12,
//         ),
//       ),
//     );
//   }

//   RoundedBackgroundText _jenisAbsen(String statusAbsen) {
//     return RoundedBackgroundText(
//       //notif terlambat/ontime
//       statusAbsen,
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontFamily: "Montserrat-Regular",
//         fontSize: 8,
//       ),
//       backgroundColor: Styles.lightYellowColor,
//       innerRadius: 0,
//       outerRadius: 0,
//     );
//   }
// }
