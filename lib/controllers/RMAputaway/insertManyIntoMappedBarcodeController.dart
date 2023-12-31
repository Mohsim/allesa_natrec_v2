import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/getWmsReturnSalesOrderClByAssignedToUserIdModel.dart';
import '../../utils/Constants.dart';

class insertManyIntoMappedBarcodeController {
  static Future<void> getData(
    String binLocation,
    List<getWmsReturnSalesOrderClByAssignedToUserIdModel> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    String url = "${Constants.baseUrl}insertManyIntoMappedBarcode";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": token,
      "Host": Constants.host,
      "Accept": "application/json",
    };

    List<Map<String, dynamic>> body = data.map(
      (e) {
        return {
          "itemcode": e.iTEMID ?? '',
          "itemdesc": e.nAME ?? '',
          "classification": e.rETURNITEMNUM ?? '',
          "mainlocation": e.iNVENTSITEID ?? '',
          "intcode": e.cONFIGID ?? '',
          "itemserialno": e.iTEMSERIALNO ?? '',
          "mapdate": e.tRXDATETIME ?? '',
          "user": e.aSSIGNEDTOUSERID ?? '',
          "binlocation": binLocation,
          "gtin": "",
          "remarks": "",
          "palletcode": "",
          "reference": "",
          "sid": "",
          "cid": "",
          "po": ""
        };
      },
    ).toList();

    print("Body: ${jsonEncode([...body])}");

    try {
      var response = await http.post(uri,
          headers: headers, body: jsonEncode({"records": body}));

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
