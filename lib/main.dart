import 'package:exins/Provider/appdata_provider.dart';
import 'package:exins/Provider/captcha_provider.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Provider/usrdata_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Admin/admin_home.dart';
import 'package:exins/Views/Mobile/mobile_tfa.dart';
import 'package:exins/Views/Web/splash.dart';
import 'package:exins/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseAnalytics.instance.app = app;
  runApp(const IcoolFB());
}

class IcoolFB extends StatelessWidget {
  const IcoolFB({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UidProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()),
        ChangeNotifierProvider(create: (_) => UsrDataProvider()),
        ChangeNotifierProvider(create: (_) => CaptchaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Meta for Business",
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the HomeScreen widget.
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/adm': (context) => AdminChat(),
        },
        home: Homepage(),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AppDataProvider>(context, listen: false).updateAppdata();
    return ResponsiveLayout(
      desktopBody: Splash(),
      mobileBody: Splash(),
      tabletBody: Splash(),
    );


  }
}
