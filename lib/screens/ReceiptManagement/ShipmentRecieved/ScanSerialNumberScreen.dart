import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/WareHouseOperationController/GetAllTableZoneController.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/ElevatedButtonWidget.dart';
import '../../../widgets/TextFormField.dart';
import '../../../widgets/TextWidget.dart';
import 'SaveScreen.dart';
import 'ShipmentDispatchingScreen.dart';

// ignore: must_be_immutable
class ScanSerialNumberScreen extends StatefulWidget {
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
  int receivedQty;

  ScanSerialNumberScreen({
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
    required this.receivedQty,
  });

  @override
  State<ScanSerialNumberScreen> createState() => _ScanSerialNumberScreenState();
}

class _ScanSerialNumberScreenState extends State<ScanSerialNumberScreen> {
  final TextEditingController _jobOrderNoController = TextEditingController();
  final TextEditingController _containerNoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _gtinNoController = TextEditingController();
  final TextEditingController _receivingZoneController =
      TextEditingController();

  String dropdownValue = 'Select Zone';
  List<String> dropdownList = ['Select Zone'];

  @override
  void initState() {
    super.initState();

    _jobOrderNoController.text = widget.shipmentId;
    _containerNoController.text = widget.containerId;
    _itemNameController.text = widget.itemName;

    Future.delayed(const Duration(seconds: 0), () {
      Constants.showLoadingDialog(context);
      GetAllTableZoneController.getAllTableZone().then((value) {
        dropdownValue = dropdownList[0];
        for (int i = 0; i < value.length; i++) {
          dropdownList.add(value[i].rZONE.toString());
        }
        setState(() {});
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      });
    });
  }

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
                                  fontSize: 16,
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
                                  fontSize: 16,
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
                                  fontSize: 16,
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "GTIN",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _gtinNoController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan GTIN No",
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Receiving Zone",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: dropdownList,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    baseStyle: TextStyle(fontSize: 15),
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter/Scan Receiving Zone",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      _receivingZoneController.text = value!;
                      dropdownValue = value;
                    });
                  },
                  selectedItem: "Select Receiving Zone",
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButtonWidget(
                  title: "Scan Serial Number",
                  onPressed: () {
                    if (_gtinNoController.text.trim().isEmpty ||
                        dropdownValue == "Select Zone") {
                      print(dropdownValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please enter GTIN No and select Receiving Zone"),
                        ),
                      );
                      return;
                    }
                    Get.to(() => SaveScreen(
                          shipmentStatus: widget.shipmentStatus,
                          shipmentId: widget.shipmentId,
                          qty: widget.qty,
                          itemName: widget.itemName,
                          arrivalWarehouse: widget.arrivalWarehouse,
                          classification: widget.classification,
                          containerId: widget.containerId,
                          entity: widget.entity,
                          gtin: _gtinNoController.text.trim(),
                          itemId: widget.itemId,
                          purchId: widget.purchId,
                          receivingZone: dropdownValue,
                          receivedQty: widget.receivedQty,
                        ));
                  },
                  textColor: Colors.white,
                  fontSize: 18,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
