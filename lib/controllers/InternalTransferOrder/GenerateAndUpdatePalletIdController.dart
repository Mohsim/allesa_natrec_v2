import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Constants.dart';

class GenerateAndUpdatePalletIdController {
  static Future<String> generateAndUpdatePalletId(
      List<String> serialNoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    List<String> serialNoListt = [];
    for (var i = 0; i < serialNoList.length; i++) {
      serialNoListt.add("serialNumberList[]=${serialNoList[i]}");
    }

    // convert list to one string
    String serialNoListString = serialNoListt.join("&");

    print(serialNoListString);

    String url =
        "${Constants.baseUrl}generateAndUpdatePalletIds?$serialNoListString}";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        String message = data["message"];
        return message;
      } else {
        var data = json.decode(response.body);
        String message = data["message"];
        return message;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
