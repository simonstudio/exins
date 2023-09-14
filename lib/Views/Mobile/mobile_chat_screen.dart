import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exins/Provider/uid_provider.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MobileChatScreen extends StatefulWidget {
  final Map dataMap;

  const MobileChatScreen({super.key, required this.dataMap});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  late String uid;

  late Stream<QuerySnapshot<Map<String, dynamic>>> snap2;
  late QuerySnapshot<Map<String, dynamic>> query;
  TextEditingController chatTextController = TextEditingController();
  late String docId;
  ScrollController con = ScrollController();
  FocusNode _focusNode = FocusNode();
  bool isMessaging = false;

  _asyncMethod() async {
    query = await FirebaseFirestore.instance
        .collection("conversations")
        .where("participants",
            arrayContains: "96aac034-7af2-4dae-83fd-7fe1a71f8890")
        .where("clientId", isEqualTo: uid)
        .get();

    if (query.docs.isEmpty) {
      await FirebaseFirestore.instance.collection("conversations").add({
        "clientId": uid,
        "participants": [uid, "96aac034-7af2-4dae-83fd-7fe1a71f8890"],
        "username": widget.dataMap["Full Name"],
        "timestamp": FieldValue.serverTimestamp()
      });

      query = await FirebaseFirestore.instance
          .collection("conversations")
          .where("participants",
              arrayContains: "96aac034-7af2-4dae-83fd-7fe1a71f8890")
          .where("clientId", isEqualTo: uid)
          .get();

      snap2 = FirebaseFirestore.instance
          .collection("messages")
          .where("docId", isEqualTo: query.docs[0].id)
          .orderBy("timestamp", descending: false)
          .snapshots();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _asyncMethod();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uid = Provider.of<UidProvider>(context).uid;

    return Scaffold(
      body: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                shape: BoxShape.circle, color: Colors.blue),
                            child: SvgPicture.asset("assets/images/metav2.svg"),
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
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
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
                                borderRadius: BorderRadius.circular(10),
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
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.docs[index]["sender_id"] ==
                                  uid) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: 350 * 0.8,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xff0084FF),
                                              ),
                                              child: Poppins(
                                                textAlign: TextAlign.justify,
                                                text: snapshot.data!.docs[index]
                                                    ["message"],
                                                color: Colors.white,
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
                              } else if (snapshot.data!.docs[index]
                                      ["sender_id"] !=
                                  uid) {
                                return Padding(
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
                                                text: snapshot.data!.docs[index]
                                                    ["message"],
                                                color: Colors.white,
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
                            "timestamp": FieldValue.serverTimestamp()
                          });

                          con.animateTo(
                            con.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );

                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        controller: chatTextController,
                        decoration: const InputDecoration(
                          fillColor: Color(0xffEBEDF0),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
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
                            "timestamp": FieldValue.serverTimestamp()
                          });

                          con.animateTo(
                            con.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );

                          FocusScope.of(context).requestFocus(_focusNode);
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
    );
  }
}
