import 'package:flutter/material.dart';

class Constants {
  static String baseUrl = 'http://gs1ksa.org:3005/api/';
  static String host = 'gs1ksa.org';

  // static String baseUrl = 'http://37.224.47.116:7474/api/';
  // static String host = '37.224.47.116:7474';

  static Future<dynamic> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.orange,
        ));
      },
    );
  }
}
