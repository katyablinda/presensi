import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

import '../../utils.dart/app_styles.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({
    super.key,
    required this.employeeName,
    required this.jobTitle,
    required this.absenceStatus,
  });
  final String employeeName;
  final String jobTitle;
  final String absenceStatus;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Nama
            Text(
              employeeName,
              textAlign: TextAlign.left,
              style: textTheme.headlineMedium,
            ),
            //Divisi - Jabatan
            Text(
              jobTitle,
              textAlign: TextAlign.left,
              maxLines: 5,
              style: textTheme.headlineSmall,
            ),
            const Gap(5),
            //Notifikasi belum mengambil absen
            RoundedBackgroundText(
              absenceStatus,
              textAlign: TextAlign.left,
              style: textTheme.bodySmall,
              backgroundColor: Styles.whiteColor,
              innerRadius: 100,
              outerRadius: 100,
            ),
          ],
        )
      ],
    );
  }
}
