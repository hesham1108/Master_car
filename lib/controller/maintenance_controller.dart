import 'dart:convert';
import 'package:http/http.dart' as http;

class MaintenanceController {
  bool allMaintenanceSuccess = false;
  bool nextMaintenanceSuccess = false;

  dynamic allMaintenance = [];
  dynamic nextMaintenance = [];

  // Future<void> getLastMaintenance(int customerId) async {
  //   String url =
  //       'http://mastercar.ddns.net:8891/api/Maintanence/LastMaintanence?customer_id=$customerId';
  //   try {
  //     final uri = Uri.parse(url);
  //     var response = await http.get(uri);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       maintenanceSuccess = true;
  //       var jd = jsonDecode(response.body);
  //
  //       maintenanceContent = jd;
  //       for (int i = 0; i < maintenanceContent.length; i++) {
  //         await getBillItems(jd[i]['id']);
  //       }
  //     } else {
  //       maintenanceSuccess = false;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> getBillItems(int billId) async {
  //   String url =
  //       'http://mastercar.ddns.net:8891/api/Maintanence/billItems?bill_id=$billId';
  //   try {
  //     final uri = Uri.parse(url);
  //     var response = await http.get(uri);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       BillItemsSuccess = true;
  //       var jd = jsonDecode(response.body);
  //       billItemsContent = jd;
  //     } else {
  //       BillItemsSuccess = false;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> getAllMaintenance(int customerId) async {
    String url =
        'http://mastercar.ddns.net:8891/api/Maintanence/AllMaintanence?customer_id=$customerId';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        allMaintenanceSuccess = true;
        var jd = jsonDecode(response.body);

        allMaintenance = jd;
      } else {
        allMaintenanceSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getNextMaintenance(int customerId) async {
    String url =
        'http://tabibsoft.ddns.net:8891/api/Maintanence/CommingMaintance?CustomerID=$customerId';
    try {
      final uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        nextMaintenanceSuccess = true;
        var jd = jsonDecode(response.body);

        nextMaintenance = jd;
      } else {
        nextMaintenanceSuccess = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
