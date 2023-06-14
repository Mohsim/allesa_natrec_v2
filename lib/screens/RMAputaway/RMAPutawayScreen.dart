import 'package:alessa_v2/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/RMAputaway/getWmsReturnSalesOrderClByAssignedToUserIdController.dart';
import '../../controllers/RMAputaway/insertManyIntoMappedBarcodeController.dart';
import '../../models/getWmsReturnSalesOrderClByAssignedToUserIdModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../../../widgets/TextWidget.dart';
import '../../widgets/ElevatedButtonWidget.dart';
import '../../widgets/TextFormField.dart';

class RMAPutawayScreen extends StatefulWidget {
  const RMAPutawayScreen({super.key});

  @override
  State<RMAPutawayScreen> createState() => _RMAPutawayScreenState();
}

class _RMAPutawayScreenState extends State<RMAPutawayScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _binLocationController = TextEditingController();
  String total = "0";
  List<getWmsReturnSalesOrderClByAssignedToUserIdModel>
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
    getWmsReturnSalesOrderClByAssignedToUserIdController
        .getData()
        .then((value) {
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
            title: "RMA  Put-Away".toUpperCase(),
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
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: const TextWidget(
                    text: "Items*",
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                            'EXPECTED RET QTY',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'SALES ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'RETURN ITEM NUM',
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
                            'TRX USER ID',
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
                            'ASSIGNED TO USER ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        ],
                        rows: BinToBinJournalTableList.map((e) {
                          return DataRow(onSelectChanged: (value) {}, cells: [
                            DataCell(Text(
                                (BinToBinJournalTableList.indexOf(e) + 1)
                                    .toString())),
                            DataCell(Text(e.iTEMID.toString())),
                            DataCell(Text(e.nAME.toString())),
                            DataCell(Text(e.eXPECTEDRETQTY.toString())),
                            DataCell(Text(e.sALESID.toString())),
                            DataCell(Text(e.rETURNITEMNUM.toString())),
                            DataCell(Text(e.iNVENTSITEID.toString())),
                            DataCell(Text(e.iNVENTLOCATIONID.toString())),
                            DataCell(Text(e.cONFIGID.toString())),
                            DataCell(Text(e.wMSLOCATIONID.toString())),
                            DataCell(Text(e.tRXDATETIME.toString())),
                            DataCell(Text(e.tRXUSERID.toString())),
                            DataCell(Text(e.iTEMSERIALNO.toString())),
                            DataCell(Text(e.aSSIGNEDTOUSERID.toString())),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
                  child: const TextWidget(
                    text: "Bin Location",
                    fontSize: 16,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    controller: _binLocationController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    hintText: "Enter/Scan Bin Location",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        const TextWidget(text: ""),
                        const SizedBox(height: 5),
                        ElevatedButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          title: "Save",
                          textColor: Colors.white,
                          color: Colors.orange,
                          onPressed: () {
                            if (_binLocationController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fill the Bin Location"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            FocusScope.of(context).requestFocus();
                            Constants.showLoadingDialog(context);
                            insertManyIntoMappedBarcodeController
                                .getData(_binLocationController.text.trim(),
                                    BinToBinJournalTableList)
                                .then((value) {
                              Navigator.of(context).pop();
                              _binLocationController.clear();
                              Get.offAll(() => const HomeScreen());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Data Inserted Successfully"),
                                backgroundColor: Colors.green,
                              ));
                            }).onError((error, stackTrace) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll("Exception:", "")),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const TextWidget(text: "TOTAL"),
                        const SizedBox(height: 5),
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
                      ],
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
