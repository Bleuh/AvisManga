import 'package:flutter/material.dart';
import 'package:avis_manga/routes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Avis Manga',
      theme: new ThemeData(
        primarySwatch:themeColor,
      ),
      routes: routes,
      initialRoute: "/",
    );
  }
}

const MaterialColor themeColor = const MaterialColor(
  0xFF283593,
  const <int, Color>{
    50 : const Color(0xFF283593),
    100: const Color(0xFF283593),
    200: const Color(0xFF283593),
    300: const Color(0xFF283593),
    400: const Color(0xFF283593),
    500: const Color(0xFF283593),
    600: const Color(0xFF283593),
    700: const Color(0xFF283593),
    800: const Color(0xFF283593),
    900: const Color(0xFF283593),
  }
);