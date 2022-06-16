import 'dart:convert';

import 'package:http/http.dart' as http;

class AppointmentController {
  bool reservationSuccess = false;
  bool timesSuccess = false;
  dynamic content;
  dynamic times = [];
  bool emptyList = false;
  String msg = '';

  Future<void> reservation(int id, String date, String time) async {
    String url =
        'http://mastercar.ddns.net:8891/api/Reservations/AddReservation?customer_id=$id&date=$date&reservation_hour=$time';
    try {
      final uri = Uri.parse(url);
      var response = await http.post(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        reservationSuccess = true;
        var jd = jsonDecode(response.body);
        content = jd;
      } else {
        reservationSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> availableTimes(String date) async {
    String url =
        'http://mastercar.ddns.net:8891/api/Reservations/AvailableAppointment?Date=$date';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        timesSuccess = true;
        var jd = jsonDecode(response.body);
        times = jd;

        if (times.length == 0) {
          emptyList = true;
        } else {
          emptyList = false;
        }
      } else {
        timesSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
