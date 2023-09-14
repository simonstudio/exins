import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  DocumentSnapshot<Map<String, dynamic>>? _appdata;

  DocumentSnapshot<Map<String, dynamic>>? get appdata => _appdata;

  setAppData(DocumentSnapshot<Map<String, dynamic>> appdatasad) {
    if (_appdata == null) {
      _appdata = appdatasad;
      notifyListeners();
    }
  }

  updateAppdata() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> appDatassss =
        FirebaseFirestore.instance
            .collection("AppData")
            .doc("AppData")
            .snapshots();

    appDatassss.listen((event) {
      dynamic f = event;
      _appdata = f;
       notifyListeners();
    });
   
  }
}
