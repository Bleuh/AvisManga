import 'package:flutter/material.dart';

import 'package:avis_manga/views/home.dart';
import 'package:avis_manga/views/loading.dart';
import 'package:avis_manga/views/login.1.dart';

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/home':  (BuildContext context) => new HomePage(),
  '/':      (BuildContext context) => new LoadingPage(),
};