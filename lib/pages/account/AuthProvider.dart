import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/account.dart';

class AuthProvider with ChangeNotifier {
  Account? _currentAccount;
  String? _token;

  Account? get currentAccount => _currentAccount;
  String? get currentToken => _token;

  bool get isAdmin => _currentAccount?.role == 'admin';

  void login(Account account, String token) {
    _currentAccount = account;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _currentAccount = null;
    _token = null;
    notifyListeners();
  }
}
