import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthListener {
  String _uuid;
  final void Function(User user) onLoginSuccess;
  final void Function(LoginError err) onLoginError;
  final void Function() onLogout;

  AuthListener({this.onLoginSuccess, this.onLoginError, this.onLogout});
}

class Auth {
  static final Auth _instance = new Auth.internal();

  static final Database db = Database.instance;

  User currentUser;
  String userId;
  bool logged = false;
  bool inited = false;

  List<AuthListener> _subscribers;
  Uuid _uuid;

  Auth.internal() {
    _subscribers = new List<AuthListener>();
    _uuid = new Uuid();
  }

  static Future<Auth> get instance async {
    if (_instance.inited) {
      return _instance;
    }
    _instance.inited = true;
    return _instance.initState().then((_) => _instance);
  }

  Future<void> initState() async {
    logged = false;

    return db.currentUser().then((user) {
      if (user != null) {
        this.currentUser = user;
        this.logged = true;
      }
    });
  }

  void subscribe(AuthListener listener) {
    _subscribers.add(listener);
    listener._uuid = _uuid.v1();
  }

  void dispose(AuthListener listener) {
    _subscribers.remove(listener);
  }

  void notifyLogin(User user) {
    print("Notifying login to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) {
      if (s != null && s.onLoginSuccess != null) {
        s.onLoginSuccess(user);
      }
    });
  }

  void notifyLoginError(LoginError error) {
    print("Notifying login error to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) {
      if (s != null && s.onLoginError != null) {
        s.onLoginError(error);
      }
    });
  }

  void notifyLogout() {
    print("Notifying logout to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) {
      if (s != null && s.onLogout != null) {
        s.onLogout();
      }
    });
  }

  bool isLogged() {
    return logged;
  }

  void doSignUp(String email, String password) {
    print("TODO SIGN UP");
  }

  void _loggedUser(User user) {
    currentUser = user;
    logged = true;
    this.notifyLogin(user);
  }

  void doLogin(String email, String password) {
    db.emailSignIn(email, password).then((User user) {
      _loggedUser(user);
    }).catchError((err) =>
        this.notifyLoginError(LoginError.cause("Email sign in failed", err)));
  }

  void doGoogleLogin() {
    db.googleSignIn().then((User user) {
      _loggedUser(user);
    }).catchError((err) =>
        this.notifyLoginError(LoginError.cause("Google sign in failed", err)));
  }

  void doLogout() {
    db.signOut().then((_) {
      logged = false;
      this.notifyLogout();
    });
  }
}
