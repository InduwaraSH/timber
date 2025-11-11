import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/CO_Recive.dart';
import 'package:timber_app/CO/CO_Sent.dart';
import 'package:timber_app/d.dart';

class co_b_navbar extends StatefulWidget {
  final String office_location;
  final String username;

  const co_b_navbar({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<co_b_navbar> createState() => _co_b_navbarState();
}

class _co_b_navbarState extends State<co_b_navbar> {
  late final CONavigControll coController;
  bool _isVisible = true; // visibility of bottom bar

  @override
  void initState() {
    super.initState();
    Get.delete<CONavigControll>();
    coController = Get.put(
      CONavigControll(widget.office_location, widget.username),
    );
  }

  void _onUserScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      final direction = notification.direction;
      if (direction == ScrollDirection.reverse && _isVisible) {
        setState(() => _isVisible = false);
      } else if (direction == ScrollDirection.forward && !_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Wrap content to detect user scroll
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                _onUserScroll(scrollNotification);
                return false;
              },
              child: coController.screens[coController.selectedIndex.value],
            ),

            // Animated bottom navigation bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              left: 16,
              right: 16,
              bottom: _isVisible ? 0 : -120,
              child: SafeArea(
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
                      currentIndex: coController.selectedIndex.value,
                      onTap: (index) =>
                          coController.selectedIndex.value = index,
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black45,
                      showUnselectedLabels: true,
                      selectedFontSize: 13,
                      selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "sfproRoundSemiB",
                      ),
                      unselectedFontSize: 12,
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: "sfproRoundSemiB",
                      ),
                      items: [
                        _navItem(
                          Iconsax.arrow_down_24,
                          "Inbox",
                          coController.selectedIndex.value == 0,
                        ),
                        _navItem(
                          Iconsax.send_24,
                          "Sent",
                          coController.selectedIndex.value == 1,
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
          child: Icon(icon, color: active ? Colors.black : Colors.black45),
        ),
      ),
      label: label,
    );
  }
}

class CONavigControll extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String office_location;
  final String username;

  CONavigControll(this.office_location, this.username);

  late final List<Widget> screens = [
    CORecived(office_location: office_location, username: username),
    CO_Sent(office_location: office_location, username: username),
  ];
}
