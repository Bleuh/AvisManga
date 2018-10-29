import 'package:flutter/material.dart';
import 'views/home.dart';
import 'views/loading.dart';

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
      home: new LoadingPage(bgColor: const Color(0xFFFF0000)),
    );
  }
}

const MaterialColor themeColor = const MaterialColor(
  0xFFFF0000,
  const <int, Color>{
    50 : const Color(0xFFFF0000),
    100: const Color(0xFFFF0000),
    200: const Color(0xFFFF0000),
    300: const Color(0xFFFF0000),
    400: const Color(0xFFFF0000),
    500: const Color(0xFFFF0000),
    600: const Color(0xFFFF0000),
    700: const Color(0xFFFF0000),
    800: const Color(0xFFFF0000),
    900: const Color(0xFFFF0000),
  }
);