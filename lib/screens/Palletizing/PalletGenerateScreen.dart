import '../../controllers/Palletization/GenerateAndUpdatePalletIdController.dart';
import '../../controllers/Palletization/GetAlltblBinLocationsController.dart';
import '../../controllers/Palletization/ValidateShipmentPalettizingSerialNo.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextFormField.dart';
import '../../../../widgets/TextWidget.dart';
import '../../models/GetAlltblBinLocationsModel.dart';
import '../../utils/Constants.dart';
import '../HomeScreen.dart';

// ignore: must_be_immutable
class PalletGenerateScreen extends StatefulWidget {
  String tRANSFERID;
  int tRANSFERSTATUS;
  String iNVENTLOCATIONIDFROM;
  String iNVENTLOCATIONIDTO;
  String iTEMID;
  String iNVENTDIMID;
  int qTYTRANSFER;
  int qTYREMAINRECEIVE;
  String cREATEDDATETIME;

  PalletGenerateScreen({
    required this.tRANSFERID,
    required this.tRANSFERSTATUS,
    required this.iNVENTLOCATIONIDFROM,
    required this.iNVENTLOCATIONIDTO,
    required this.iTEMID,
    required this.iNVENTDIMID,
    required this.qTYTRANSFER,
    required this.qTYREMAINRECEIVE,
    required this.cREATEDDATETIME,
  });

  @override
  State<PalletGenerateScreen> createState() => _PalletGenerateScreenState();
}

class _PalletGenerateScreenState extends State<PalletGenerateScreen> {
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _palletTypeController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _rowController = TextEditingController();

  String? dropdownValue;
  List<String> dropdownList = [];

  String result = "0";
  List<String> serialNoList = [];
  List<bool> isMarked = [];

  List<GetAlltblBinLocationsModel> getAlltblBinLocationsModelList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      Constants.showLoadingDialog(context);
      GetAlltblBinLocationsController.getShipmentPalletizing().then((value) {
        setState(() {
          dropdownList = value.map((e) {
            return "${e.palletTotalSize.toString()} X ${e.palletType.toString()}";
          }).toList();
          dropdownValue = dropdownList[0];
          _widthController.text = value[0].palletWidth.toString();
          _heightController.text = value[0].palletHeight.toString();
          _lengthController.text = value[0].palletLength.toString();
          _rowController.text = value[0].palletRow.toString();
          getAlltblBinLocationsModelList = value;
        });
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _serialNoController.dispose();
    _palletTypeController.dispose();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const TextWidget(
                                text: "Shipment Palletizing",
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width * 0.1,
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                "assets/delete.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: [
                                const Text(
                                  "Transfer Id",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.tRANSFERID,
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
                                  "QTY Transfer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.qTYTRANSFER.toString(),
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
                                  "Status",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.tRANSFERSTATUS.toString(),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Select the Type of Pallet",
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
                      hintText: "Select Pallet Type",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      _palletTypeController.text = value!;
                      dropdownValue = value;

                      // select it from the index no of the dropdown list
                      _widthController.text = getAlltblBinLocationsModelList[
                              dropdownList.indexOf(value)]
                          .palletWidth
                          .toString();
                      _heightController.text = getAlltblBinLocationsModelList[
                              dropdownList.indexOf(value)]
                          .palletHeight
                          .toString();
                      _rowController.text = getAlltblBinLocationsModelList[
                              dropdownList.indexOf(value)]
                          .palletLength
                          .toString();
                      _lengthController.text = getAlltblBinLocationsModelList[
                              dropdownList.indexOf(value)]
                          .palletRow
                          .toString();
                    });
                  },
                  selectedItem: dropdownValue,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                    text: "Width",
                    fontSize: 15,
                  ),
                  TextWidget(
                    text: "Height",
                    fontSize: 15,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormFieldWidget(
                    controller: _widthController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Width",
                  ),
                  TextFormFieldWidget(
                    controller: _heightController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Height",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                    text: "Length",
                    fontSize: 15,
                  ),
                  TextWidget(
                    text: "Row",
                    fontSize: 15,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormFieldWidget(
                    controller: _lengthController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Length",
                  ),
                  TextFormFieldWidget(
                    controller: _rowController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Row",
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  hintText: "Enter/Scan Serial No",
                  controller: _serialNoController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    ValidateShipmentPalettizingSerialNoController
                            .palletizeSerialNo(_serialNoController.text)
                        .then((value) => {
                              if (value == "Success: SHIPMENTID matches")
                                {
                                  if (serialNoList.contains(
                                      _serialNoController.text.toString()))
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Serial No already exists"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      ),
                                    }
                                  else
                                    {
                                      serialNoList.add(
                                          _serialNoController.text.toString()),
                                      setState(() {})
                                    }
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  ),
                                }
                            });
                  },
                  onFieldSubmitted: (p0) {},
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: 10,
                  bottom: 10,
                ),
                child: const Text(
                  "Serial No:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: serialNoList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              serialNoList[index].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Generate",
                  onPressed: () {
                    GenerateAndUpdatePalletIdController
                            .generateAndUpdatePalletId(serialNoList)
                        .then(
                      (value) {
                        if (value ==
                            "Pallet IDs generated and updated successfully.") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          setState(() {
                            serialNoList.clear();
                            _serialNoController.clear();
                          });
                          Get.offAll(const HomeScreen());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
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
