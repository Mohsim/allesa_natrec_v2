import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/InternalTransferOrder/GetShipmentPalletizingController.dart';

import '../../models/GetShipmentPalletizingModel.dart';
import '../../screens/Palletizing/PalletProceedScreen.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/AppBarWidget.dart';
import '../../../widgets/TextFormField.dart';
import '../../../widgets/TextWidget.dart';

class ShipmentPalletizingScreen extends StatefulWidget {
  const ShipmentPalletizingScreen({super.key});

  @override
  State<ShipmentPalletizingScreen> createState() =>
      _ShipmentPalletizingScreenState();
}

class _ShipmentPalletizingScreenState extends State<ShipmentPalletizingScreen> {
  TextEditingController _shipmentIdController = TextEditingController();
  String total = "0";
  List<GetShipmentPalletizingModel> GetShipmentPalletizingList = [];
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
  void dispose() {
    super.dispose();
    _shipmentIdController.dispose();
    _showUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarWidget(
          autoImplyLeading: true,
          onPressed: () {
            Get.back();
          },
          title: "Palletization".toUpperCase(),
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
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Shipment ID*",
                  fontSize: 16,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextFormFieldWidget(
                        controller: _shipmentIdController,
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          Constants.showLoadingDialog(context);
                          GetShipmentPalletizingController
                                  .getShipmentPalletizing(
                                      _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              GetShipmentPalletizingList = value;
                              total =
                                  GetShipmentPalletizingList.length.toString();
                              isMarked = List<bool>.filled(
                                  GetShipmentPalletizingList.length, false);
                              Navigator.pop(context);
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", ""))));
                          });
                        },
                        onFieldSubmitted: (p0) {
                          Constants.showLoadingDialog(context);
                          GetShipmentPalletizingController
                                  .getShipmentPalletizing(
                                      _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              GetShipmentPalletizingList = value;
                              total =
                                  GetShipmentPalletizingList.length.toString();
                              isMarked = List<bool>.filled(
                                  GetShipmentPalletizingList.length, false);
                              Navigator.pop(context);
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", ""))));
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Constants.showLoadingDialog(context);
                          GetShipmentPalletizingController
                                  .getShipmentPalletizing(
                                      _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              GetShipmentPalletizingList = value;
                              total =
                                  GetShipmentPalletizingList.length.toString();
                              isMarked = List<bool>.filled(
                                  GetShipmentPalletizingList.length, false);
                              Navigator.pop(context);
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", ""))));
                          });
                        },
                        child: Image.asset('assets/finder.png',
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 60,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: const TextWidget(
                  text: "Shipment Details*",
                  fontSize: 16,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
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
                            label: Text('ALS_PACKING SLIP REF',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('ALS_TRANSFER ORDER TYPE',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(
                          'TRANSFER ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID FROM',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID TO',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'QTY TRANSFER',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'ITEM ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'ITEM NAME',
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
                            'SHIPMENT ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: GetShipmentPalletizingList.map((e) {
                        return DataRow(
                            onSelectChanged: (value) {
                              // keybord hide
                              FocusScope.of(context).requestFocus(FocusNode());
                              Get.to(() => PalletProceedScreen(
                                    ALS_PACKINGSLIPREF:
                                        e.aLSPACKINGSLIPREF ?? "",
                                    ALS_TRANSFERORDERTYPE: int.parse(
                                        e.aLSTRANSFERORDERTYPE.toString()),
                                    CONFIGID: e.cONFIGID ?? "",
                                    INVENTLOCATIONIDFROM:
                                        e.iNVENTLOCATIONIDFROM ?? "",
                                    INVENTLOCATIONIDTO:
                                        e.iNVENTLOCATIONIDTO ?? "",
                                    ITEMID: e.iTEMID ?? "",
                                    ITEMNAME: e.iTEMNAME ?? "",
                                    QTYTRANSFER:
                                        int.parse(e.qTYTRANSFER.toString()),
                                    SHIPMENTID: e.sHIPMENTID ?? "",
                                    TRANSFERID: e.tRANSFERID ?? "",
                                    WMSLOCATIONID: e.wMSLOCATIONID ?? "",
                                  ));
                            },
                            cells: [
                              DataCell(Text(
                                  (GetShipmentPalletizingList.indexOf(e) + 1)
                                      .toString())),
                              DataCell(Text(e.aLSPACKINGSLIPREF ?? "")),
                              DataCell(Text(e.aLSTRANSFERORDERTYPE.toString())),
                              DataCell(Text(e.tRANSFERID ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDFROM ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDTO ?? "")),
                              DataCell(Text(e.qTYTRANSFER.toString())),
                              DataCell(Text(e.iTEMID ?? "")),
                              DataCell(Text(e.iTEMNAME ?? "")),
                              DataCell(Text(e.cONFIGID ?? "")),
                              DataCell(Text(e.wMSLOCATIONID ?? "")),
                              DataCell(Text(e.sHIPMENTID ?? "")),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const TextWidget(text: "TOTAL"),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
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
            ],
          ),
        ),
      ),
    );
  }
}
