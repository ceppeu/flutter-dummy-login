import 'dart:convert';

import 'package:form_validation/src/shared_prefs/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _firebaseToken = 'AIzaSyBTi0B5OYUNOfZQJtE2Z9fDdRGHumoVgwg';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken';
    final res = await http.post(url, body: json.encode(authData));
    Map<String, dynamic> decodedRes = json.decode(res.body);
    if (decodedRes.containsKey('idToken')) {
      _prefs.token = decodedRes['idToken'];
      return {'ok': true, 'token': decodedRes['idToken']};
    }
    return {'ok': false, 'mensaje': decodedRes['error']['message']};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';
    final res = await http.post(url, body: json.encode(authData));
    Map<String, dynamic> decodedRes = json.decode(res.body);
    if (decodedRes.containsKey('idToken')) {
      _prefs.token = decodedRes['idToken'];
      return {'ok': true, 'token': decodedRes['idToken']};
    }
    return {'ok': false, 'mensaje': decodedRes['error']['message']};
  }
}
