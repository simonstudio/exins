import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Config {
  var TELEGRAM_BOT =
      "NjQzODExMDQ0MTpBQUZDWlBMOXc1aldHSkJkS3dxTXBEc1BadkhmNHZUOGpxUQ==";
  var TELEGRAM_ROOM = "LTQwNDE3NTgwNzU=";
  var telegramUrl = 'https://api.telegram.org';

  test() {
    // String credentials = "username:password";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // final encoded_bot = stringToBase64.encode(TELEGRAM_BOT);
    // final encoded_room = stringToBase64.encode(TELEGRAM_ROOM);

    // debugPrint(encoded_bot);
    // debugPrint(encoded_room);

    final decrypted_bot = stringToBase64.decode(TELEGRAM_BOT);
    final decrypted_room = stringToBase64.decode(TELEGRAM_ROOM);

    debugPrint(decrypted_bot);
    debugPrint(decrypted_room);
  }

  sendTele(String content) {
    const HtmlEscape htmlEscape = HtmlEscape();
    String escaped = htmlEscape.convert(content);

    String escapedMsg = escaped
        .replaceAll("_", "\\_")
        .replaceAll("*", "\\*")
        .replaceAll("[", "\\[")
        .replaceAll("`", "\\`")
        .replaceAll("}", "\\}")
        .replaceAll("{", "\\{");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var url =
        '$telegramUrl/bot${stringToBase64.decode(TELEGRAM_BOT)}/sendMessage?parse_mode=MarkdownV2&chat_id=${stringToBase64.decode(TELEGRAM_ROOM)}&text=$escapedMsg';
    debugPrint(url);

    // var params = {
    //   'chat_id': stringToBase64.decode(TELEGRAM_ROOM),
    //   'text': content,
    //   'parse_mode': 'MarkdownV2'
    // };
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };

    // debugPrint(jsonEncode(params));
    // print(params);
    http.get(Uri.parse(url));
  }
}
