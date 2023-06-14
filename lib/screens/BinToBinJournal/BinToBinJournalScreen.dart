import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/BinToBinJournal/BinToBinJournalTableDataController.dart';
import '../../models/BinToBinJournalModel.dart';
import '../../screens/BinToBinJournal/BinToBinJournal2Screen.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

class BinToBinJournalScreen extends StatefulWidget {
  const BinToBinJournalScreen({super.key});

  @override
  State<BinToBinJournalScreen> createState() => _BinToBinJournalScreenState();
}

class _BinToBinJournalScreenState extends State<BinToBinJournalScreen> {
  final TextEditingController _journalIdController = TextEditingController();
  final TextEditingController _scanLocationController = TextEditingController();
  String total = "0";
  List<BinToBinJournalModel> BinToBinJournalTableList = [];
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
          title: "Bin To Bin Transfer".toUpperCase(),
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
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Journal*",
                  style: TextStyle(
                    color: Colors.blue[900]!,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Journal ID*",
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
                        controller: _journalIdController,
                        hintText: "Enter/Scan Journal ID",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          // unFocus from textfield
                          FocusScope.of(context).requestFocus(FocusNode());
                          Constants.showLoadingDialog(context);
                          BinToBinJournalTableDataController.getAllTable(
                                  _journalIdController.text.trim())
                              .then((value) {
                            Navigator.of(context).pop();
                            setState(() {
                              BinToBinJournalTableList = value;
                              isMarked = List<bool>.filled(
                                BinToBinJournalTableList.length,
                                false,
                              );
                              total =
                                  BinToBinJournalTableList.length.toString();
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
                          // unFocus from textfield
                          FocusScope.of(context).requestFocus(FocusNode());
                          Constants.showLoadingDialog(context);
                          BinToBinJournalTableDataController.getAllTable(
                                  _journalIdController.text.trim())
                              .then((value) {
                            Navigator.of(context).pop();
                            setState(() {
                              BinToBinJournalTableList = value;
                              isMarked = List<bool>.filled(
                                BinToBinJournalTableList.length,
                                false,
                              );
                              total =
                                  BinToBinJournalTableList.length.toString();
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
                height: MediaQuery.of(context).size.height * 0.4,
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
                            label: Text('TRANSFER ID',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('TRANSFER STATUS',
                                style: TextStyle(color: Colors.white))),
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
                          'ITEM ID',
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
                          'QTY RECEIVED',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CREATED DATE TIME',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Journal ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Bin Location',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Date Time Transaction',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CONFIG',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'User ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: BinToBinJournalTableList.map((e) {
                        return DataRow(
                            onSelectChanged: (value) {
                              Get.to(
                                () => BinToBinJournal2Screen(
                                  BinLocation: e.binLocation ?? "",
                                  CONFIG: e.cONFIG ?? "",
                                  CREATEDDATETIME: e.cREATEDDATETIME ?? "",
                                  DateTimeTransaction:
                                      e.dateTimeTransaction ?? "",
                                  INVENTLOCATIONIDFROM:
                                      e.iNVENTLOCATIONIDFROM ?? "",
                                  INVENTLOCATIONIDTO:
                                      e.iNVENTLOCATIONIDTO ?? "",
                                  ITEMID: e.iTEMID ?? "",
                                  JournalID: e.journalID ?? "",
                                  QTYRECEIVED:
                                      int.parse(e.qTYRECEIVED.toString()),
                                  QTYTRANSFER:
                                      int.parse(e.qTYTRANSFER.toString()),
                                  TRANSFERID: e.tRANSFERID ?? "",
                                  TRANSFERSTATUS:
                                      int.parse(e.tRANSFERSTATUS.toString()),
                                  USERID: e.uSERID ?? "",
                                ),
                              );
                            },
                            cells: [
                              DataCell(Text(
                                  (BinToBinJournalTableList.indexOf(e) + 1)
                                      .toString())),
                              DataCell(Text(e.tRANSFERID.toString())),
                              DataCell(Text(e.tRANSFERSTATUS.toString())),
                              DataCell(Text(e.iNVENTLOCATIONIDFROM ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDTO ?? "")),
                              DataCell(Text(e.iTEMID ?? "")),
                              DataCell(Text(e.qTYTRANSFER.toString())),
                              DataCell(Text(e.qTYRECEIVED.toString())),
                              DataCell(Text(e.cREATEDDATETIME ?? "")),
                              DataCell(Text(e.journalID ?? "")),
                              DataCell(Text(e.binLocation ?? "")),
                              DataCell(Text(e.dateTimeTransaction ?? "")),
                              DataCell(Text(e.cONFIG ?? "")),
                              DataCell(Text(e.uSERID ?? "")),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Location To*",
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _scanLocationController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan Location",
                  onEditingComplete: () {},
                  onFieldSubmitted: (p0) {},
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
    );
  }
}
