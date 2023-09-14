import 'package:exins/Provider/captcha_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Mobile/mobile_get_started.dart';
import 'package:exins/Views/Web/get_started.dart';
import 'package:exins/Views/Widgets/human_recaptcha.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
class CaptchaScreen extends StatefulWidget {
  const CaptchaScreen({super.key});

  @override
  State<CaptchaScreen> createState() => _CaptchaScreenState();
}

class _CaptchaScreenState extends State<CaptchaScreen> {
  bool ishovered = false;
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    isVerified = Provider.of<CaptchaProvider>(context, listen: true).isVerified;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 310,
                        color: const Color(0xffF9F2EF),
                        child: Image.asset("assets/images/captcha.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        child: Image.asset(
                          "assets/images/meta.png",
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Security Check",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Meta uses security tests to ensure that the people on the site are real. Please fill the security check below to continue further.",
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            ishovered = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            ishovered = false;
                          });
                        },
                        child: HumanRecaptcha(ishovered: ishovered),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color(0xff1876F2),
                              elevation: 0,
                              fixedSize: const Size(120, 40)),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: isVerified
                              ? () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ResponsiveLayout(
                                        desktopBody: GetStarted(),
                                        mobileBody: MobileGetStarted(),
                                        tabletBody: MobileGetStarted(),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
