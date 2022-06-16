import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationsController {
  dynamic reservations = [];
  bool reservationProcess = false;
  bool hasReservations = false;

  Future<void> getReservations(int customerId) async {
    String url =
        'http://mastercar.ddns.net:8891/api/Maintanence/FutureMaintance?CustomerID=$customerId';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        reservationProcess = true;
        var jd = jsonDecode(response.body);

        if (jd.length == 0) {
          hasReservations = false;
        } else {
          hasReservations = true;
          reservations = jd;
        }
      } else {
        reservationProcess = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
