import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Provider/usrdata_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Mobile/mobile_captcha_screen.dart';
import 'package:exins/Views/Web/captcha_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);

  String uid = const Uuid().v4();

  UsrDataProvider usr = UsrDataProvider();

  @override
  Widget build(BuildContext context) {
    Provider.of<UidProvider>(context, listen: false).setUidProvider(uid);
    usr.updateUserdata(uid);

    return const Material(
      child: ResponsiveLayout(
        desktopBody: CaptchaScreen(),
        mobileBody: MobileCaptchaScreen(),
        tabletBody: MobileCaptchaScreen(),
      ),
    );
  }
}
