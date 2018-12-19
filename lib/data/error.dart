class LoginError extends Error {
  String message;
  Object cause;

  LoginError(this.message);

  LoginError.cause(this.message, this.cause);

  String toString() {
    if (cause != null) {
      return "$message: $cause";
    }
    return message;
  }
}