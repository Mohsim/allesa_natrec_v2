import 'package:auto_size_text/auto_size_text.dart';

import '../../screens/Authentication/LoginScreen.dart';
import '../../screens/CycleCounting/CycleCountingScreen1.dart';
import '../../screens/DispatchingForm/DispatchingFormScreen.dart';
import '../../screens/JournalMovement/JournalMovementScreen1.dart';
import '../../screens/PhysicalInventory/PhysicalInventoryScreen.dart';
import '../../screens/ProfitAndLoss/ProfitAndLossScreen1.dart';
import '../../screens/ReturnRMA/ReturnRMAScreen1.dart';
import '../../screens/WMSInventory/WMSInventoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Core/Animation/Fade_Animation.dart';
import '../../screens/BinToBinAXAPTA/BinToBinAxaptaScreen.dart';
import '../../screens/BinToBinInternal/BinToBinInternalScreen.dart';
import '../../screens/BinToBinJournal/BinToBinJournalScreen.dart';
import '../../screens/ItemReAllocation/ItemReAllocationScreen.dart';
import '../../screens/Palletizing/ShipmentPalletizingScreen.dart';
import '../../screens/PutAway/PutAwayScreen.dart';
import 'ReceiptManagement/ShipmentDispatchingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BarcodeMapping/BarcodeMappingScreen.dart';
import 'PhysicalInverntoryByBinLocation/PhysicalInventoryByBinLocationScreen.dart';
import 'PickListAssigned/PickListAssignedScreen.dart';
import 'RMAputaway/RMAPutawayScreen.dart';
import 'ReceivedByContainer/ReceivedByContainer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> data = {
    "images": [
      "assets/picking.png",
      "assets/receipt_management.png",
      "assets/container.png",
      "assets/work_in_progress.png",
      "assets/stock_management.png",
      "assets/gtin_tracking.png",
      "assets/physical_invention.png",
      "assets/log-in.png",
      "assets/journal.png",
      "assets/allocation.png",
      "assets/movement.png",
      "assets/profit-and-loss.png",
      "assets/cycle-counting.png",
      "assets/product-return.png",
      "assets/put-away.png",
      "assets/inventory.png",
      "assets/wms-inventory.png",
      "assets/inventory-location.png",
      "assets/barcode.png",
      "assets/logout.jpg",
    ],
    "titles": [
      "Picking Slip",
      "Receipt Management",
      "Received By Container",
      "Dispatching",
      "Put-Away Transaction",
      "Palletization",
      "Bin To Bin (AXAPTA)",
      "Bin To Bin (Internal)",
      "Bin To Bin (Journal)",
      "Item Re-Allocation",
      "Journal Movement Counting",
      "Profit and Loss",
      "Cycle Counting Process",
      "Return RMA",
      "RMA Put-Away",
      "WMS Inventory",
      "WMS Physical Inventory",
      "Inventory by Bin Location",
      "Barcode Mapping",
      "Logout",
    ],
    "functions": [
      () {
        Get.to(() => const PickListAssignedScreen());
      },
      () {
        Get.to(() => const ShipmentDispatchingScreen());
      },
      () {
        Get.to(() => const ReceivedByContainer());
      },
      () {
        Get.to(() => const DispatchingFormScreen());
      },
      () {
        Get.to(() => const PutAwayScreen());
      },
      () {
        Get.to(() => const ShipmentPalletizingScreen());
      },
      () {
        Get.to(() => const BinToBinAxaptaScreen());
      },
      () {
        Get.to(() => const BinToBinInternalScreen());
      },
      () {
        Get.to(() => const BinToBinJournalScreen());
      },
      () {
        Get.to(() => const ItemReAllocationScreen());
      },
      () {
        Get.to(() => const JournalMovementScreen1());
      },
      () {
        Get.to(() => const ProfitAndLossScreen1());
      },
      () {
        Get.to(() => const CycleCountingScreen1());
      },
      () {
        Get.to(() => const ReturnRMAScreen1());
      },
      () {
        Get.to(() => const RMAPutawayScreen());
      },
      () {
        Get.to(() => WMSInventoryScreen());
      },
      () {
        Get.to(() => const PhysicalInventoryScreen());
      },
      () {
        Get.to(() => const PhysicalInventoryByBinLocationScreen());
      },
      () {
        Get.to(() => BarcodeMappingScreen());
      },
      () {
        Get.offAll(() => LoginScreen());
      },
    ],
  };

  void _showUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('userId');
    String? fullName = prefs.getString('fullName');
    String? userLevel = prefs.getString('userLevel');
    String? loc = prefs.getString('userLocation');

    print('token: $token');
    print('userId: $userId');
    print('fullName: $fullName');
    print('userLevel: $userLevel');
    print('loc: $loc');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // show a dialog when the back button is pressed
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeAnimation(
                        delay: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            'assets/alessa.png',
                            width: 150,
                            height: 80,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text('Do you want to exit an App'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: Image.asset(
                            "assets/back_button.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.black, thickness: 1),
                FadeAnimation(
                  delay: 1,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          child: Image.asset(
                            data["images"][index],
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: AutoSizeText(data["titles"][index]),
                        onTap: data["functions"][index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.black, thickness: 1);
                    },
                    itemCount: data["images"].length,
                  ),
                ),
                const Divider(color: Colors.black, thickness: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
