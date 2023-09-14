import 'package:exins/Provider/captcha_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HumanRecaptcha extends StatefulWidget {
  HumanRecaptcha({
    Key? key,
    required this.ishovered,
  }) : super(key: key);

  final bool ishovered;

  @override
  State<HumanRecaptcha> createState() => _HumanRecaptchaState();
}

class _HumanRecaptchaState extends State<HumanRecaptcha> {
  bool isBeating = false;

  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
            color:
                widget.ishovered ? Colors.grey.shade400 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
        color: widget.ishovered
            ? const Color.fromARGB(255, 226, 226, 226)
            : const Color.fromARGB(255, 243, 243, 243),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 20,
              ),
              !isBeating
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isBeating = true;
                        });
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            Provider.of<CaptchaProvider>(context, listen: false)
                                .setUidProvider(true);
                            setState(() {
                              isVerified = true;
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: !widget.ishovered
                                  ? Colors.grey.shade600
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )
                  : !isVerified
                      ? LoadingAnimationWidget.beat(
                          color: Colors.orange,
                          size: 25,
                        )
                      : const Icon(FontAwesomeIcons.check,
                          color: Colors.green, size: 30),
              const SizedBox(
                width: 10,
              ),
              Text(
                "I am human",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset("assets/images/hcaptcha2.png"),
                  ),
                  const Text(
                    "hCaptcha",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
