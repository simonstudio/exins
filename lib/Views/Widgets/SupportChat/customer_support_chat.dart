import 'package:flutter/material.dart';

class CustomerSupportChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(height: 10.0),
          Text("Welcome to Customer Support"),
          SizedBox(height: 10.0),
          TextField(
            decoration: InputDecoration(hintText: "Ask us anything..."),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color(0xff1876F2),
                  elevation: 0,
                  fixedSize: const Size(120, 40)),
              child: const Text(
                "Send",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
