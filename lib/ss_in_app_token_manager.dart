import 'package:flutter/material.dart';

class SSInAppTokenManager {
  static final SSInAppTokenManager instance = SSInAppTokenManager._internal();
  List<String> _token = [];

  SSInAppTokenManager._internal();

  void setToken(List<String> token) {
    _token = token;
  }

  List<String> getToken() {
    return _token;
  }

  List<String> getEncodedToken() {
    return _urlEncodedToken(_token);
  }

  // URL encode function for tokens
  List<String> _urlEncodedToken(List<String> tokens) {
    return tokens.map((token) => Uri.encodeComponent(token)).toList();
  }
}
