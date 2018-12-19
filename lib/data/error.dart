import 'package:flutter/services.dart';

class LoginError extends Error {
  String message;
  Exception cause;

  LoginError(this.message);

  LoginError.cause(this.message, this.cause);

  String toString() {
    String causeMsg;
    if (cause != null) {
      if (cause is PlatformException) {
        causeMsg = (cause as PlatformException).message;
      }
    }
    if (causeMsg != null) {
      return "$message: $causeMsg";
    }
    return message;
  }
}