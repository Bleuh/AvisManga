import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase {
  static final Firebase _singleton = new Firebase._internal();

  factory Firebase() {
    return _singleton;
  }

  Firebase._internal();

  call() {
    return new Future.delayed(new Duration(seconds: 5));
  }
}