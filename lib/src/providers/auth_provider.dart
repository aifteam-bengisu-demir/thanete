import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  Future<void> login(String email) async {
    _loggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _loggedIn = false;
    notifyListeners();
  }
}
