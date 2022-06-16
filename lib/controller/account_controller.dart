import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

class AccountController {
  static int userId = -1;
  static String userMobile = '';
  bool success = false;
  dynamic content = [];

  Future<void> login(String username, String password) async {
    String url =
        "http://mastercar.ddns.net:8891/api/Login/check_login?user_name=$username&password=$password";
    final key = await FirebaseMessaging.instance.getToken();
    try {
      final uri = Uri.parse(url);

      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jd = jsonDecode(response.body);

        if (jd.length == 0) {
          success = false;
        } else {
          success = true;
          content = jd;
          userId = jd[0]['id'];
          userMobile = jd[0]['mobile'];
        }
        await sendKey(jd[0]['id'], key);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendKey(id, key) async {
    String url =
        "http://mastercar.ddns.net:8891/api/Login/SetKey?customer_id=$id&key=$key";
    final uri = Uri.parse(url);

    try {
      await http.post(uri);
    } catch (e) {
      rethrow;
    }
  }
}
