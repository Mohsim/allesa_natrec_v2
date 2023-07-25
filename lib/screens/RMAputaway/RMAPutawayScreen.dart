import 'package:dropdown_search/dropdown_search.dart';

import '../../controllers/BinToBinFromAXAPTA/getmapBarcodeDataByItemCodeController.dart';
import '../../screens/HomeScreen.dart';
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
  String total = "0";

  List<getWmsReturnSalesOrderClByAssignedToUserIdModel> table = [];
  List<getWmsReturnSalesOrderClByAssignedToUserIdModel> duplicateTable = [];

  List<bool> isMarked = [];

  String userName = "";
  String userID = "";

  final TextEditingController _searchController = TextEditingController();
  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

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
        table = value;

        isMarked = List<bool>.generate(table.length, (index) => false);
        total = table.length.toString();
      });
      GetMapBarcodeDataByItemCodeController.getData().then((value) {
        Navigator.pop(context);
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
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        setState(() {
          dropDownValue = "";
          filterList = [];
        });
      });
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
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(
                        text: "Items",
                        fontSize: 16,
                      ),
                      Row(
                        children: [
                          const TextWidget(text: "TOTAL", fontSize: 16),
                          const SizedBox(width: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: total,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                        columns: [
                          DataColumn(
                              label: Row(
                            children: [
                              const FittedBox(
                                child: Text(
                                  'Select All',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // checkbox button for selecting all rows and store it in duplicate table
                              Checkbox(
                                value: duplicateTable.length == table.length,
                                onChanged: (value) {
                                  setState(() {
                                    for (int i = 0; i < table.length; i++) {
                                      isMarked[i] = value!;
                                      if (value) {
                                        duplicateTable.add(table[i]);
                                      } else {
                                        duplicateTable.remove(table[i]);
                                      }
                                    }
                                    print(duplicateTable.length);
                                  });
                                },
                              ),
                            ],
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
                        rows: table.map((e) {
                          return DataRow(onSelectChanged: (value) {}, cells: [
                            DataCell(
                              // checkbox button for selecting row and store it in duplicate table
                              Checkbox(
                                value: isMarked[table.indexOf(e)],
                                onChanged: (value) {
                                  setState(() {
                                    isMarked[table.indexOf(e)] = value!;
                                    if (value) {
                                      duplicateTable.add(e);
                                      print(duplicateTable.length);
                                    } else {
                                      duplicateTable.remove(e);
                                    }
                                  });
                                },
                              ),
                            ),
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
                                      MediaQuery.of(context).size.width * 0.9,
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
                  margin: const EdgeInsets.only(left: 20),
                  child: ElevatedButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    title: "Save",
                    textColor: Colors.white,
                    color: Colors.orange,
                    onPressed: () {
                      if (dropDownValue == null || dropDownValue == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Select Bin Location"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (duplicateTable.length == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please Select Atleast One Item from table"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      FocusScope.of(context).requestFocus();
                      Constants.showLoadingDialog(context);
                      insertManyIntoMappedBarcodeController
                          .getData(
                        dropDownValue.toString(),
                        duplicateTable,
                      )
                          .then((value) {
                        Navigator.of(context).pop();
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
                            content: Text(
                                error.toString().replaceAll("Exception:", "")),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
