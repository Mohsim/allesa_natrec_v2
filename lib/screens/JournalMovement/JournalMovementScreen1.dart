import 'package:alessa_v2/screens/JournalMovement/JournalMovementScreen2.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/JournalMovement/getWmsJournalMovementClByAssignedToUserIdController.dart';
import '../../models/getWmsJournalMovementClByAssignedToUserIdModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../../../widgets/TextWidget.dart';

class JournalMovementScreen1 extends StatefulWidget {
  const JournalMovementScreen1({super.key});

  @override
  State<JournalMovementScreen1> createState() => _JournalMovementScreen1State();
}

class _JournalMovementScreen1State extends State<JournalMovementScreen1> {
  String total = "0";
  List<getWmsJournalMovementClByAssignedToUserIdModel>
      BinToBinJournalTableList = [];
  List<bool> isMarked = [];

  String userName = "";
  String userID = "";

  void _showUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? token = prefs.getString('token');
    final String? userId = prefs.getString('userId');
    final String? fullName = prefs.getString('fullName');
    // final String? userLevel = prefs.getString('userLevel');
    // final String? loc = prefs.getString('userLocation');

    setState(() {
      userName = fullName!;
      userID = userId!;
    });
  }

  @override
  void initState() {
    super.initState();
    _showUserInfo();
    getWmsJournalMovementClByAssignedToUserIdController.getData().then((value) {
      Constants.showLoadingDialog(context);
      setState(() {
        BinToBinJournalTableList = value;

        isMarked = List<bool>.generate(
            BinToBinJournalTableList.length, (index) => false);
        total = BinToBinJournalTableList.length.toString();
      });
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      Constants.showLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            autoImplyLeading: true,
            onPressed: () {
              Get.back();
            },
            title: "Journal Movement".toUpperCase(),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/delete.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current Logged in User Id: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        userID,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900]!,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: const TextWidget(
                    text: "Items*",
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showCheckboxColumn: false,
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.withOpacity(0.2)),
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.orange),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        border: TableBorder.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        columns: const [
                          DataColumn(
                              label: Text(
                            'ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'ITEM ID',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'ITEM NAME',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'QTY',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'LEDGER ACCOUNT ID OFFSET',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'JOURNAL ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'TRANS DATE',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'INVENT SITE ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'INVENT LOCATION ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'CONFIG ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'WMS LOCATION ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'TRX DATE TIME',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'TRX USER ID ASSIGNED',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'TRX USER ID ASSIGNED BY',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'ITEM SERIAL NO',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'QTY SCANNED',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'QTY DIFFERENCE',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        ],
                        rows: BinToBinJournalTableList.map((e) {
                          return DataRow(
                              onSelectChanged: (value) {
                                Get.to(() => JournalMovementScreen2(
                                      iTEMID: e.iTEMID.toString(),
                                      iTEMNAME: e.iTEMNAME.toString(),
                                      qTY: int.parse(e.qTY.toString()),
                                      lEDGERACCOUNTIDOFFSET:
                                          e.lEDGERACCOUNTIDOFFSET.toString(),
                                      jOURNALID: e.jOURNALID.toString(),
                                      tRANSDATE: e.tRANSDATE.toString(),
                                      iNVENTSITEID: e.iNVENTSITEID.toString(),
                                      iNVENTLOCATIONID:
                                          e.iNVENTLOCATIONID.toString(),
                                      cONFIGID: e.cONFIGID.toString(),
                                      wMSLOCATIONID: e.wMSLOCATIONID.toString(),
                                      tRXDATETIME: e.tRXDATETIME.toString(),
                                      tRXUSERIDASSIGNED:
                                          e.tRXUSERIDASSIGNED.toString(),
                                      tRXUSERIDASSIGNEDBY:
                                          e.tRXUSERIDASSIGNEDBY.toString(),
                                      iTEMSERIALNO:
                                          e.iTEMSERIALNO.toString() == "null"
                                              ? 0
                                              : int.parse(
                                                  e.iTEMSERIALNO.toString()),
                                      qTYSCANNED: e.qTYSCANNED.toString() ==
                                              "null"
                                          ? 0
                                          : int.parse(e.qTYSCANNED.toString()),
                                      qTYDIFFERENCE:
                                          e.qTYDIFFERENCE.toString() == "null"
                                              ? 0
                                              : int.parse(
                                                  e.qTYDIFFERENCE.toString()),
                                    ));
                              },
                              cells: [
                                DataCell(Text(
                                    (BinToBinJournalTableList.indexOf(e) + 1)
                                        .toString())),
                                DataCell(Text(e.iTEMID.toString())),
                                DataCell(Text(e.iTEMNAME.toString())),
                                DataCell(Text(e.qTY.toString())),
                                DataCell(
                                    Text(e.lEDGERACCOUNTIDOFFSET.toString())),
                                DataCell(Text(e.jOURNALID.toString())),
                                DataCell(Text(e.tRANSDATE.toString())),
                                DataCell(Text(e.iNVENTSITEID.toString())),
                                DataCell(Text(e.iNVENTLOCATIONID.toString())),
                                DataCell(Text(e.cONFIGID.toString())),
                                DataCell(Text(e.wMSLOCATIONID.toString())),
                                DataCell(Text(e.tRXDATETIME.toString())),
                                DataCell(Text(e.tRXUSERIDASSIGNED.toString())),
                                DataCell(
                                    Text(e.tRXUSERIDASSIGNEDBY.toString())),
                                DataCell(Row(
                                  children: [
                                    SelectableText(e.iTEMSERIALNO.toString()),
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: e.iTEMSERIALNO.toString()));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Copied ${e.iTEMSERIALNO.toString()}"),
                                        ));
                                      },
                                    ),
                                  ],
                                )),
                                DataCell(Text(e.qTYSCANNED.toString())),
                                DataCell(Text(e.qTYDIFFERENCE.toString())),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const TextWidget(text: "TOTAL"),
                    const SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextWidget(text: total),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
