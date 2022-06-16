import 'dart:convert';

import 'package:http/http.dart' as http;

class OffersController {
  bool allOffersSuccess = false;
  bool offersNumSuccess = false;
  bool reserveOfferSuccess = false;
  dynamic allOffersContent = [];
  dynamic offersNum;
  dynamic reservationProcess;
  static String errorMsg = '';
  Future<void> getAllOffers() async {
    String url = 'http://mastercar.ddns.net:8891/api/Offers/GetAll';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        allOffersSuccess = true;
        var jd = jsonDecode(response.body);
        allOffersContent = jd;
      } else {
        allOffersSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCountOffers() async {
    String url = 'http://mastercar.ddns.net:8891/api/Offers/GetCount';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        offersNumSuccess = true;
        var jd = jsonDecode(response.body);

        offersNum = jd[0]['Count'] ?? 0;
      } else {
        offersNumSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reserveOffer(int customerId, int offerId) async {
    String url =
        'http://mastercar.ddns.net:8891/api/Offers/ReserveOffer?customer_id=$customerId&offer_id=$offerId';
    try {
      final uri = Uri.parse(url);
      var response = await http.post(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        reserveOfferSuccess = true;
        var jd = jsonDecode(response.body);
        reservationProcess = jd['status'];

        errorMsg = jd['message'];
      } else {
        reserveOfferSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
