import 'package:avis_manga/data/db.dart';
import 'package:avis_manga/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthAction { ON_LOGIN, ON_ERROR }

abstract class AuthListener {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class Auth {
  static final Auth _instance = new Auth.internal();

  static final Database db = Database.instance;
  static SharedPreferences prefs;

  User currentUser;
  String userId;
  bool logged = false;

  List<AuthListener> _subscribers;

  static get instance => _instance;

  Auth.internal() {
    _subscribers = new List<AuthListener>();
    SharedPreferences.getInstance().then((SharedPreferences preferences) {
      prefs = preferences;
      initState();
    });
  }

  static Future<Auth> getInstance() async
  {
    return _instance;
  }

  void initState() {
    logged = false;
    userId = prefs.get('userId');

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
    for(var l in _subscribers) {
      if(l == listener)
         _subscribers.remove(l);
    }
  }

  void notifyLogin(User user) {
    _subscribers.forEach((AuthListener s) => s.onLoginSuccess(user));
  }

  void notifyLoginError(String error) {
    _subscribers.forEach((AuthListener s) => s.onLoginError(error));
  }

  bool isLogged() {
    return logged;
  }

  void doLogin(String email, String password, ) {
    db.emailSignIn(email, password).then((User user) {
      currentUser = user;
      prefs.setString('userId', user.uid);
      logged = true;
      this.notifyLogin(user);
    }).catchError((Exception error) => this.notifyLoginError(error.toString()));
  }
}