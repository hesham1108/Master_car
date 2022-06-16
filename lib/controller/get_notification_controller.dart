import 'dart:convert';

import 'package:http/http.dart' as http;

class GetNotificationController {
  bool success = false;
  dynamic content;
  Future<void> getAllNotification() async {
    String url = 'http://mastercar.ddns.net:8891/api/Notifications/GetAll';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
        var jd = jsonDecode(response.body);
        content = jd;
      } else {
        success = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  bool countSuccess = false;
  dynamic notNum;
  Future<void> getCountNotification() async {
    String url = 'http://mastercar.ddns.net:8891/api/Notifications/GetCount';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        countSuccess = true;
        var jd = jsonDecode(response.body);
        notNum = jd[0]['count'];
      } else {
        countSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
