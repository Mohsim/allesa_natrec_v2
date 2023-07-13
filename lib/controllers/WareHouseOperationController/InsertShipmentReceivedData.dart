import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Constants.dart';

class InsertShipmentReceivedDataController {
  static Future<void> insertShipmentData(
    String SHIPMENTID,
    String CONTAINERID,
    String ARRIVALWAREHOUSE,
    String ITEMNAME,
    String ITEMID,
    String PURCHID,
    int CLASSIFICATION,
    String SERIALNUM,
    String RCVDCONFIGID,
    String RCVD_DATE,
    String GTIN,
    String RZONE,
    String PALLET_DATE,
    String PALLETCODE,
    String BIN,
    String REMARKS,
    int POQTY,
    double length,
    double width,
    double height,
    double weight,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url =
        "${Constants.baseUrl}insertShipmentRecievedDataCL?SHIPMENTID=$SHIPMENTID&CONTAINERID=$CONTAINERID&ARRIVALWAREHOUSE=$ARRIVALWAREHOUSE&ITEMNAME=$ITEMNAME&ITEMID=$ITEMID&PURCHID=$PURCHID&CLASSIFICATION=$CLASSIFICATION&SERIALNUM=$SERIALNUM&RCVDCONFIGID=$RCVDCONFIGID&RCVD_DATE=$RCVD_DATE&GTIN=$GTIN&RZONE=$RZONE&PALLET_DATE=$PALLET_DATE&PALLETCODE=$PALLETCODE&BIN=$BIN&REMARKS=$REMARKS&POQTY=$POQTY&LENGTH=$length&WIDTH=$width&HEIGHT=$height&WEIGHT=$weight";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": "$token",
      "Host": "${Constants.host}",
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
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
