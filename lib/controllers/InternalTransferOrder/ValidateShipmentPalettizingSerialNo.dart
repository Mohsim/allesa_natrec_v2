import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateShipmentPalettizingSerialNoController {
  static Future<String> palletizeSerialNo(String serialNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url =
        "${Constants.baseUrl}vaildatehipmentPalletizingSerialNumber?ItemSerialNo=$serialNo";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    print(headers);

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        String palletizeSerialNo = data["message"];
        return palletizeSerialNo;
      } else {
        print("Status Code: ${response.statusCode}");

        String palletizeSerialNo = "SHIPMENTID does not match.";
        return palletizeSerialNo;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
