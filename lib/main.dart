import 'package:flutter/material.dart';
import 'loading.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Avis Manga',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch:themeColor,
      ),
      home: new LoadingPage(),
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