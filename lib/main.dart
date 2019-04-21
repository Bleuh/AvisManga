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
        primaryColor:themeColor,
        primaryTextTheme: themeText,
        buttonTheme: themeButton
      ),
      routes: routes,
      initialRoute: "/",
    );
  }
}

const MaterialColor themeColor = const MaterialColor(
  0xFF283593,
  const <int, Color>{
    50 : const Color(0xFFF5E9FF),
    100: const Color(0xFF9E96FF),
    200: const Color(0xFF817DE6),
    300: const Color(0xFF6564CA),
    400: const Color(0xFF484CAE),
    500: const Color(0xFF283593),
    600: const Color(0xFF002079),
    700: const Color(0xFF000D5F),
    800: const Color(0xFF000047),
    900: const Color(0xFF00042F),
  }
);

const TextTheme themeText = const TextTheme(
  button: TextStyle(
    color: Colors.white
  ),
  headline: TextStyle(
    color: Colors.white,
    fontSize: 20.0
  )
);

const ButtonThemeData themeButton = const ButtonThemeData(
  splashColor: themeColor,
  shape: CircleBorder(),
);