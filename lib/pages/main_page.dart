import 'package:flutter/material.dart';
import 'package:sihadir_app/pages/test_page.dart';
import 'package:sihadir_app/utils.dart/app_styles.dart';

import '../widgets/body/check_page.dart';
import 'check_page_salah.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const nameRoute = "/main";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> pages = [
    // const CheckLogPage(),
    SliderPresensi(),
    // const TestPage(),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      // body: pages[_selectedIndex],
      body: const SliderPresensi(),
      // bottomNavigationBar: _customBottomNav(),
    );
  }
}
