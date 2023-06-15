import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/getWmsJournalCountingOnlyCLByAssignedToUserIdModel.dart';
import '../../utils/Constants.dart';

class insertIntoWmsJournalCountingOnlyCLDetsController {
  static Future<void> getData(
    String CONFIGID,
    String BINLOCATION,
    String QTYSCANNED,
    String ITEMSERIALNO,
    List<getWmsJournalCountingOnlyCLByAssignedToUserIdModel> ITEM,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url = "${Constants.baseUrl}insertIntoWmsJournalCountingOnlyCLDets";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    final data = ITEM.map(
      (e) {
        return {
          ...e.toJson(),
          "CONFIGID": CONFIGID,
          "BINLOCATION": BINLOCATION,
          "QTYSCANNED": QTYSCANNED,
          "ITEMSERIALNO": ITEMSERIALNO,
        };
      },
    );

    print(jsonEncode([...data]));

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode([...data]));

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
