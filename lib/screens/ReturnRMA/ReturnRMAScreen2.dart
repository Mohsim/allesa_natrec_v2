import 'package:alessa_v2/widgets/ElevatedButtonWidget.dart';

import '../../controllers/ReturnRMA/InsertManyIntoMappedBarcodeController.dart';
import '../../controllers/ReturnRMA/ReturnDZones.dart';
import '../../models/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../controllers/ReturnRMA/generateBarcodeForRmaController.dart';
import '../../controllers/ReturnRMA/insertIntoWmsReturnSalesOrderClController.dart';
import '../../models/getWmsReturnSalesOrderByReturnItemNum2Model.dart';
import '../../models/updateWmsJournalMovementClQtyScannedModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

// ignore: must_be_immutable
class ReturnRMAScreen2 extends StatefulWidget {
  String iTEMID;
  String nAME;
  int eXPECTEDRETQTY;
  String sALESID;
  String rETURNITEMNUM;
  String iNVENTSITEID;
  String iNVENTLOCATIONID;
  String cONFIGID;
  String wMSLOCATIONID;

  ReturnRMAScreen2({
    required this.iTEMID,
    required this.nAME,
    required this.eXPECTEDRETQTY,
    required this.sALESID,
    required this.rETURNITEMNUM,
    required this.iNVENTSITEID,
    required this.iNVENTLOCATIONID,
    required this.cONFIGID,
    required this.wMSLOCATIONID,
  });

  @override
  State<ReturnRMAScreen2> createState() => _ReturnRMAScreen2State();
}

class _ReturnRMAScreen2State extends State<ReturnRMAScreen2> {
  final TextEditingController _returnItemNumController =
      TextEditingController();
  final TextEditingController _palletTypeController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _modelNoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String result = "0";
  String result2 = "0";
  List<String> serialNoList = [];
  List<bool> isMarked = [];

  // List<getMappedBarcodedsByItemCodeAndBinLocationModel>
  //     GetShipmentPalletizingList = [];
  List<getMappedBarcodedsByItemCodeAndBinLocationModel>
      GetShipmentPalletizingList2 = [];

  List<getWmsReturnSalesOrderByReturnItemNum2Model> getWmsReturnSalesOrderList =
      [];

  updateWmsJournalMovementClQtyScannedModel
      updateWmsJournalMovementClQtyScannedList =
      updateWmsJournalMovementClQtyScannedModel();

  // focus node for text fields
  final FocusNode _serialNoFocusNode = FocusNode();

  String _site = "By Serial";
  String _barCode = 'No Barcode';

  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

  @override
  void initState() {
    super.initState();
    _returnItemNumController.text = widget.rETURNITEMNUM;

    Future.delayed(Duration.zero, () async {
      try {
        Constants.showLoadingDialog(context);
        var value = await ReturnDZones.getData();
        Navigator.pop(context);
        for (int i = 0; i < value.length; i++) {
          setState(() {
            dropDownList.add(value[i].rZONE ?? "");
            Set<String> set = dropDownList.toSet();
            dropDownList = set.toList();
          });
        }
        setState(() {
          dropDownValue = dropDownList[0];
          filterList = dropDownList;
        });

        // GetPickListTableDataController.getData(
        //   widget.iTEMID,
        //   dropDownValue.toString(),
        // ).then((value) {
        //   setState(() {
        //     GetShipmentPalletizingList = value;
        //     result = value.length.toString();
        //   });
        //   Navigator.pop(context);
        // }).onError((error, stackTrace) {
        //   setState(() {
        //     GetShipmentPalletizingList = [];
        //     result = "0";
        //   });
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text(error.toString().replaceAll("Exception:", "")),
        //     backgroundColor: Colors.red,
        //   ));
        // });
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll("Exception:", "")),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 10),
                        child: const TextWidget(
                          text: "Return Item Number:",
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          controller: _returnItemNumController,
                          readOnly: true,
                          width: MediaQuery.of(context).size.width * 0.9,
                          onEditingComplete: () {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(
                            text: "From:",
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.iNVENTSITEID,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Item ID:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.iTEMID,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Sales ID: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.sALESID.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Return Qty: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.rETURNITEMNUM.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Expected Ret QTY: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.eXPECTEDRETQTY.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.grey,
              //       width: 1,
              //     ),
              //   ),
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: DataTable(
              //         showCheckboxColumn: false,
              //         dataRowColor: MaterialStateColor.resolveWith(
              //             (states) => Colors.grey.withOpacity(0.2)),
              //         headingRowColor: MaterialStateColor.resolveWith(
              //             (states) => Colors.orange),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.grey,
              //             width: 1,
              //           ),
              //         ),
              //         border: TableBorder.all(
              //           color: Colors.black,
              //           width: 1,
              //         ),
              //         columns: const [
              //           DataColumn(
              //               label: Text(
              //             'ID',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Item Code',
              //             style: TextStyle(color: Colors.white),
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Item Desc',
              //             style: TextStyle(color: Colors.white),
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'GTIN',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Remarks',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'User',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Classification',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Main Location',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Bin Location',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Int Code',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'Item Serial No.',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //             label: Text(
              //               'Map Date',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'Pallet Code',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'Reference',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'S-ID',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'C-ID',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'PO',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           DataColumn(
              //             label: Text(
              //               'Trans',
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         ],
              //         rows: GetShipmentPalletizingList.map((e) {
              //           return DataRow(onSelectChanged: (value) {}, cells: [
              //             DataCell(SelectableText(
              //                 (GetShipmentPalletizingList.indexOf(e) + 1)
              //                     .toString())),
              //             DataCell(SelectableText(e.itemCode ?? "")),
              //             DataCell(SelectableText(e.itemDesc ?? "")),
              //             DataCell(SelectableText(e.gTIN ?? "")),
              //             DataCell(SelectableText(e.remarks ?? "")),
              //             DataCell(SelectableText(e.user ?? "")),
              //             DataCell(SelectableText(e.classification ?? "")),
              //             DataCell(SelectableText(e.mainLocation ?? "")),
              //             DataCell(SelectableText(e.binLocation ?? "")),
              //             DataCell(SelectableText(e.intCode ?? "")),
              //             DataCell(SelectableText(e.itemSerialNo ?? "")),
              //             DataCell(SelectableText(e.mapDate ?? "")),
              //             DataCell(SelectableText(e.palletCode ?? "")),
              //             DataCell(SelectableText(e.reference ?? "")),
              //             DataCell(SelectableText(e.sID ?? "")),
              //             DataCell(SelectableText(e.cID ?? "")),
              //             DataCell(SelectableText(e.pO ?? "")),
              //             DataCell(SelectableText(e.trans.toString())),
              //           ]);
              //         }).toList(),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     const TextWidget(text: "TOTAL"),
              //     const SizedBox(width: 5),
              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.4,
              //       height: 50,
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.blue,
              //         ),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Center(
              //         child: TextWidget(text: result.toString()),
              //       ),
              //     ),
              //     const SizedBox(width: 20),
              //   ],
              // ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Receiving Zones",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.73,
                    margin: const EdgeInsets.only(left: 20),
                    child: DropdownSearch<String>(
                      filterFn: (item, filter) {
                        return item
                            .toLowerCase()
                            .contains(filter.toLowerCase());
                      },
                      enabled: true,
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                      items: filterList,
                      onChanged: (value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                        Constants.showLoadingDialog(context);
                        // GetPickListTableDataController.getData(
                        //   widget.iTEMID,
                        //   dropDownValue.toString(),
                        // ).then((value) {
                        //   setState(() {
                        //     GetShipmentPalletizingList = value;
                        //     result = value.length.toString();
                        //   });
                        //   Navigator.pop(context);
                        // }).onError((error, stackTrace) {
                        //   setState(() {
                        //     GetShipmentPalletizingList = [];
                        //     result = "0";
                        //   });
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         error.toString().replaceAll("Exception:", "")),
                        //     backgroundColor: Colors.red,
                        //   ));
                        // });
                      },
                      selectedItem: dropDownValue,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        // show dialog box for search
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: TextWidget(
                                text: "Search",
                                color: Colors.blue[900]!,
                                fontSize: 15,
                              ),
                              content: TextFormFieldWidget(
                                controller: _searchController,
                                readOnly: false,
                                hintText: "Enter/Scan Location",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    dropDownList = dropDownList
                                        .where((element) => element
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList();
                                    dropDownValue = dropDownList[0];
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Cancel",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // filter list based on search
                                    setState(() {
                                      filterList = dropDownList
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_searchController.text
                                                  .toLowerCase()))
                                          .toList();
                                      dropDownValue = filterList[0];
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Search",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        title: const Text('Barcode'),
                        leading: Radio(
                          value: "Barcode",
                          groupValue: _barCode,
                          onChanged: (String? value) {
                            setState(() {
                              _barCode = value!;
                              print(_barCode);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text('No Barcode'),
                        leading: Radio(
                          value: "No Barcode",
                          groupValue: _barCode,
                          onChanged: (String? value) {
                            setState(() {
                              _barCode = value!;
                              print(_barCode);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _barCode == "No Barcode" ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: TextWidget(
                    text: "Model No#",
                    color: Colors.blue[900]!,
                    fontSize: 15,
                  ),
                ),
              ),
              Visibility(
                visible: _barCode == "No Barcode" ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    controller: _modelNoController,
                    readOnly: false,
                    hintText: "Enter/Scan Model No#",
                    width: MediaQuery.of(context).size.width * 0.9,
                    onEditingComplete: () {},
                  ),
                ),
              ),
              Visibility(
                visible: _barCode == "No Barcode" ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: ElevatedButtonWidget(
                    title: "Generate Barcode",
                    color: Colors.orange[100],
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    onPressed: () async {
                      if (_modelNoController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please Enter a Unique Model No.",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      if (dropDownValue == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please Select a Location.",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      FocusScope.of(context).requestFocus();
                      Constants.showLoadingDialog(context);
                      GenerateBarcodeForRmaController.getData(
                        widget.rETURNITEMNUM,
                        widget.iTEMID,
                        _modelNoController.text.trim(),
                      ).then((value) {
                        setState(() {
                          getWmsReturnSalesOrderList
                              .add(getWmsReturnSalesOrderByReturnItemNum2Model(
                            cONFIGID: widget.cONFIGID,
                            eXPECTEDRETQTY: widget.eXPECTEDRETQTY,
                            iTEMID: widget.iTEMID,
                            nAME: widget.nAME,
                            iNVENTLOCATIONID: widget.iNVENTLOCATIONID,
                            iNVENTSITEID: widget.iNVENTSITEID,
                            rETURNITEMNUM: widget.rETURNITEMNUM,
                            sALESID: widget.sALESID,
                            wMSLOCATIONID: widget.wMSLOCATIONID,
                            itemSerialNo: value,
                          ));
                          result2 =
                              getWmsReturnSalesOrderList.length.toString();
                        });

                        InsertManyIntoMappedBarcodeController.getData(
                          widget.iTEMID,
                          widget.nAME,
                          _modelNoController.text.trim(),
                          dropDownValue.toString(),
                        ).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Barcode Generated Successfully.",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // GetPickListTableDataController.getData(
                          //   widget.iTEMID,
                          //   dropDownValue.toString(),
                          // ).then((value) {
                          //   setState(() {
                          //     // first clear the list then add the new data
                          //     GetShipmentPalletizingList = value;
                          //     result = value.length.toString();
                          //   });
                          // }).onError((error, stackTrace) {
                          //   setState(() {
                          //     GetShipmentPalletizingList = [];
                          //   });
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text(error.toString()),
                          //     backgroundColor: Colors.red,
                          //   ));
                          // });
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString().replaceAll("Exception:", ""),
                                textAlign: TextAlign.center,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        });

                        _modelNoController.clear();
                      }).onError((error, stackTrace) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString().replaceAll("Exception:", ""),
                              textAlign: TextAlign.center,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _barCode == "Barcode" ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
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
                              // setState(() {
                              //   _site = value!;
                              //   print(_site);
                              // });
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
              Visibility(
                visible: _barCode == "Barcode" ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: TextWidget(
                    text: _site == "By Pallet" ? "Scan Pallet" : "Scan Serial#",
                    color: Colors.blue[900]!,
                    fontSize: 15,
                  ),
                ),
              ),
              _site == "By Pallet"
                  ? Visibility(
                      visible: _barCode == "Barcode" ? true : false,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          controller: _palletTypeController,
                          readOnly: false,
                          hintText: "Enter/Scan Pallet No",
                          width: MediaQuery.of(context).size.width * 0.9,
                          onEditingComplete: () {},
                        ),
                      ),
                    )
                  : Visibility(
                      visible: _barCode == "Barcode" ? true : false,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          focusNode: _serialNoFocusNode,
                          controller: _serialNoController,
                          readOnly: false,
                          hintText: "Enter/Scan Serial No",
                          width: MediaQuery.of(context).size.width * 0.9,
                          onEditingComplete: () {
                            setState(
                              () {
                                if (dropDownValue == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please Select a Location.",
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                if (GetShipmentPalletizingList2.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "No data to insert into Table Map Barcode.",
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                if (_serialNoController.text.trim() == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please Enter a Unique Serial No.",
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                Constants.showLoadingDialog(context);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Constants.showLoadingDialog(context);
                                insertIntoWmsReturnSalesOrderClController
                                    .getData(
                                  GetShipmentPalletizingList2.last,
                                  _serialNoController.text.trim(),
                                )
                                    .then((value) {
                                  setState(
                                    () {
                                      // append the selected pallet code row to the GetShipmentPalletizingList2
                                      GetShipmentPalletizingList2.add(
                                        GetShipmentPalletizingList2.where(
                                          (element) =>
                                              element.itemSerialNo ==
                                              _serialNoController.text.trim(),
                                        ).toList().last,
                                      );

                                      result2 = GetShipmentPalletizingList2
                                          .length
                                          .toString();
                                    },
                                  );

                                  InsertManyIntoMappedBarcodeController.getData(
                                    widget.iTEMID,
                                    widget.nAME,
                                    _serialNoController.text.trim(),
                                    dropDownValue.toString(),
                                  ).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Record inserted Successfully.",
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    // GetPickListTableDataController.getData(
                                    //   widget.iTEMID,
                                    //   dropDownValue.toString(),
                                    // ).then((value) {
                                    //   setState(() {
                                    //     GetShipmentPalletizingList = value;
                                    //     result = value.length.toString();
                                    //   });
                                    //   Navigator.pop(context);
                                    // }).onError((error, stackTrace) {
                                    //   Navigator.pop(context);
                                    //   setState(() {
                                    //     GetShipmentPalletizingList = [];
                                    //   });
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //     content: Text(error.toString()),
                                    //     backgroundColor: Colors.red,
                                    //   ));
                                    // });
                                  }).onError((error, stackTrace) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error
                                              .toString()
                                              .replaceAll("Exception:", ""),
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  });

                                  Navigator.pop(context);

                                  _serialNoController.clear();
                                  FocusScope.of(context)
                                      .requestFocus(_serialNoFocusNode);
                                }).onError(
                                  (error, stackTrace) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: TextWidget(
                                          text: error
                                              .toString()
                                              .replaceAll("Exception:", ""),
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              _barCode == "Barcode"
                  ? Container(
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
                                'Item Serial No.',
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
                                  'S-ID',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'C-ID',
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
                            rows: GetShipmentPalletizingList2.map((e) {
                              return DataRow(
                                  onSelectChanged: (value) {},
                                  cells: [
                                    DataCell(Text(
                                        (GetShipmentPalletizingList2.indexOf(
                                                    e) +
                                                1)
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
                    )
                  : Container(
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
                                'ITEM SERIAL NO.',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                            ],
                            rows: getWmsReturnSalesOrderList.map((e) {
                              return DataRow(
                                  onSelectChanged: (value) {},
                                  cells: [
                                    DataCell(Text(
                                        (getWmsReturnSalesOrderList.indexOf(e) +
                                                1)
                                            .toString())),
                                    DataCell(Text(e.iTEMID ?? "")),
                                    DataCell(Text(e.nAME ?? "")),
                                    DataCell(Text(e.eXPECTEDRETQTY.toString())),
                                    DataCell(Text(e.sALESID ?? "")),
                                    DataCell(Text(e.rETURNITEMNUM ?? "")),
                                    DataCell(Text(e.iNVENTSITEID ?? "")),
                                    DataCell(Text(e.iNVENTLOCATIONID ?? "")),
                                    DataCell(Text(e.cONFIGID ?? "")),
                                    DataCell(Text(e.wMSLOCATIONID ?? "")),
                                    DataCell(Text(e.itemSerialNo ?? "")),
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
                      child: TextWidget(text: result2.toString()),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // void createPdf(String value) async {
  //   final doc = pw.Document();

  //   final image = await imageFromAssetBundle("assets/alessa.png");

  //   doc.addPage(
  //     pw.Page(
  //         pageFormat: const PdfPageFormat(300, 250),
  //         orientation: pw.PageOrientation.landscape,
  //         clip: true,
  //         build: (pw.Context context) {
  //           return buildPdf(value, image);
  //         }),
  //   );

  //   await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => doc.save());
  // }

  // buildPdf(String uniqId, image) {
  //   return pw.Center(
  //     child: pw.Column(
  //       mainAxisAlignment: pw.MainAxisAlignment.center,
  //       crossAxisAlignment: pw.CrossAxisAlignment.center,
  //       children: [
  //         pw.SizedBox(
  //           height: 50,
  //           width: double.infinity,
  //           child: pw.Image(
  //             image,
  //             width: double.infinity,
  //           ),
  //         ),
  //         pw.Container(
  //           margin: const pw.EdgeInsets.symmetric(horizontal: 20),
  //           alignment: pw.Alignment.topCenter,
  //           child: pw.BarcodeWidget(
  //             barcode: Barcode.code39(),
  //             drawText: true,
  //             width: 300,
  //             height: 100,
  //             data: uniqId,
  //             textStyle: const pw.TextStyle(fontSize: 10),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
