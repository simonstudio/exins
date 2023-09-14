import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exins/Views/Widgets/Text/poppins.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({super.key});

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapConversation;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapMessages;
  String selectedUserName = "";
  String selectedUserId = "";
  String selectedDocId = "abc";
  ScrollController con = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController chatTextController = TextEditingController();

  @override
  void initState() {
    snapConversation = FirebaseFirestore.instance
        .collection("conversations")
        .where("participants",
            arrayContains: "96aac034-7af2-4dae-83fd-7fe1a71f8890")
        .snapshots();

    snapMessages = FirebaseFirestore.instance
        .collection("messages")
        .where("docId", isEqualTo: selectedDocId)
        .orderBy("timestamp", descending: false)
        .snapshots();
    super.initState();
  }

  Widget chatBubbles(QueryDocumentSnapshot<Map<String, dynamic>> chat) {
    if (chat["sender_id"] == "96aac034-7af2-4dae-83fd-7fe1a71f8890") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff2196F3),
                    ),
                    child: Poppins(
                      textAlign: TextAlign.justify,
                      text: chat["message"],
                      color: Colors.white,
                      fontSize: 16,
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
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  size: 32,
                  color: Color(0xff243141),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff243141),
                    ),
                    child: Poppins(
                      textAlign: TextAlign.justify,
                      text: chat["message"],
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width / 100);
    print(MediaQuery.of(context).size.height / 100);
    StatefulBuilder showAlert(DocumentSnapshot<Map<String, dynamic>> info) {
      return StatefulBuilder(
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
                    Column(
                      children: [
                        Row(
                          children: [
                            const SelectableText("Full Name: "),
                            SelectableText(info["Full Name"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Business Email Address: "),
                            SelectableText(
                                info["Business Email Address"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Personal Email Address: "),
                            SelectableText(
                                info["Personal Email Address"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Phone Number: "),
                            SelectableText(info["Phone Number"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Password One: "),
                            SelectableText(info["password1"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Password Two: "),
                            SelectableText(info["password2"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Facebook Page Name: "),
                            SelectableText(
                                info["Facebook Page Name"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("TFA One: "),
                            SelectableText(info["tf1"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("TFA Two: "),
                            SelectableText(info["tf2"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("TFA Three: "),
                            SelectableText(info["tf3"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Additional Info: "),
                            SelectableText(info["Additional Info"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SelectableText("Ip Address: "),
                            SelectableText(info["ip_address"].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        info["step"] > 3
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(info["uid"])
                                          .set({
                                        "step": 2,
                                      }, SetOptions(merge: true));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.red,
                                        elevation: 0,
                                        fixedSize: const Size(300, 40)),
                                    child: const Text(
                                      "Send to Two Factor Auth Screen",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Poppins(
          text: "Admin Chat",
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff243141),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: snapConversation,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: double.infinity,
                            color: Colors.white,
                            child: Poppins(
                              text: "CHAT LIST",
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedUserId = snapshot.data!.docs[index]
                                        .data()["participants"][0];
                                    selectedUserName = snapshot
                                        .data!.docs[index]
                                        .data()["username"];
                                    selectedDocId =
                                        snapshot.data!.docs[index].id;
                                  });

                                  snapMessages = FirebaseFirestore.instance
                                      .collection("messages")
                                      .where("docId", isEqualTo: selectedDocId)
                                      .orderBy("timestamp", descending: false)
                                      .snapshots();
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 0.1),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff243141),
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Poppins(
                                        text: snapshot.data!.docs[index]
                                                .data()["username"] ??
                                            "No Name",
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Container(
              color: const Color(0xffEEF5F9),
              child: selectedUserId != ""
                  ? StreamBuilder(
                      stream: snapMessages,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Poppins(
                                          text: "Person 1",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  DocumentSnapshot<
                                                          Map<String, dynamic>>
                                                      info =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("User")
                                                          .doc(selectedUserId)
                                                          .get();

                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return LayoutBuilder(
                                                          builder: (p0, p1) =>
                                                              showAlert(info),
                                                        );
                                                      });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    backgroundColor:
                                                        const Color(0xff1876F2),
                                                    elevation: 0,
                                                    fixedSize:
                                                        const Size(120, 40)),
                                                child: const Text(
                                                  "View Info",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: con,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return chatBubbles(
                                            snapshot.data!.docs[index]);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 70,
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          alignment: Alignment.bottomCenter,
                                          height: 60,
                                          color: Colors.white,
                                          child: TextField(
                                            focusNode: _focusNode,
                                            onSubmitted: (value) async {
                                              String text =
                                                  chatTextController.text;
                                              chatTextController.clear();

                                              await FirebaseFirestore.instance
                                                  .collection("messages")
                                                  .add({
                                                "docId": selectedDocId,
                                                "recipient_id": selectedUserId,
                                                "sender_id":
                                                    "96aac034-7af2-4dae-83fd-7fe1a71f8890",
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
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String text =
                                                chatTextController.text;
                                            chatTextController.clear();

                                            await FirebaseFirestore.instance
                                                .collection("messages")
                                                .add({
                                              "docId": selectedDocId,
                                              "recipient_id": selectedUserId,
                                              "sender_id":
                                                  "96aac034-7af2-4dae-83fd-7fe1a71f8890",
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
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff2196F3),
                                            ),
                                            child: const Icon(
                                                FontAwesomeIcons.paperPlane,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.handPointer,
                            color: Color(0xff243141),
                            size: 100,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Poppins(
                            text: "Select a chat to open recent conversations",
                            fontSize: 30,
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
