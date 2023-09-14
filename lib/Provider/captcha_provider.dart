import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CaptchaProvider with ChangeNotifier {
  bool _isVerified = false;
  bool get isVerified => _isVerified;

  void setUidProvider(bool captcha) {
    _isVerified = captcha;
    notifyListeners();
  }
}
