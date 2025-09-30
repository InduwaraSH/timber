import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/Home_page.dart';
import 'package:timber_app/RM/RM_Sent.dart';
import 'package:timber_app/b.dart';
import 'package:timber_app/c.dart';
import 'package:timber_app/d.dart';

class co_b_navbar extends StatefulWidget {
  final String office_location;
  const co_b_navbar({super.key, required this.office_location});

  @override
  State<co_b_navbar> createState() => _co_b_navbarState();
}

class _co_b_navbarState extends State<co_b_navbar> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigControll(widget.office_location));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        body: Obx(
          () => Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Page content
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 0,
                  ), // space for nav bar
                  child: controller.screens[controller.selectedIndex.value],
                ),

                // Floating nav bar with shadow
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
                          currentIndex: controller.selectedIndex.value,
                          onTap: (index) =>
                              controller.selectedIndex.value = index,
                          backgroundColor: Colors.white,
                          type: BottomNavigationBarType.fixed,
                          elevation: 0,
                          selectedItemColor: Colors.green,
                          unselectedItemColor: Colors.green[300],
                          showUnselectedLabels: true,
                          selectedFontSize: 12,
                          selectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedFontSize: 12,
                          items: [
                            _navItem(
                              Iconsax.home,
                              "Home",
                              controller.selectedIndex.value == 0,
                            ),
                            _navItem(
                              Iconsax.send_24,
                              "Sent",
                              controller.selectedIndex.value == 1,
                            ),
                            _navItem(
                              Iconsax.arrow_down_24,
                              "Received",
                              controller.selectedIndex.value == 2,
                            ),
                            _navItem(
                              Iconsax.chart_2,
                              "Statistics",
                              controller.selectedIndex.value == 3,
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
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, bool active) {
    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: active ? 1.2 : 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: Icon(icon, color: active ? Colors.green : Colors.green[300]),
        ),
      ),
      label: label,
    );
  }
}

class NavigControll extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String office_location;

  NavigControll(this.office_location);

  late final List<Widget> screens = [
    page(office_location: office_location),
    RmSent(office_location: office_location),
    pgthree(office_location: office_location),
    pgfour(office_location: office_location),
  ];
}
