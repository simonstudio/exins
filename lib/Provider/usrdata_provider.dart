import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UsrDataProvider extends ChangeNotifier {
  DocumentSnapshot<Map<String, dynamic>>? _usrdata;

  DocumentSnapshot<Map<String, dynamic>>? get usrdata => _usrdata;

  updateUserdata(String uid) async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> usrdatassss =
        FirebaseFirestore.instance.collection("User").doc(uid).snapshots();

    DocumentSnapshot<Map<String, dynamic>>? test;

    usrdatassss.listen((event) {
      dynamic f = event;
      _usrdata = f;
      test = _usrdata;
      notifyListeners();
    });

    _usrdata = test;

    notifyListeners();
  }
}
