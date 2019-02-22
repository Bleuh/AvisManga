import 'package:flutter/material.dart';

import 'package:avis_manga/views/home.dart';
import 'package:avis_manga/views/loading.dart';
import 'package:avis_manga/views/login.dart';
import 'package:avis_manga/views/edit.dart';

final routes = {
  '/edit':  (BuildContext context) => new EditPage(),
  '/login': (BuildContext context) => new LoginPage(),
  '/home':  (BuildContext context) => new HomePage(),
  '/':      (BuildContext context) => new LoadingPage(),
};