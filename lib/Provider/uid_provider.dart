import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UidProvider with ChangeNotifier {
  String _uid = "";
  String get uid => _uid;


  void setUidProvider(String uid) {
    if (_uid.length < 5) {
      _uid = uid;
    }
  }
}
