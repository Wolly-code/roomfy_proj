import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:roomfy_proj/exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userName;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userName;
  }

  String? get token {
    return _token;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/$urlSegment');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': email,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 400) {
        throw HttpException(responseData['error']['code']);
      }
      _token = responseData['token'];
      _userName = responseData['username'];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String username, String password) async {
    return _authenticate(username, password, 'signup');
  }

  Future<void> login(String username, String password) async {
    return _authenticate(username, password, 'login');
  }

  Future<void> logout() async {
    _token = null;
    _userName = null;
    notifyListeners();
  }
}
