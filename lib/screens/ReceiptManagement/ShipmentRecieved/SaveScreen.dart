import '../../../controllers/WareHouseOperationController/InsertShipmentReceivedData.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/TextFormField.dart';
import '../../../widgets/TextWidget.dart';
import 'package:flutter/material.dart';

import 'ShipmentDispatchingScreen.dart';

// ignore: must_be_immutable
class SaveScreen extends StatefulWidget {
  String shipmentStatus;
  String shipmentId;
  String entity;
  String containerId;
  String arrivalWarehouse;
  String itemName;
  String qty;
  String itemId;
  String purchId;
  String classification;
  String gtin;
  String receivingZone;
  int receivedQty;

  SaveScreen({
    super.key,
    required this.shipmentStatus,
    required this.shipmentId,
    required this.entity,
    required this.containerId,
    required this.arrivalWarehouse,
    required this.itemName,
    required this.qty,
    required this.itemId,
    required this.purchId,
    required this.classification,
    required this.gtin,
    required this.receivingZone,
    required this.receivedQty,
  });

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final TextEditingController _jobOrderNoController = TextEditingController();
  final TextEditingController _containerNoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();

  FocusNode firstFocusNode = FocusNode();
  FocusNode secondFocusNode = FocusNode();

  void method() {
    Constants.showLoadingDialog(context);
    FocusScope.of(context).unfocus();

    InsertShipmentReceivedDataController.insertShipmentData(
      widget.shipmentId,
      widget.containerId,
      widget.arrivalWarehouse,
      widget.itemName,
      widget.itemId,
      widget.purchId,
      int.parse(widget.classification),
      _serialNoController.text,
      dropdownValue,
      DateTime.now().toString(),
      widget.gtin,
      widget.receivingZone,
      DateTime.now().toString(),
      "PalletCode123",
      "BIN123",
      _remarksController.text,
      int.parse(widget.qty),
    ).then((value) {
      setState(() {
        serialNoList.add(_serialNoController.text);
        configList.add(dropdownValue);
        remarksList.add(_remarksController.text);

        _serialNoController.clear();
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Serial Number already exists."),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _jobOrderNoController.text = widget.shipmentId;
    _containerNoController.text = widget.containerId;
    _itemNameController.text = widget.itemName;
  }

  @override
  void dispose() {
    firstFocusNode.removeListener(() {});
    secondFocusNode.removeListener(() {});
    super.dispose();
  }

  String dropdownValue = 'G';
  List<String> dropdownList = ['G', 'D', 'DC', 'MCI', 'S'];

  List<String> serialNoList = [];
  List<String> configList = [];
  List<String> remarksList = [];

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
            children: <Widget>[
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
                  margin: const EdgeInsets.only(left: 20, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/delete.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      const TextWidget(
                        text: "JOB ORDER NO*",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      TextFormFieldWidget(
                        controller: _jobOrderNoController,
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: "Job Order No",
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      const TextWidget(
                        text: "CONTAINER NO*",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      TextFormFieldWidget(
                        controller: _containerNoController,
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: "Container No",
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const TextWidget(
                                  text: "Item Code:",
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: "Quantity*\n${widget.qty}",
                                  fontSize: 15,
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextWidget(
                                  text: widget.itemId,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: "Received*\n$RCQTY",
                                  fontSize: 15,
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const TextWidget(
                                  text: "CON",
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: widget.classification,
                                  fontSize: 15,
                                  color: Colors.white,
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
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Item Name",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _itemNameController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Item Name/Description",
                  readOnly: true,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Remarks",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _remarksController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter Remarks (User Input  )",
                ),
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "List of Item Config",
                  fontSize: 15,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(left: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: dropdownList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Enter Serial Number",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  focusNode: secondFocusNode,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan GTIN Number",
                  autofocus: false,
                  controller: _serialNoController,
                  onFieldSubmitted: (p0) {
                    if (_serialNoController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Enter/Scan Serial No."),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    Constants.showLoadingDialog(context);
                    FocusScope.of(context).unfocus();
                    InsertShipmentReceivedDataController.insertShipmentData(
                      widget.shipmentId,
                      widget.containerId,
                      widget.arrivalWarehouse,
                      widget.itemName,
                      widget.itemId,
                      widget.purchId,
                      int.parse(widget.classification),
                      _serialNoController.text,
                      dropdownValue,
                      DateTime.now().toString(),
                      widget.gtin,
                      widget.receivingZone,
                      DateTime.now().toString(),
                      "",
                      "",
                      _remarksController.text,
                      int.parse(widget.qty),
                    ).then((value) {
                      setState(() {
                        serialNoList.add(_serialNoController.text);
                        configList.add(dropdownValue);
                        remarksList.add(_remarksController.text);

                        RCQTY = RCQTY + 1;

                        _serialNoController.clear();
                        // focus back to serial no field
                        FocusScope.of(context).requestFocus(secondFocusNode);
                      });
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Serial Number already exists.!"),
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                            label: Expanded(
                          child: Text(
                            'SERIAL NO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'CONFIG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                          label: Text(
                            'Remarks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        serialNoList.length,
                        (index) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                serialNoList[index],
                                style: TextStyle(
                                  color: Colors.blue[900]!,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                dropdownValue,
                                style: TextStyle(
                                  color: Colors.blue[900]!,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                remarksList[index],
                                style: TextStyle(
                                  color: Colors.blue[900]!,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Center(
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: Container(
              //       width: MediaQuery.of(context).size.width * 0.4,
              //       height: 50,
              //       decoration: BoxDecoration(
              //         color: Colors.orange,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Center(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             const TextWidget(
              //               text: "SAVE",
              //               fontSize: 20,
              //               color: Colors.white,
              //             ),
              //             Image.asset(
              //               'assets/save.png',
              //               height: 25,
              //               width: 25,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
