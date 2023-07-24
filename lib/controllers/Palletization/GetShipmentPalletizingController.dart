import '../../models/GetTransferDistributionByTransferIdModel.dart';
import '../../utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GetShipmentPalletizingController {
  static Future<List<GetTransferDistributionByTransferIdModel>>
      getShipmentPalletizing(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url =
        "${Constants.baseUrl}getTransferDistributionByTransferId?TRANSFERID=$id";

    print("url: $url");

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

        var data = json.decode(response.body) as List;
        List<GetTransferDistributionByTransferIdModel> shipmentPalletizing =
            data
                .map(
                    (e) => GetTransferDistributionByTransferIdModel.fromJson(e))
                .toList();
        return shipmentPalletizing;
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
