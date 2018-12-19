import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/data/error.dart';
import 'package:avis_manga/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthListener {
  void onLoginSuccess(User user);
  void onLoginError(LoginError error);
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

    // if (currentUser != null && currentUser.uid == userId) {
    //   logged = true;
    // } else if (userId != null) {
    //   currentUser = new User(userId);
    //   logged = true;
    // }
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
    _subscribers.forEach((AuthListener s) => s.onLoginSuccess(user));
  }

  void notifyLoginError(LoginError error) {
    _subscribers.forEach((AuthListener s) => s.onLoginError(error));
  }

  bool isLogged() {
    return logged;
  }

  void doLogin(String email, String password) {
    db.emailSignIn(email, password).then((User user) {
      currentUser = user;
      prefs.setString('userId', user.uid);
      logged = true;
      this.notifyLogin(user);
    }).catchError((err) => this.notifyLoginError(
        LoginError.cause("email sign in failed", err.toString())));
  }
}
