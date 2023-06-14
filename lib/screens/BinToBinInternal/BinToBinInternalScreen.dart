import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/BinToBinInternal/BinToBinInternalTableDataController.dart';
import '../../controllers/BinToBinInternal/updateByPalletController.dart';
import '../../controllers/BinToBinInternal/updateBySerialController.dart';
import '../../models/BinToBinInternalModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

class BinToBinInternalScreen extends StatefulWidget {
  const BinToBinInternalScreen({super.key});

  @override
  State<BinToBinInternalScreen> createState() => _BinToBinInternalScreenState();
}

class _BinToBinInternalScreenState extends State<BinToBinInternalScreen> {
  TextEditingController _binIdController = TextEditingController();
  TextEditingController _scanLocationController = TextEditingController();
  final TextEditingController _palletIdController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  String total = "0";
  String total2 = "0";
  List<BinToBinInternalModel> binToBinInternalTableList = [];
  List<bool> isMarked = [];

  List<BinToBinInternalModel> binToBinInternalFilterTableList = [];

  String _site = "";

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
                  "Internal*",
                  style: TextStyle(
                    color: Colors.blue[900]!,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Bin ID*",
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
                        controller: _binIdController,
                        hintText: "Enter/Scan Bin (From)",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () async {
                          // unFocus from textfield
                          FocusScope.of(context).requestFocus(FocusNode());
                          Constants.showLoadingDialog(context);
                          await searchMethod();
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
                        onTap: () async {
                          // unFocus from textfield
                          FocusScope.of(context).requestFocus(FocusNode());
                          Constants.showLoadingDialog(context);
                          await searchMethod();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: const TextWidget(
                      text: "List of Bin Items*",
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: TextWidget(text: "Total: "),
                        ),
                        Center(
                          child: TextWidget(text: total),
                        ),
                      ],
                    ),
                  ),
                ],
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
                            label: SelectableText('Item Code',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Item Desc',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(
                          'GTIN',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Remarks',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'User',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Classification',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Main Location',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: SelectableText(
                          'Bin Location',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Int Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: SelectableText(
                          'Item Serial No.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Map Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: SelectableText(
                          'Pallet Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Reference',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'SID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PO',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Trans',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: binToBinInternalTableList.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(SelectableText(
                              (binToBinInternalTableList.indexOf(e) + 1)
                                  .toString())),
                          DataCell(SelectableText(e.itemCode ?? "")),
                          DataCell(SelectableText(e.itemDesc ?? "")),
                          DataCell(SelectableText(e.gTIN ?? "")),
                          DataCell(SelectableText(e.remarks ?? "")),
                          DataCell(SelectableText(e.user ?? "")),
                          DataCell(SelectableText(e.classification ?? "")),
                          DataCell(SelectableText(e.mainLocation ?? "")),
                          DataCell(SelectableText(e.binLocation ?? "")),
                          DataCell(SelectableText(e.intCode ?? "")),
                          DataCell(SelectableText(e.itemSerialNo ?? "")),
                          DataCell(SelectableText(e.mapDate ?? "")),
                          DataCell(SelectableText(e.palletCode ?? "")),
                          DataCell(SelectableText(e.reference ?? "")),
                          DataCell(SelectableText(e.sID ?? "")),
                          DataCell(SelectableText(e.cID ?? "")),
                          DataCell(SelectableText(e.pO ?? "")),
                          DataCell(SelectableText(e.trans.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.orange.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        title: const Text('By Pallet'),
                        leading: Radio(
                          value: "By Pallet",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text('By Serial'),
                        leading: Radio(
                          value: "By Serial",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _site == "" ? false : true,
                child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: TextWidget(
                        text:
                            _site == "By Pallet" ? "Pallet ID" : "Serial No.")),
              ),
              Visibility(
                visible: _site == "" ? false : true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          controller: _site == "By Pallet"
                              ? _palletIdController
                              : _serialNumberController,
                          hintText: _site == "By Pallet"
                              ? "Enter/Scan Pallet ID"
                              : "Enter/Scan Serial No.",
                          width: MediaQuery.of(context).size.width * 0.73,
                          onEditingComplete: () async {
                            FocusScope.of(context).unfocus();
                            Constants.showLoadingDialog(context);
                            filterMethod().then((value) {
                              Navigator.pop(context);
                              setState(() {});
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
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
                            FocusScope.of(context).unfocus();
                            Constants.showLoadingDialog(context);
                            filterMethod().then((value) {
                              Navigator.pop(context);
                              setState(() {});
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
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
              ),
              // Container(
              //     margin: const EdgeInsets.only(left: 10, top: 10),
              //     child: const TextWidget(text: "List of items on Pallets*")),
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
                            label: Text(
                          'Item Code',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'Item Desc',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'GTIN',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Remarks',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'User',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Classification',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Main Location',
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
                          'Int Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Item Serial No.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Map Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Pallet Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Reference',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'SID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PO',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Trans',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: binToBinInternalFilterTableList.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(Text(
                              (binToBinInternalFilterTableList.indexOf(e) + 1)
                                  .toString())),
                          DataCell(Text(e.itemCode ?? "")),
                          DataCell(Text(e.itemDesc ?? "")),
                          DataCell(Text(e.gTIN ?? "")),
                          DataCell(Text(e.remarks ?? "")),
                          DataCell(Text(e.user ?? "")),
                          DataCell(Text(e.classification ?? "")),
                          DataCell(Text(e.mainLocation ?? "")),
                          DataCell(Text(e.binLocation ?? "")),
                          DataCell(Text(e.intCode ?? "")),
                          DataCell(Text(e.itemSerialNo ?? "")),
                          DataCell(Text(e.mapDate ?? "")),
                          DataCell(Text(e.palletCode ?? "")),
                          DataCell(Text(e.reference ?? "")),
                          DataCell(Text(e.sID ?? "")),
                          DataCell(Text(e.cID ?? "")),
                          DataCell(Text(e.pO ?? "")),
                          DataCell(Text(e.trans.toString())),
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
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      title: "Save",
                      textColor: Colors.white,
                      color: Colors.orange,
                      onPressed: () {
                        List<String> binLocationList = [];
                        for (int i = 0;
                            i < binToBinInternalFilterTableList.length;
                            i++) {
                          binLocationList.add(binToBinInternalFilterTableList[i]
                              .binLocation
                              .toString());
                        }
                        List<String> serialNoList = [];
                        for (int i = 0;
                            i < binToBinInternalFilterTableList.length;
                            i++) {
                          serialNoList.add(binToBinInternalFilterTableList[i]
                              .itemSerialNo
                              .toString());
                        }

                        FocusScope.of(context).requestFocus(FocusNode());
                        Constants.showLoadingDialog(context);

                        if (_site == "By Pallet") {
                          updateByPalletController
                              .updateBin(
                            binLocationList,
                            _scanLocationController.text.trim(),
                            _palletIdController.text.trim(),
                          )
                              .then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Updated Successfully"),
                              ),
                            );
                            setState(() {
                              binToBinInternalFilterTableList.clear();
                              _scanLocationController.clear();
                              _palletIdController.clear();
                              total2 = "0";
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", "")),
                              ),
                            );
                          });
                          return;
                        }
                        if (_site == "By Serial") {
                          updateBySerialController
                              .updateBin(
                            binLocationList,
                            _scanLocationController.text.trim(),
                            _serialNumberController.text.trim(),
                          )
                              .then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Updated Successfully"),
                              ),
                            );
                            setState(() {
                              binToBinInternalFilterTableList.clear();
                              _scanLocationController.clear();
                              _serialNumberController.clear();
                              total2 = "0";
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", "")),
                              ),
                            );
                          });
                          return;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: TextWidget(text: "Total: "),
                        ),
                        Center(
                          child: TextWidget(text: total2),
                        ),
                      ],
                    ),
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

  Future searchMethod() async {
    BinToBinInternalTableDataController.getAllTable(
            _binIdController.text.trim())
        .then((value) {
      setState(() {
        binToBinInternalTableList = value;
        isMarked = List<bool>.filled(
          binToBinInternalTableList.length,
          false,
        );
        total = binToBinInternalTableList.length.toString();
      });
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No data found."),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  Future filterMethod() async {
    if (_site == "By Pallet") {
      binToBinInternalFilterTableList = binToBinInternalTableList
          .where((element) =>
              element.palletCode
                  .toString()
                  .toLowerCase()
                  .contains(_palletIdController.text.trim()) ||
              element.palletCode
                  .toString()
                  .toUpperCase()
                  .contains(_palletIdController.text.trim()))
          .toList();
      setState(() {
        total2 = binToBinInternalFilterTableList.length.toString();
      });
      return;
    }
    if (_site == "By Serial") {
      binToBinInternalFilterTableList = binToBinInternalTableList
          .where((element) =>
              element.itemSerialNo
                  .toString()
                  .toLowerCase()
                  .contains(_serialNumberController.text.trim()) ||
              element.itemSerialNo
                  .toString()
                  .toUpperCase()
                  .contains(_serialNumberController.text.trim()))
          .toList();
      setState(() {
        total2 = binToBinInternalFilterTableList.length.toString();
      });
      return;
    }
  }
}
