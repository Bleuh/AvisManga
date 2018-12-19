import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginError extends Error {
  String message;
  Object cause;

  LoginError(this.message);

  LoginError.cause(this.message, this.cause);

  String toString() {
    String causeMsg;
    if (cause != null) {
      if (cause is PlatformException) {
        causeMsg = (cause as PlatformException).message;
        print(cause.toString());
      } else if (cause is NoSuchMethodError) {
        causeMsg = (cause as NoSuchMethodError).toString();
      }
    }
    if (causeMsg != null) {
      return "$message: $causeMsg";
    }
    return message;
  }
}