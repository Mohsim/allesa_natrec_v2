import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../utils/Constants.dart';

class getAllTblShipmentReceivedCLController {
  static Future<int> getAllTableZone(
    String POQTY,
    String SHIPMENTID,
    String ITEMID,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    print("POQTY: $POQTY");
    print("SHIPMENTID: $SHIPMENTID");
    print("ITEMID: $ITEMID");

    String url =
        "${Constants.baseUrl}getShipmentRecievedClCountByPoqtyShipmentIdAndItemId?POQTY=$POQTY&SHIPMENTID=$SHIPMENTID&ITEMID=$ITEMID";

    print("URL: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        var itemCount = data['itemCount'];
        return itemCount;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var message = data['message'];
        return message;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
