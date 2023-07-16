import '../../screens/Palletizing/PalletGenerateScreen.dart';
import '../../utils/Constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ElevatedButtonWidget.dart';
import '../../../../widgets/TextWidget.dart';
import '../../controllers/WareHouseOperationController/GetAllTableZoneController.dart';

// ignore: must_be_immutable
class PalletProceedScreen extends StatefulWidget {
  String ALS_PACKINGSLIPREF;
  int ALS_TRANSFERORDERTYPE;
  String TRANSFERID;
  String INVENTLOCATIONIDFROM;
  String INVENTLOCATIONIDTO;
  int QTYTRANSFER;
  String ITEMID;
  String ITEMNAME;
  String CONFIGID;
  String WMSLOCATIONID;
  String SHIPMENTID;

  PalletProceedScreen({
    super.key,
    required this.ALS_PACKINGSLIPREF,
    required this.ALS_TRANSFERORDERTYPE,
    required this.TRANSFERID,
    required this.INVENTLOCATIONIDFROM,
    required this.INVENTLOCATIONIDTO,
    required this.QTYTRANSFER,
    required this.ITEMID,
    required this.ITEMNAME,
    required this.CONFIGID,
    required this.WMSLOCATIONID,
    required this.SHIPMENTID,
  });

  @override
  State<PalletProceedScreen> createState() => _PalletProceedScreenState();
}

class _PalletProceedScreenState extends State<PalletProceedScreen> {
  final TextEditingController _receivingZoneController =
      TextEditingController();

  String dropdownValue = 'Select Zone';
  List<String> dropdownList = ['Select Zone'];

  String result = "0";
  List<bool> isMarked = [];
  List<String> receivingZoneList = [];

  @override
  void initState() {
    super.initState();
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
                          const Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              TextWidget(
                                text: "Shipment Palletizing",
                                color: Colors.white,
                                fontSize: 25,
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
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Item Name:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.ITEMNAME,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "List of Recieving Zones",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                      receivingZoneList.add(value);
                    });
                  },
                  selectedItem: dropdownValue,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: receivingZoneList.length,
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
                              receivingZoneList[index].toString(),
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
                  title: "Proceed",
                  onPressed: () {
                    Get.to(() => PalletGenerateScreen(
                          receivedZoneList: receivingZoneList,
                          ALS_PACKINGSLIPREF: widget.ALS_PACKINGSLIPREF,
                          ALS_TRANSFERORDERTYPE: widget.ALS_TRANSFERORDERTYPE,
                          CONFIGID: widget.CONFIGID,
                          INVENTLOCATIONIDFROM: widget.INVENTLOCATIONIDFROM,
                          INVENTLOCATIONIDTO: widget.INVENTLOCATIONIDTO,
                          ITEMID: widget.ITEMID,
                          ITEMNAME: widget.ITEMNAME,
                          QTYTRANSFER: widget.QTYTRANSFER,
                          TRANSFERID: widget.TRANSFERID,
                          SHIPMENTID: widget.SHIPMENTID,
                          WMSLOCATIONID: widget.WMSLOCATIONID,
                        ));
                  },
                  textColor: Colors.white,
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
