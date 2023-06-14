import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/BarcodeMapping/getAllTblMappedBarcodesController.dart';
import '../../controllers/BarcodeMapping/insertIntoMappedBarcodeOrUpdateBySerialNoController.dart';
import '../../models/GetShipmentReceivedTableModel.dart';
import '../../models/getInventTableWMSDataByItemIdOrItemNameModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../widgets/ElevatedButtonWidget.dart';
import '../../widgets/TextFormField.dart';

Map<String, dynamic> selectedRow = {};
RxList<dynamic> markedList = [].obs;

class BarcodeMappingScreen extends StatefulWidget {
  @override
  State<BarcodeMappingScreen> createState() => _BarcodeMappingScreenState();
}

class _BarcodeMappingScreenState extends State<BarcodeMappingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _gtinController = TextEditingController();
  final TextEditingController _manufacturingController =
      TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final TextEditingController _binLocationController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  String? dropDownValue = "Select Config";
  List<String> dropDownList = [
    "Select Config",
    "G/WG",
    "D/WG",
    "S/WG",
    "PRMDL (V)",
  ];

  String total = "0";

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

  // a method for showing the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // assign the date to the controller in format of dd/mm/yyyy
        _manufacturingController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showUserInfo();
  }

  String itemName = '';
  String itemID = '';
  String itemGroupId = '';
  String groupName = '';

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
            title: "Barcode Mapping".toUpperCase(),
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
                  child: Text(
                    "Search Item Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
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
                          hintText: "Search Item No. Or Description",
                          controller: _searchController,
                          width: MediaQuery.of(context).size.width * 0.73,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            Constants.showLoadingDialog(context);
                            getAllTblMappedBarcodesController
                                .getData(_searchController.text.trim())
                                .then((value) {
                              setState(() {
                                itemName = "${value[0].iTEMNAME}";
                                itemID = "${value[0].iTEMID}";
                                itemGroupId = "${value[0].iTEMGROUPID}";
                                groupName = "${value[0].gROUPNAME}";
                              });
                              Navigator.of(context).pop();
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll("Exception:", "")),
                                ),
                              );
                              Navigator.of(context).pop();
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
                            getAllTblMappedBarcodesController
                                .getData(_searchController.text.trim())
                                .then((value) {
                              setState(() {
                                itemName = "${value[0].iTEMNAME}";
                                itemID = "${value[0].iTEMID}";
                                itemGroupId = "${value[0].iTEMGROUPID}";
                                groupName = "${value[0].gROUPNAME}";
                              });
                              Navigator.of(context).pop();
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll("Exception:", "")),
                                ),
                              );
                              Navigator.of(context).pop();
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
                // SingleChildScrollView(
                //   child: PaginatedDataTable(
                //     // header: Text(
                //     //   "Total: $total",
                //     //   style: TextStyle(
                //     //     fontSize: 20,
                //     //     fontWeight: FontWeight.bold,
                //     //     color: Colors.blue[900]!,
                //     //   ),
                //     // ),

                //     columnSpacing: 10,
                //     horizontalMargin: 20,
                //     showCheckboxColumn: false,
                //     headingRowHeight: 30,
                //     dataRowHeight: 60,
                //     primary: true,
                //     showFirstLastButtons: true,
                //     source:
                //         StudentDataSource(BinToBinJournalTableList, context),
                //     rowsPerPage: 5,
                //     checkboxHorizontalMargin: 10,
                //     columns: [
                //       DataColumn(
                //         label: Text(
                //           'Select',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //           label: Text(
                //         'Item Code',
                //         style: TextStyle(
                //           fontSize: 16,
                //           color: Colors.blue[900]!,
                //         ),
                //       )),
                //       DataColumn(
                //         label: Text(
                //           'Item Desc',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'GTIN',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Remarks',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'User',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Classification',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Main Location',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Bin Location',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Int Code',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Item Serial No.',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Map Date',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Pallet Code',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'Reference',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'SID',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'CID',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           'PO',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           "Trans",
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.blue[900]!,
                //           ),
                //         ),
                //       ),
                //     ], // Adjust the number of rows per page as needed
                //   ),
                // ),
                const SizedBox(height: 20),

                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        "$itemID - $itemName",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      )),
                ),

                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan Serial No",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Serial No",
                    controller: _serialNoController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan GTIN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan GTIN",
                    controller: _gtinController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Select Config",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(left: 20),
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
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan Manufacture Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "dd/mm/yyyy",
                    controller: _manufacturingController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        size: 30,
                        color: Colors.blue[900]!,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan QR Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan QR Code",
                    controller: _qrCodeController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan Bin Location",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Bin Location",
                    controller: _binLocationController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Reference",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Reference",
                    controller: _referenceController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButtonWidget(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    title: "Save",
                    onPressed: () {
                      if (_serialNoController.text.isEmpty ||
                          _gtinController.text.isEmpty ||
                          _manufacturingController.text.isEmpty ||
                          _qrCodeController.text.isEmpty ||
                          _binLocationController.text.isEmpty ||
                          _referenceController.text.isEmpty ||
                          _searchController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all the fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        FocusScope.of(context).unfocus();
                        Constants.showLoadingDialog(context);
                        insertIntoMappedBarcodeOrUpdateBySerialNoController
                            .insert(
                          itemID,
                          itemName,
                          _referenceController.text.trim(),
                          _gtinController.text.trim(),
                          _binLocationController.text.trim(),
                          _serialNoController.text.trim(),
                          _manufacturingController.text.trim(),
                          _qrCodeController.text.trim(),
                        )
                            .then((value) {
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Data saved successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          setState(() {
                            _gtinController.clear();
                            _binLocationController.clear();
                            _serialNoController.clear();
                            _manufacturingController.clear();
                            _qrCodeController.clear();
                            _referenceController.clear();
                            _searchController.clear();

                            itemID = "";
                            itemName = "";
                            itemGroupId = "";
                            groupName = "";
                          });
                        }).onError((error, stackTrace) {
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error
                                  .toString()
                                  .replaceAll("Exception:", "")),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
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
      ),
    );
  }
}

class StudentDataSource extends DataTableSource {
  List<GetShipmentReceivedTableModel> students;
  BuildContext ctx;

  StudentDataSource(
    this.students,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) {
      return null;
    }

    final student = students[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Obx(
            () => Checkbox(
              value: markedList[index],
              onChanged: (value) {
                // user can check only one checkbox
                for (int i = 0; i < markedList.length; i++) {
                  markedList[i] = false;
                }
                markedList[index] = value!;
                selectedRow = student.toJson();
              },
            ),
          ),
        ),
        DataCell(SelectableText(student.itemCode ?? "")),
        DataCell(SelectableText(student.itemDesc ?? "")),
        DataCell(SelectableText(student.gTIN ?? "")),
        DataCell(SelectableText(student.remarks ?? "")),
        DataCell(SelectableText(student.user ?? "")),
        DataCell(SelectableText(student.classification ?? "")),
        DataCell(SelectableText(student.mainLocation ?? "")),
        DataCell(SelectableText(student.binLocation ?? "")),
        DataCell(SelectableText(student.intCode ?? "")),
        DataCell(SelectableText(student.itemSerialNo ?? "")),
        DataCell(SelectableText(student.mapDate ?? "")),
        DataCell(SelectableText(student.palletCode ?? "")),
        DataCell(SelectableText(student.reference ?? "")),
        DataCell(SelectableText(student.sID ?? "")),
        DataCell(SelectableText(student.cID ?? "")),
        DataCell(SelectableText(student.pO ?? "")),
        DataCell(SelectableText(student.trans.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}
