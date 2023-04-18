import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../../utils.dart/app_styles.dart';

class ShowTime extends StatelessWidget {
  const ShowTime({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Container(
          //untuk stack warna biru di atas jam
          height: screenHeight / 9,
          color: Styles.darkBlueColor,
        ),
        Container(
          //untuk kotak jam
          margin: const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 25,
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),

          child: DigitalClock(
            showSecondsDigit: false,
            hourMinuteDigitTextStyle: TextStyle(
              fontFamily: "MomcakePro-Regular",
              fontWeight: FontWeight.w500,
              fontSize: screenHeight / 9,
              color: Styles.textBlack,
            ),
            colon: Text(
              ":",
              style: TextStyle(
                fontFamily: "MomcakePro-Regular",
                fontWeight: FontWeight.w500,
                fontSize: screenHeight / 9,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
