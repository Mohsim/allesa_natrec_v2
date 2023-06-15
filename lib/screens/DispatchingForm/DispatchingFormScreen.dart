import '../../controllers/Dispatching/GetDispatchingTableController.dart';
import '../../controllers/Dispatching/InsertDispatchingScreen.dart';
import '../../models/getDispatchingTableModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

class DispatchingFormScreen extends StatefulWidget {
  const DispatchingFormScreen({super.key});

  @override
  State<DispatchingFormScreen> createState() => _DispatchingFormScreenState();
}

class _DispatchingFormScreenState extends State<DispatchingFormScreen> {
  final TextEditingController _pickingSlipIdController =
      TextEditingController();
  final TextEditingController _vehicleBarcodeSerialController =
      TextEditingController();

  String total = "0";

  List<getDispatchingTableModel> getItemInfoByPalletCodeList = [];
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
          title: "Dispatching Form".toUpperCase(),
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
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Picking Slip ID*",
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
                        controller: _pickingSlipIdController,
                        hintText: "Enter/Scan Pick Slip ID",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          packingSlipTable();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          packingSlipTable();
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
                  text: "Items*",
                  fontSize: 16,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.38,
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
                          'SALES ID',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'ITEM ID',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'NAME',
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
                          'ORDERED',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PACKING SLIP ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'VEHICLE SHIP PLATE NUMBER',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: getItemInfoByPalletCodeList.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(Text(
                              (getItemInfoByPalletCodeList.indexOf(e) + 1)
                                  .toString())),
                          DataCell(Text(e.sALESID ?? "")),
                          DataCell(Text(e.iTEMID ?? "")),
                          DataCell(Text(e.nAME ?? "")),
                          DataCell(Text(e.iNVENTLOCATIONID ?? "")),
                          DataCell(Text(e.cONFIGID ?? "")),
                          DataCell(Text(e.oRDERED.toString())),
                          DataCell(Text(e.pACKINGSLIPID ?? "")),
                          DataCell(Text(e.vEHICLESHIPPLATENUMBER.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                width: MediaQuery.of(context).size.width * 1,
                child: const TextWidget(
                  text: "Vehicle Barcode Serial No.\n(Vehicle Plate No.)",
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _vehicleBarcodeSerialController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan Serial No.",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButtonWidget(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        title: "Save",
                        textColor: Colors.white,
                        color: Colors.orange,
                        onPressed: () {
                          if (getItemInfoByPalletCodeList.length == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please add item first"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (_vehicleBarcodeSerialController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please Enter Vehicle Barcode Serial No."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          var data = getItemInfoByPalletCodeList.map((e) {
                            return {
                              "SALESID": e.sALESID,
                              "ITEMID": e.iTEMID,
                              "NAME": e.nAME,
                              "INVENTLOCATIONID": e.iNVENTLOCATIONID,
                              "CONFIGID": e.cONFIGID,
                              "ORDERED": e.oRDERED,
                              "PACKINGSLIPID": e.pACKINGSLIPID,
                              "VEHICLESHIPPLATENUMBER": e.vEHICLESHIPPLATENUMBER
                            };
                          }).toList();
                          // unfocus from keyboard
                          FocusScope.of(context).unfocus();
                          Constants.showLoadingDialog(context);
                          InsertDispatchingController.insertData(
                            data,
                            _vehicleBarcodeSerialController.text.trim(),
                          ).then((value) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Data inserted successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {
                              getItemInfoByPalletCodeList.clear();
                              total = "0";
                            });
                          }).onError((error, stackTrace) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception", "")),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void packingSlipTable() {
    FocusScope.of(context).requestFocus(FocusNode());
    Constants.showLoadingDialog(context);
    GetDispatchingTableController.getShipmentReceived(
            _pickingSlipIdController.text.trim())
        .then((value) {
      Navigator.of(context).pop();
      setState(() {
        getItemInfoByPalletCodeList = value;
        isMarked = List<bool>.filled(
          getItemInfoByPalletCodeList.length,
          false,
        );
        total = getItemInfoByPalletCodeList.length.toString();
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No data found."),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
