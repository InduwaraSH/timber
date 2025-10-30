import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:timber_app/RM/RM_Home.dart';
import 'package:timber_app/RM/RM_Recived.dart';
import 'package:timber_app/RM/RM_Sent.dart';
import 'package:timber_app/c.dart';
import 'package:timber_app/d.dart';

class RmBNavbar extends StatefulWidget {
  final String office_location;
  final String username;

  const RmBNavbar({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<RmBNavbar> createState() => _RmBNavbarState();
}

class _RmBNavbarState extends State<RmBNavbar> {
  late final RMNavigControll rm_controller;
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    Get.delete<RMNavigControll>();
    rm_controller = Get.put(
      RMNavigControll(widget.office_location, widget.username),
    );
  }

  /// This method allows each child page to call hide/show based on its scroll
  void toggleNavBarVisibility(bool visible) {
    if (_isNavVisible != visible) {
      setState(() => _isNavVisible = visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // current active screen
            _attachScrollListener(
              rm_controller.screens[rm_controller.selectedIndex.value],
            ),

            // Animated floating nav bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _isNavVisible ? Offset.zero : const Offset(0, 2),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isNavVisible ? 1 : 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 255, 255, 255),
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
                          currentIndex: rm_controller.selectedIndex.value,
                          onTap: (index) =>
                              rm_controller.selectedIndex.value = index,
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
                              rm_controller.selectedIndex.value == 0,
                            ),
                            _navItem(
                              Iconsax.send_24,
                              "Sent",
                              rm_controller.selectedIndex.value == 1,
                            ),
                            _navItem(
                              Iconsax.arrow_down_24,
                              "Inbox",
                              rm_controller.selectedIndex.value == 2,
                            ),
                            _navItem(
                              Iconsax.chart_2,
                              "Statistics",
                              rm_controller.selectedIndex.value == 3,
                            ),
                          ],
                        ),
                      ),
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

  /// Attach scroll detection to the screen (works if that screen uses ListView/SingleChildScrollView)
  Widget _attachScrollListener(Widget screen) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.reverse) {
          toggleNavBarVisibility(false);
        } else if (notification.direction == ScrollDirection.forward) {
          toggleNavBarVisibility(true);
        }
        return false;
      },
      child: screen,
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

class RMNavigControll extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String office_location;
  final String username;

  RMNavigControll(this.office_location, this.username);

  late final List<Widget> screens = [
    RMHomepage(office_location: office_location, username: username),
    RmSent(office_location: office_location),
    RMRecived(office_location: office_location),
    pgfour(office_location: office_location),
  ];
}
