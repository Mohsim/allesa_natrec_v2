import '../../controllers/BinToBinFromAXAPTA/getmapBarcodeDataByItemCodeController.dart';
import '../../controllers/PickListAssigned/GetAllTblDZonesController.dart';
import '../../controllers/PickListAssigned/GetFirstTableData.dart';
import '../../controllers/PickListAssigned/InsertPickListController.dart';
import '../../models/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

import '../../utils/Constants.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';

// ignore: must_be_immutable
class PickListAssingedScreen2 extends StatefulWidget {
  String PICKINGROUTEID;
  String INVENTLOCATIONID;
  String CONFIGID;
  String ITEMID;
  String ITEMNAME;
  String QTY;
  String CUSTOMER;
  String DLVDATE;
  String TRANSREFID;
  String EXPEDITIONSTATUS;
  String DATETIMEASSIGNED;
  String ASSIGNEDTOUSERID;
  String PICKSTATUS;
  String QTYPICKED;

  PickListAssingedScreen2(
      {Key? key,
      required this.PICKINGROUTEID,
      required this.INVENTLOCATIONID,
      required this.CONFIGID,
      required this.ITEMID,
      required this.ITEMNAME,
      required this.QTY,
      required this.CUSTOMER,
      required this.DLVDATE,
      required this.TRANSREFID,
      required this.EXPEDITIONSTATUS,
      required this.DATETIMEASSIGNED,
      required this.ASSIGNEDTOUSERID,
      required this.PICKSTATUS,
      required this.QTYPICKED})
      : super(key: key);

  @override
  State<PickListAssingedScreen2> createState() =>
      _PickListAssingedScreen2State();
}

class _PickListAssingedScreen2State extends State<PickListAssingedScreen2> {
  final TextEditingController _transferIdController = TextEditingController();
  final TextEditingController _palletTypeController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();

  String result = "0";
  String result2 = "0";
  List<String> serialNoList = [];
  List<bool> isMarked = [];

  List<getMappedBarcodedsByItemCodeAndBinLocationModel> table1 = [];
  List<getMappedBarcodedsByItemCodeAndBinLocationModel> table2 = [];

  @override
  void initState() {
    super.initState();
    _transferIdController.text = widget.PICKINGROUTEID;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      Constants.showLoadingDialog(context);
      GetMapBarcodeDataByItemCodeController.getData().then((value) {
        for (int i = 0; i < value.length; i++) {
          setState(() {
            dropDownList.add(value[i].bIN ?? "");
            Set<String> set = dropDownList.toSet();
            dropDownList = set.toList();
          });
        }

        setState(() {
          dropDownValue = dropDownList[0];
          filterList = dropDownList;
        });

        GetFirstTableData.getData(
          widget.ITEMID,
          dropDownValue!,
        ).then((value) {
          setState(() {
            table1 = value;
            result = table1.length.toString();
          });
        }).onError((error, stackTrace) {
          setState(() {
            table1 = [];
            result = "0";
          });
        });

        GetAllTblDZonesController.getData().then((value2) {
          for (int i = 0; i < value2.length; i++) {
            setState(() {
              dropDownList2.add(value2[i].dZONE ?? "");
              Set<String> set = dropDownList2.toSet();
              dropDownList2 = set.toList();
            });
          }

          setState(() {
            dropDownValue2 = dropDownList2[0];
            filterList2 = dropDownList2;
          });
          Navigator.pop(context);
        }).onError((error, stackTrace) {
          Navigator.pop(context);
          setState(() {
            dropDownValue2 = "";
            filterList2 = [];
          });
        });
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        setState(() {
          dropDownValue = "";
          filterList = [];
        });
      });
    });
  }

  String _site = "By Serial";

  final TextEditingController _searchController = TextEditingController();
  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

  final TextEditingController _searchController2 = TextEditingController();
  String? dropDownValue2;
  List<String> dropDownList2 = [];
  List<String> filterList2 = [];

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
                          text: "Transfer ID#",
                          color: Colors.white,
                          fontSize: 16,
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                GetFirstTableData.getData(
                                  widget.ITEMID,
                                  dropDownValue!,
                                ).then((value) {
                                  setState(() {
                                    table1 = value;
                                    result = table1.length.toString();
                                  });
                                  Navigator.pop(context);
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    table1 = [];
                                    result = "0";
                                  });
                                  Navigator.pop(context);
                                });
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        onEditingComplete: () {
                                          setState(() {
                                            dropDownList = dropDownList
                                                .where((element) => element
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
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
                                                      .contains(
                                                          _searchController.text
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Item ID:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.ITEMID,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Qty",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.QTY.toString(),
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
                                  "Qty Picked",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.QTYPICKED.toString(),
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
                                  "Pick Status",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.PICKSTATUS.toString(),
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
                      rows: table1.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(SelectableText(
                              (table1.indexOf(e) + 1).toString())),
                          DataCell(SelectableText(e.itemCode ?? "")),
                          DataCell(SelectableText(e.itemDesc ?? "")),
                          DataCell(SelectableText(e.gTIN ?? "")),
                          DataCell(SelectableText(e.remarks ?? "")),
                          DataCell(SelectableText(e.user ?? "")),
                          DataCell(SelectableText(e.classification ?? "")),
                          DataCell(SelectableText(e.mainLocation ?? "")),
                          DataCell(SelectableText(e.binLocation ?? "")),
                          DataCell(SelectableText(e.intCode ?? "")),
                          DataCell(
                            Row(
                              children: [
                                SelectableText(e.itemSerialNo ?? ""),
                                // icon for copying the serial number
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: e.itemSerialNo ?? "",
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Copied to Clipboard",
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                              ],
                            ),
                          ),
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
                      child: TextWidget(text: result.toString()),
                    ),
                  ),
                  const SizedBox(width: 20),
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
              const SizedBox(height: 10),
              Visibility(
                visible: _site != "" ? true : false,
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
                      visible: _site != "" ? true : false,
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
                      visible: _site != "" ? true : false,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormFieldWidget(
                          controller: _serialNoController,
                          readOnly: false,
                          hintText: "Enter/Scan Serial No",
                          width: MediaQuery.of(context).size.width * 0.9,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(
                              () {
                                // check if the entered serial no is not present in the GetShipmentPalletizingList
                                if (table1
                                    .where((element) =>
                                        element.itemSerialNo ==
                                        _serialNoController.text.trim())
                                    .toList()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: TextWidget(
                                        text:
                                            "Serial No not found in the list, please insert a serial no from the above list.",
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // append the selected pallet code row to the GetShipmentPalletizingList2
                                table2.add(
                                  table1.firstWhere(
                                    (element) =>
                                        element.itemSerialNo ==
                                        _serialNoController.text.trim(),
                                  ),
                                );
                                // remove the selected pallet code row from the GetShipmentPalletizingList
                                table1.removeWhere(
                                  (element) =>
                                      element.itemSerialNo ==
                                      _serialNoController.text.trim(),
                                );
                                result2 = table2.length.toString();
                                result = table1.length.toString();
                                _serialNoController.clear();
                              },
                            );
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
                      rows: table2.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(Text((table2.indexOf(e) + 1).toString())),
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
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Dispatching Location:",
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
                      items: filterList2,
                      onChanged: (value) {
                        setState(() {
                          dropDownValue2 = value!;
                        });
                      },
                      selectedItem: dropDownValue2,
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
                                controller: _searchController2,
                                readOnly: false,
                                hintText: "Enter/Scan Location",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    dropDownList2 = dropDownList2
                                        .where((element) => element
                                            .toLowerCase()
                                            .contains(_searchController2.text
                                                .toLowerCase()))
                                        .toList();
                                    dropDownValue2 = dropDownList2[0];
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
                                      filterList2 = dropDownList2
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_searchController2.text
                                                  .toLowerCase()))
                                          .toList();
                                      dropDownValue2 = filterList2[0];
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
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Save",
                  onPressed: () {
                    if (dropDownValue2 == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Scan Location"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (table2.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Scan Item"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                    Constants.showLoadingDialog(context);
                    var data = table2.map((e) {
                      return {
                        "INVENTLOCATIONID": dropDownValue2.toString(),
                        "ORDERED": widget.QTY,
                        "PACKINGSLIPID": widget.TRANSREFID,
                        "ASSIGNEDUSERID": widget.ASSIGNEDTOUSERID,
                        "SALESID": widget.PICKINGROUTEID,
                        "ITEMID": widget.ITEMID,
                        "NAME": widget.ITEMID,
                        "CONFIGID": widget.CONFIGID,
                        "DATETIMECREATED": widget.DATETIMEASSIGNED
                      };
                    }).toList();

                    InsertPickListController.insertData(
                      data,
                      widget.PICKINGROUTEID,
                      widget.ITEMID,
                      widget.QTYPICKED,
                      widget.QTY,
                    ).then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Successfully Inserted Successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      setState(() {
                        table2.clear();
                        result2 = "0";
                      });
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              error.toString().replaceAll("Exception:", "")),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
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
}
