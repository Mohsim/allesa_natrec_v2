import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../utils/Constants.dart';

class InsertDispatchingController {
  static Future<void> insertData(
    List<Map<String, Object?>> data,
    String vehicleBarcodeNo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url = "${Constants.baseUrl}insertTblDispatchingDataCL";

    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var body = data.map((e) {
      return {...e, "VEHICLESHIPPLATENUMBER": vehicleBarcodeNo};
    }).toList();

    print(body);

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        print(data);
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        print(data);
        String msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
