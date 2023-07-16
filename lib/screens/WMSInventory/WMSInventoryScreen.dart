import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/BarcodeMapping/getAllTblMappedBarcodesController.dart';
import '../../controllers/WMSInventory/getAllTblUsersController.dart';
import '../../controllers/WMSInventory/insertIntoWmsJournalCountingOnlyCLController.dart';
import '../../models/getInventTableWMSDataByItemIdOrItemNameModel.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';
import '../../widgets/ElevatedButtonWidget.dart';
import '../../widgets/TextFormField.dart';

List<getInventTableWMSDataByItemIdOrItemNameModel> selectedRow = [];
RxList<dynamic> markedList = [].obs;

class WMSInventoryScreen extends StatefulWidget {
  @override
  State<WMSInventoryScreen> createState() => _WMSInventoryScreenState();
}

class _WMSInventoryScreenState extends State<WMSInventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? dropDownValue = "itemid";
  List<String> dropDownList = [
    "itemid",
    "binlocation",
  ];

  String? dropDownValue1;
  List<String>? dropDownList1 = [];

  String total = "0";

  List<getInventTableWMSDataByItemIdOrItemNameModel> BinToBinJournalTableList =
      [];

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
    getAllTblUsersController.getData().then((value) {
      setState(() {
        dropDownList1 =
            value.map((e) => "${e.fullname!} - ${e.userID}").toList();

        dropDownValue1 = dropDownList1!.first.toString();
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    markedList.clear();
    BinToBinJournalTableList.clear();
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
            title: "WMS Inventory".toUpperCase(),
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
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Search",
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
                          hintText: "Search item...",
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
                              // if item is already in the list then dont add it again
                              if (BinToBinJournalTableList.any((element) =>
                                  element.iTEMID == value[0].iTEMID)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item already exists!"),
                                  ),
                                );
                                Navigator.of(context).pop();
                                return;
                              }
                              setState(() {
                                itemName = "${value[0].iTEMNAME}";
                                itemID = "${value[0].iTEMID}";
                                itemGroupId = "${value[0].iTEMGROUPID}";
                                groupName = "${value[0].gROUPNAME}";

                                // append the new entry BinToBinJournalList
                                BinToBinJournalTableList.add(value[0]);
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
                SingleChildScrollView(
                  child: PaginatedDataTable(
                    // header: Text(
                    //   "Total: $total",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.blue[900]!,
                    //   ),
                    // ),

                    columnSpacing: 10,
                    horizontalMargin: 20,
                    showCheckboxColumn: false,
                    headingRowHeight: 30,
                    dataRowHeight: 60,
                    primary: true,
                    showFirstLastButtons: true,
                    source:
                        StudentDataSource(BinToBinJournalTableList, context),
                    rowsPerPage: 5,
                    checkboxHorizontalMargin: 10,
                    columns: [
                      DataColumn(
                          label: Text(
                        'Item Id',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900]!,
                        ),
                      )),
                      DataColumn(
                        label: Text(
                          'Item Name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900]!,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Item Group Id',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900]!,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Group Name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900]!,
                          ),
                        ),
                      ),
                    ], // Adjust the number of rows per page as needed
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Assign To:",
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
                    items: dropDownList1!,
                    onChanged: (value) {
                      setState(() {
                        dropDownValue1 = value!;
                      });
                    },
                    selectedItem: dropDownValue1,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButtonWidget(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    title: "Save",
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Constants.showLoadingDialog(context);
                      insertIntoWmsJournalCountingOnlyCLController
                          .postData(
                        BinToBinJournalTableList,
                        "",
                        dropDownValue1.toString(),
                      )
                          .then((value) {
                        Get.back();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Assigned Successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          BinToBinJournalTableList.clear();
                          selectedRow.clear();
                          markedList.value = List.generate(
                              BinToBinJournalTableList.length,
                              (index) => false);
                          _searchController.clear();
                        });
                      }).onError((error, stackTrace) {
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                error.toString().replaceAll("Exception:", "")),
                            backgroundColor: Colors.red,
                          ),
                        );
                        setState(() {
                          selectedRow.clear();
                          markedList.value = List.generate(
                              BinToBinJournalTableList.length,
                              (index) => false);
                        });
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentDataSource extends DataTableSource {
  List<getInventTableWMSDataByItemIdOrItemNameModel> students;
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
        DataCell(SelectableText(student.iTEMID ?? "")),
        DataCell(SelectableText(student.iTEMNAME ?? "")),
        DataCell(SelectableText(student.iTEMGROUPID ?? "")),
        DataCell(SelectableText(student.gROUPNAME ?? "")),
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
