import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

import '../../module/home/home_check_token.dart';
import '../../services/data_presensi.dart';
import '../../services/load_presensi.dart';
import '../../utils.dart/app_styles.dart';

//INI DIPAKAI
class RiwayatPresensi extends StatefulWidget {
  const RiwayatPresensi({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.textTheme,
  });

  final double screenHeight;
  final double screenWidth;
  final TextTheme textTheme;

  @override
  State<RiwayatPresensi> createState() => _RiwayatPresensiState();
}

class _RiwayatPresensiState extends State<RiwayatPresensi> {
  double i = 0;
  final LoadPresensi _load = LoadPresensi();

  final CheckToken _simpanPresensi = CheckToken();
  final List<dataPresensi> _presensi = [];
  final CheckToken _checktoken = CheckToken();

  void loadPresensi() {
    _presensi.clear();
    _load.fetchJson().then((value) {
      setState(() {
        _presensi.addAll(value);
      });
    });
  }

  @override
  void initState() {
    loadPresensi();
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // String riwayat;
    // String _color;
    // print(_presensi[1].waktuMasuk.toString());
    return Container(
      //card utk riwayat presensi dan bg biru
      height: widget.screenHeight / 1.9,
      width: widget.screenWidth,
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
                    "Riwayat Presensi Bener",
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
                          height: widget.screenHeight / 9,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              fontFamily: "Montserrat-Bold",
                                              color: Styles.textBlack,
                                              fontSize: widget.screenWidth / 15,
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
                                            _presensi[index].waktuPulang,
                                            style: TextStyle(
                                              fontFamily: "Montserrat-Bold",
                                              color: Styles.textBlack,
                                              fontSize: widget.screenWidth / 15,
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
