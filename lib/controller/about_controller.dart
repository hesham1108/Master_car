import 'dart:convert';

import 'package:http/http.dart' as http;

class AboutController {
  bool success = false;
  dynamic content = [];
  Future<void> getAboutContent() async {
    String url = 'http://mastercar.ddns.net:8891/api/AboutUS/GetInformations';
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
}
