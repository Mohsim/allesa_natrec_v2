import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/WareHouseOperationController/GetShipmentDataController.dart';
import '../../../models/GetShipmentDataModel.dart';
import '../../../models/getAllTblShipmentReceivedCLModel.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/AppBarWidget.dart';
import '../../../widgets/TextFormField.dart';
import '../../../widgets/TextWidget.dart';
import 'ScanSerialNumberScreen.dart';

int RCQTY = 0;

class ShipmentDispatchingScreen extends StatefulWidget {
  const ShipmentDispatchingScreen({super.key});

  @override
  State<ShipmentDispatchingScreen> createState() =>
      _ShipmentDispatchingScreenState();
}

class _ShipmentDispatchingScreenState extends State<ShipmentDispatchingScreen> {
  TextEditingController _shipmentIdController = TextEditingController();
  String total = "0";
  List<GetShipmentDataModel> getAllAssetByLocationList = [];
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

  List<getAllTblShipmentReceivedCLModel> getAllTblShipmentReceivedCLList = [];

  @override
  void initState() {
    super.initState();
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
          title: "Shipment Receiving".toUpperCase(),
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
                          // hide keyboard
                          FocusScope.of(context).unfocus();
                          Constants.showLoadingDialog(context);
                          GetShipmentDataController.getShipmentData(
                                  _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              getAllAssetByLocationList = value;
                              total =
                                  getAllAssetByLocationList.length.toString();
                              isMarked = List<bool>.filled(
                                  getAllAssetByLocationList.length, false);
                            });
                            Navigator.pop(context);
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
                          GetShipmentDataController.getShipmentData(
                                  _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              getAllAssetByLocationList = value;
                              total =
                                  getAllAssetByLocationList.length.toString();
                              isMarked = List<bool>.filled(
                                  getAllAssetByLocationList.length, false);
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
                          'SHIPMENT ID',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'CONTAINER ID',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'ARRIVAL WAREHOUSE',
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
                          'ITEM ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PURCH ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CLASSIFICATION',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'SERIAL No.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'RCVD CONFIG ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'RCVD DATE',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'GTIN',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'RZONE',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PALLET DATE',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PALLETCODE',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'BIN',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'REMARKS',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PO QTY',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'RCV QTY',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'REMAINING QTY',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'USER  ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'TRX DATE TIME',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: getAllAssetByLocationList.map((e) {
                        return DataRow(
                            onSelectChanged: (value) {
                              // keybord hide
                              FocusScope.of(context).requestFocus(FocusNode());
                              Get.to(
                                () => ScanSerialNumberScreen(
                                  aRRIVALWAREHOUSE:
                                      e.aRRIVALWAREHOUSE.toString(),
                                  cLASSIFICATION: e.cLASSIFICATION.toString(),
                                  cONTAINERID: e.cONTAINERID.toString(),
                                  bIN: e.bIN.toString(),
                                  gTIN: e.gTIN.toString(),
                                  iTEMID: e.iTEMID.toString(),
                                  iTEMNAME: e.iTEMNAME.toString(),
                                  pALLETCODE: e.pALLETCODE.toString(),
                                  pALLETDATE: e.pALLETDATE.toString(),
                                  pURCHID: e.pURCHID.toString(),
                                  pOQTY: int.parse(e.pOQTY.toString()),
                                  rCVDCONFIGID: e.rCVDCONFIGID.toString(),
                                  rCVDDATE: e.rCVDDATE.toString(),
                                  rCVQTY: int.parse(e.rCVQTY.toString()),
                                  rEMAININGQTY:
                                      int.parse(e.rEMAININGQTY.toString()),
                                  rEMARKS: e.rEMARKS.toString(),
                                  rZONE: e.rZONE.toString(),
                                  sERIALNUM: e.sERIALNUM.toString(),
                                  sHIPMENTID: e.sHIPMENTID.toString(),
                                  tRXDATETIME: e.tRXDATETIME.toString(),
                                  uSERID: e.uSERID.toString(),
                                ),
                              );
                            },
                            cells: [
                              DataCell(Text(
                                  (getAllAssetByLocationList.indexOf(e) + 1)
                                      .toString())),
                              DataCell(Text(e.sHIPMENTID.toString())),
                              DataCell(Text(e.cONTAINERID.toString())),
                              DataCell(Text(e.aRRIVALWAREHOUSE.toString())),
                              DataCell(Text(e.iTEMNAME.toString())),
                              DataCell(Text(e.iTEMID.toString())),
                              DataCell(Text(e.pURCHID.toString())),
                              DataCell(Text(e.cLASSIFICATION.toString())),
                              DataCell(Text(e.sERIALNUM.toString())),
                              DataCell(Text(e.rCVDCONFIGID.toString())),
                              DataCell(Text(e.rCVDDATE.toString())),
                              DataCell(Text(e.gTIN.toString())),
                              DataCell(Text(e.rZONE.toString())),
                              DataCell(Text(e.pALLETDATE.toString())),
                              DataCell(Text(e.pALLETCODE.toString())),
                              DataCell(Text(e.bIN.toString())),
                              DataCell(Text(e.rEMARKS.toString())),
                              DataCell(Text(e.pOQTY.toString())),
                              DataCell(Text(e.rCVQTY.toString())),
                              DataCell(Text(e.rEMAININGQTY.toString())),
                              DataCell(Text(e.uSERID.toString())),
                              DataCell(Text(e.tRXDATETIME.toString())),
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
