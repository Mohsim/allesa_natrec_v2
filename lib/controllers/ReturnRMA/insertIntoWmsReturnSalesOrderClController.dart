import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import '../../utils/Constants.dart';

class insertIntoWmsReturnSalesOrderClController {
  static Future<void> getData(
    getMappedBarcodedsByItemCodeAndBinLocationModel
        updateWmsJournalMovementClQtyScannedList,
    String serialNo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url = "${Constants.baseUrl}insertIntoWmsReturnSalesOrderCl";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    var body = updateWmsJournalMovementClQtyScannedList;
    body.itemSerialNo = serialNo;

    print("Body: ${body.itemSerialNo.toString()}");

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode([body]));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
