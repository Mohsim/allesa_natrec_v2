import 'package:alessa_v2/controllers/PhysicalInventory/getWmsJournalCountingOnlyCLByAssignedToUserIdController.dart';
import 'package:alessa_v2/models/getWmsJournalCountingOnlyCLByAssignedToUserIdModel.dart';
import 'package:alessa_v2/utils/Constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/AppBarWidget.dart';

Map<String, dynamic> selectedRow = {};
RxList<dynamic> markedList = [].obs;

class Testing extends StatefulWidget {
  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  List<getWmsJournalCountingOnlyCLByAssignedToUserIdModel> table = [];

  @override
  void initState() {
    super.initState();
    getWmsJournalCountingOnlyCLByAssignedToUserIdController
        .getData()
        .then((value) {
      Constants.showLoadingDialog(context);
      setState(() {
        table = value;
      });
      Navigator.of(context).pop();
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
            title: "Testing".toUpperCase(),
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PaginatedDataTable(
                  showCheckboxColumn: false,
                  columns: const [
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
                      'ITEM GROUP ID',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'GROUP NAME',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'INVENTORY BY',
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
                      'TRX USER ID ASSIGNED',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'TRX USER ID ASSIGNED BY',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY SCANNED',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY DIFFERENCE',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY ON HAND',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'JOURNAL ID',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'BIN LOCATION',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: StudentDataSource(table, context),
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
  List<getWmsJournalCountingOnlyCLByAssignedToUserIdModel> students;
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
        DataCell(Text(student.iTEMID ?? "")),
        DataCell(Text(student.iTEMNAME ?? "")),
        DataCell(Text(student.iTEMGROUPID ?? "")),
        DataCell(Text(student.gROUPNAME ?? "")),
        DataCell(Text(student.iNVENTORYBY ?? "")),
        DataCell(Text(student.tRXDATETIME ?? "")),
        DataCell(Text(student.tRXUSERIDASSIGNED ?? "")),
        DataCell(Text(student.tRXUSERIDASSIGNEDBY ?? "")),
        DataCell(Text(student.qTYSCANNED.toString())),
        DataCell(Text(student.qTYDIFFERENCE.toString())),
        DataCell(Text(student.qTYONHAND.toString())),
        DataCell(Text(student.jOURNALID.toString())),
        DataCell(Text(student.bINLOCATION ?? "")),
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
