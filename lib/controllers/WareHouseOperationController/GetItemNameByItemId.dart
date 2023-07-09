import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../utils/Constants.dart';

class GetItemNameByItemIdController {
  static Future<String> getName(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url = "${Constants.baseUrl}InventTableWMSDataByItemId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
      "itemId": itemId,
    };

    print(headers);

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        var itemName = data[0]['ITEMNAME'];
        return itemName;
      } else {
        print("Status Code: ${response.statusCode}");
        var itemName = "";
        return itemName;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
