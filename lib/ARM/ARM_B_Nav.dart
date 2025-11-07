import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/ARM/ARM_Home.dart';
import 'package:timber_app/ARM/ARM_Recived.dart';
import 'package:timber_app/ARM/ARM_Sent.dart';

import 'package:timber_app/d.dart';

class arm_b_nav_bar extends StatefulWidget {
  final String office_location;
  final String username;
  const arm_b_nav_bar({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<arm_b_nav_bar> createState() => _arm_b_nav_barState();
}

class _arm_b_nav_barState extends State<arm_b_nav_bar> {
  late final ARMNavigControll arm_controller;

  @override
  void initState() {
    super.initState();
    Get.delete<ARMNavigControll>();
    arm_controller = Get.put(
      ARMNavigControll(widget.office_location, widget.username),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Page content
            arm_controller.screens[arm_controller.selectedIndex.value],

            // Floating bottom nav bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(150, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BottomNavigationBar(
                      currentIndex: arm_controller.selectedIndex.value,
                      onTap: (index) =>
                          arm_controller.selectedIndex.value = index,
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.grey,
                      showUnselectedLabels: true,
                      selectedFontSize: 12,
                      selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedFontSize: 12,
                      items: [
                        _navItem(
                          Iconsax.home,
                          "Home",
                          arm_controller.selectedIndex.value == 0,
                        ),
                        _navItem(
                          Iconsax.send_24,
                          "Sent",
                          arm_controller.selectedIndex.value == 1,
                        ),
                        _navItem(
                          Iconsax.arrow_down_24,
                          "Inbox",
                          arm_controller.selectedIndex.value == 2,
                        ),
                        _navItem(
                          Iconsax.chart_2,
                          "Statistics",
                          arm_controller.selectedIndex.value == 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, bool active) {
    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: active ? 1.3 : 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: Icon(icon, color: active ? Colors.black : Colors.grey),
        ),
      ),
      label: label,
    );
  }
}

class ARMNavigControll extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String office_location;
  final String username;

  ARMNavigControll(this.office_location, this.username);

  late final List<Widget> screens = [
    ARM_Home(office_location: office_location, username: username),
    ARM_Sent(office_location: office_location),
    ARMReceived(office_location: office_location, username: username),
    pgfour(office_location: office_location),
  ];
}
