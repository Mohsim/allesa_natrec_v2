// ignore_for_file: use_build_context_synchronously

import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/Palletization/GetShipmentPalletizingController.dart';

import '../../controllers/Palletization/ValidateShipmentIdFromShipmentReveivedClController.dart';
import '../../models/GetTransferDistributionByTransferIdModel.dart';
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
  TextEditingController transferIdController = TextEditingController();
  TextEditingController shipmentIdController = TextEditingController();

  String total = "0";
  List<GetTransferDistributionByTransferIdModel> table = [];
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
  void dispose() {
    super.dispose();
    transferIdController.dispose();
    _showUserInfo();
  }

  bool isShipmentId = false;

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
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/delete.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
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
                  text: " Transfer ID*",
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
                        controller: transferIdController,
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          onClick();
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
                          onClick();
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
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: " Shipment ID*",
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: shipmentIdController,
                  readOnly: isShipmentId == true ? true : false,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    onShipmentSearch();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: PaginatedDataTable(
                  rowsPerPage: 5,
                  columns: const [
                    DataColumn(
                        label: Text('TRANSFER ID',
                            style: TextStyle(color: Colors.black))),
                    DataColumn(
                        label: Text('TRANSFER STATUS',
                            style: TextStyle(color: Colors.black))),
                    DataColumn(
                        label: Text(
                      'INVENT LOCATIONID FROM',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'INVENT LOCATION ID TO',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'ITEM ID',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'INVENT DIM ID',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY TRANSFER',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY REMAIN RECEIVE',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'CREATED DATE TIME',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: StudentDataSource(
                    table,
                    context,
                    shipmentIdController.text.trim(),
                    isShipmentId,
                  ),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: Colors.orange,
                  header: Text(
                    'Transfer Details',
                    style: TextStyle(
                        color: Colors.blue[900]!,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onClick() async {
    Constants.showLoadingDialog(context);
    GetShipmentPalletizingController.getShipmentPalletizing(
            transferIdController.text.trim())
        .then((value) {
      setState(() {
        table = value;
        shipmentIdController.text = value[0].sHIPMENTID ?? "";
        if (value[0].sHIPMENTID != null && value[0].sHIPMENTID != "") {
          isShipmentId = true;
        } else {
          isShipmentId = false;
        }
      });
      // Hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        table = [];
        isShipmentId = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString().replaceAll("Exception:", ""))));
    });
  }

  void onShipmentSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Constants.showLoadingDialog(context);
    bool value = await ValidateShipmentIdFromShipmentReveivedClController
        .palletizeSerialNo(shipmentIdController.text.trim());
    try {
      if (value) {
        setState(() {
          isShipmentId = true;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Shipment ID is valid."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ));
      } else {
        setState(() {
          isShipmentId = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Shipment ID not found in tbl_Shipment_Received_CL"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}

class StudentDataSource extends DataTableSource {
  List<GetTransferDistributionByTransferIdModel> table;
  BuildContext ctx;
  String? shipmentId;
  bool isShipmentId;

  StudentDataSource(
    this.table,
    this.ctx,
    this.shipmentId,
    this.isShipmentId,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= table.length) {
      return null;
    }

    final tble = table[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {
        if (shipmentId == null || shipmentId == "") {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text("Please Enter Shipment id."),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ));
          return;
        }

        FocusScope.of(ctx).requestFocus(FocusNode());
        if (isShipmentId == false) {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text("Shipment ID not found in tbl_Shipment_Received_CL"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ));
          return;
        }
        Get.to(() => PalletProceedScreen(
              cREATEDDATETIME: tble.cREATEDDATETIME ?? "",
              iNVENTDIMID: tble.iNVENTDIMID ?? "",
              iNVENTLOCATIONIDFROM: tble.iNVENTLOCATIONIDFROM ?? "",
              iNVENTLOCATIONIDTO: tble.iNVENTLOCATIONIDTO ?? "",
              iTEMID: tble.iTEMID ?? "",
              qTYREMAINRECEIVE: int.parse(tble.qTYREMAINRECEIVE.toString()),
              qTYTRANSFER: int.parse(tble.qTYTRANSFER.toString()),
              tRANSFERID: tble.tRANSFERID.toString(),
              tRANSFERSTATUS: int.parse(tble.tRANSFERSTATUS.toString()),
              shipmentId: shipmentId!,
            ));
      },
      cells: [
        DataCell(Text(tble.tRANSFERID ?? "")),
        DataCell(Text(tble.tRANSFERSTATUS.toString())),
        DataCell(Text(tble.iNVENTLOCATIONIDFROM ?? "")),
        DataCell(Text(tble.iNVENTLOCATIONIDTO ?? "")),
        DataCell(Text(tble.iTEMID ?? "")),
        DataCell(Text(tble.iNVENTDIMID ?? "")),
        DataCell(Text(tble.qTYTRANSFER.toString())),
        DataCell(Text(tble.qTYREMAINRECEIVE.toString())),
        DataCell(Text(tble.cREATEDDATETIME ?? "")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => table.length;

  @override
  int get selectedRowCount => 0;
}
