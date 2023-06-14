import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/getWmsJournalCountingOnlyCLByAssignedToUserIdModel.dart';
import '../../utils/Constants.dart';

class getWmsJournalCountingOnlyCLByBinLocationController {
  static Future<List<getWmsJournalCountingOnlyCLByAssignedToUserIdModel>>
      getData(String binLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url =
        "${Constants.baseUrl}getWmsJournalCountingOnlyCLByBinLocation?binloacation=$binLocation";
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
        List<getWmsJournalCountingOnlyCLByAssignedToUserIdModel> shipmentData =
            data
                .map((e) => getWmsJournalCountingOnlyCLByAssignedToUserIdModel
                    .fromJson(e))
                .toList();
        return shipmentData;
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
