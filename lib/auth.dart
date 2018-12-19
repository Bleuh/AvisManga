import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthListener {
  void onLoginSuccess(User user);
  void onLoginError(LoginError error);
  void onLogout();
}

class Auth {
  static final Auth _instance = new Auth.internal();

  static final Database db = Database.instance;
  static SharedPreferences prefs;

  User currentUser;
  String userId;
  bool logged = false;
  bool inited = false;

  List<AuthListener> _subscribers;

  Auth.internal() {
    _subscribers = new List<AuthListener>();
  }

  static Future<Auth> get instance async {
    if (_instance.inited) {
      return _instance;
    }
    _instance.inited = true;
    return SharedPreferences.getInstance()
        .then((SharedPreferences preferences) {
      prefs = preferences;
      _instance.initState();
    }).then((_) => _instance);
  }

  void initState() {
    logged = false;
    userId = prefs.getString('userId');

    if (currentUser != null && currentUser.uid == userId) {
      logged = true;
    } else if (userId != null) {
      currentUser = new User(userId);
      logged = true;
    }
  }

  void subscribe(AuthListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notifyLogin(User user) {
    print("Notifying login to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) => s.onLoginSuccess(user));
  }

  void notifyLoginError(LoginError error) {
    print("Notifying login error to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) => s.onLoginError(error));
  }

  void notifyLogout() {
    print("Notifying logout to " + _subscribers.length.toString());
    _subscribers.forEach((AuthListener s) => s.onLogout());
  }

  bool isLogged() {
    return logged;
  }

  void doSignUp(String email, String password) {
    print("TODO SIGN UP");
  }

  void _loggedUser(User user) {
    currentUser = user;
    prefs.setString('userId', user.uid);
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
      prefs.remove('userId');
      this.notifyLogout();
    });
  }
}
