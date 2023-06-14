import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Constants.dart';

class updateBySerialController {
  static Future<void> updateBin(
    List<String> oldBin,
    String newBin,
    String serialNo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url =
        '${Constants.baseUrl}updateMappedBarcodesBinLocationBySerialNo';

    print("url : $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "oldBinLocation": oldBin[0],
      "newBinLocation": newBin,
      "serialNumber": serialNo
    });

    print("body : $body");

    try {
      var response = await http.put(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception("Failded to update bin");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
