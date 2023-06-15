// ignore_for_file: must_be_immutable

import '../../controllers/BinToBinFromAXAPTA/getPalletTableController.dart';
import '../../controllers/BinToBinFromAXAPTA/getSerialTableController.dart';
import '../../controllers/BinToBinFromAXAPTA/getmapBarcodeDataByItemCodeController.dart';
import '../../controllers/BinToBinFromAXAPTA/insertAllDataController.dart';
import '../../models/GetShipmentReceivedTableModel.dart';
import '../../utils/Constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

class BinToBinAxapta2Screen extends StatefulWidget {
  String TRANSFERID;
  int TRANSFERSTATUS;
  String INVENTLOCATIONIDFROM;
  String INVENTLOCATIONIDTO;
  String ITEMID;
  int QTYTRANSFER;
  int QTYRECEIVED;
  String CREATEDDATETIME;
  String GROUPID;

  BinToBinAxapta2Screen({
    required this.TRANSFERID,
    required this.TRANSFERSTATUS,
    required this.INVENTLOCATIONIDFROM,
    required this.INVENTLOCATIONIDTO,
    required this.ITEMID,
    required this.QTYTRANSFER,
    required this.QTYRECEIVED,
    required this.CREATEDDATETIME,
    required this.GROUPID,
  });

  @override
  State<BinToBinAxapta2Screen> createState() => _BinToBinAxapta2ScreenState();
}

class _BinToBinAxapta2ScreenState extends State<BinToBinAxapta2Screen> {
  final TextEditingController _transferIdController = TextEditingController();
  final TextEditingController _locationReferenceController =
      TextEditingController();
  final TextEditingController _scanLocationController = TextEditingController();
  final TextEditingController _palletTypeController = TextEditingController();

  String result = "0";
  List<String> serialNoList = [];

  List<GetShipmentReceivedTableModel> GetShipmentPalletizingList = [];

  @override
  void initState() {
    super.initState();
    _transferIdController.text = widget.TRANSFERID;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      Constants.showLoadingDialog(context);
      GetMapBarcodeDataByItemCodeController.getData(widget.ITEMID)
          .then((value) {
        Navigator.pop(context);
        for (int i = 0; i < value.length; i++) {
          setState(() {
            dropDownList.add(value[i].binLocation ?? "");
          });
        }

        // // convert list to set to remove duplicate values
        // Set<String> set = dropDownList.toSet();
        // // convert set to list to get all values
        // dropDownList = set.toList();

        setState(() {
          dropDownValue = dropDownList[0];
        });
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        setState(() {
          _locationReferenceController.text = "Location Reference";
        });
      });
    });
  }

  String _site = "";

  String? dropDownValue;
  List<String> dropDownList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 10),
                        child: const TextWidget(
                          text: "Transfer ID#",
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          controller: _transferIdController,
                          readOnly: true,
                          hintText: "Transfer ID Number",
                          width: MediaQuery.of(context).size.width * 0.9,
                          onEditingComplete: () {},
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: const TextWidget(
                              text: "From: ",
                              color: Colors.white,
                            ),
                          ),
                          // make dropdown based on dropdown list
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width * 0.68,
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: DropdownSearch<String>(
                              items: dropDownList,
                              onChanged: (value) {
                                setState(() {
                                  dropDownValue = value!;
                                });
                              },
                              selectedItem: dropDownValue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Item Code:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.ITEMID,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Qty Received",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.QTYRECEIVED.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Qty Transfer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.QTYTRANSFER.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Group ID",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.GROUPID.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: dropDownValue == null ? false : true,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _site != '' ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: TextWidget(
                    text:
                        _site == 'By Pallet' ? "Scan Pallet#" : "Scan Serial#",
                    color: Colors.blue[900]!,
                    fontSize: 15,
                  ),
                ),
              ),
              Visibility(
                visible: _site != '' ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    controller: _palletTypeController,
                    readOnly: false,
                    hintText: "Enter/Scan Pallet No",
                    width: MediaQuery.of(context).size.width * 0.9,
                    onEditingComplete: () {
                      if (_site == "By Pallet") {
                        byPalletMethod();
                        return;
                      }
                      if (_site == "By Serial") {
                        bySerialMethod();
                        return;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
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
                            label: Text('Item Code',
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
                          'ItemSerialNo',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                          label: Text(
                            'Map Date',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Pallet Code',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Reference',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'SID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'CID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'PO',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Trans',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: GetShipmentPalletizingList.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(Text(
                              (GetShipmentPalletizingList.indexOf(e) + 1)
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
                          DataCell(Text(e.pO ?? '')),
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
                child: TextWidget(
                  text: "Scan Location To:",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _scanLocationController,
                  readOnly: false,
                  hintText: "Enter/Scan Location",
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Save",
                  onPressed: () {
                    insertData();
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void insertData() {
    if (_scanLocationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Scan Location"),
      ));
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    Constants.showLoadingDialog(context);
    InsertAllDataController.postData(
      _scanLocationController.text.trim(),
      _site,
      GetShipmentPalletizingList,
      widget.TRANSFERID,
      widget.TRANSFERSTATUS,
      widget.INVENTLOCATIONIDFROM,
      widget.INVENTLOCATIONIDTO,
      widget.ITEMID,
      widget.QTYTRANSFER,
      widget.QTYRECEIVED,
      widget.CREATEDDATETIME,
      widget.GROUPID,
    ).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data inserted and updated successfully."),
      ));
      setState(() {
        GetShipmentPalletizingList.clear();
        _scanLocationController.clear();
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }

  void byPalletMethod() {
    FocusScope.of(context).requestFocus(FocusNode());
    Constants.showLoadingDialog(context);
    GetPalletTableController.getAllTable(
            _palletTypeController.text.trim(), dropDownValue.toString())
        .then((value) {
      Navigator.of(context).pop();
      setState(() {
        GetShipmentPalletizingList.clear();
        GetShipmentPalletizingList = value;
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }

  void bySerialMethod() {
    FocusScope.of(context).requestFocus(FocusNode());
    Constants.showLoadingDialog(context);
    GetSerialTableController.getAllTable(
            _palletTypeController.text.trim(), dropDownValue.toString())
        .then((value) {
      Navigator.of(context).pop();
      setState(() {
        GetShipmentPalletizingList.clear();
        GetShipmentPalletizingList = value;
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }
}
