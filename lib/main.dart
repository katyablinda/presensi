import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sihadir_app/pages/login_pages.dart';
import 'package:sihadir_app/pages/main_page.dart';
import 'package:sihadir_app/utils.dart/app_styles.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Styles.themeData();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        defaultScale: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Presensi ITP',
      theme: theme,

      home: const KeyboardVisibilityProvider(
        child: LoginPage(),
      ),
      // routes: {
      //   LoginPage.nameRoute: (context) => const LoginPage(),
      //   MainPage.nameRoute: (context) => const MainPage(),
      // },
      // home: const LoginPage(),
    );
  }
}
