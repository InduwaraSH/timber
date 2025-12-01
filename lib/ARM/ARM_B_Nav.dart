import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/ARM/ARM_Home.dart';
import 'package:timber_app/ARM/ARM_Recived.dart';
import 'package:timber_app/ARM/ARM_Sent.dart';

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
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    Get.delete<ARMNavigControll>();
    arm_controller = Get.put(
      ARMNavigControll(widget.office_location, widget.username),
    );
  }

  /// Wrap screen with scroll detection
  Widget _attachScrollListener(Widget screen) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.reverse) {
          _toggleNavBar(false); // Hide on scroll down
        } else if (notification.direction == ScrollDirection.forward) {
          _toggleNavBar(true); // Show on scroll up
        }
        return false;
      },
      child: screen,
    );
  }

  void _toggleNavBar(bool visible) {
    if (_isNavVisible != visible) {
      setState(() => _isNavVisible = visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Active screen with scroll detection
            _attachScrollListener(
              arm_controller.screens[arm_controller.selectedIndex.value],
            ),

            // Glass-style floating navigation bar
            Positioned(
              left: 18,
              right: 18,
              bottom: 8,
              child: AnimatedSlide(
                offset: _isNavVisible ? Offset.zero : const Offset(0, 2),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _isNavVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    height: 90,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(38),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            height: 82,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(38),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.03),
                              ),
                            ),

                            child: Row(
                              children: List.generate(
                                arm_controller.items.length,
                                (index) {
                                  final item = arm_controller.items[index];
                                  final bool active =
                                      arm_controller.selectedIndex.value ==
                                      index;
                                  final int flex = active ? 2 : 1;

                                  return Expanded(
                                    flex: flex,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () =>
                                          arm_controller.selectedIndex.value =
                                              index,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 420,
                                        ),
                                        curve: Curves.easeOutCubic,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: active
                                              ? Colors.white.withOpacity(0.06)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 320,
                                              ),
                                              curve: Curves.easeOut,
                                              padding: EdgeInsets.all(
                                                active ? 8 : 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: active
                                                    ? Colors.white.withOpacity(
                                                        0.08,
                                                      )
                                                    : Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: AnimatedScale(
                                                scale: active ? 1.25 : 1.0,
                                                duration: const Duration(
                                                  milliseconds: 280,
                                                ),
                                                curve: Curves.easeOutBack,
                                                child: Icon(
                                                  item['icon'],
                                                  size: 24,
                                                  color: active
                                                      ? Colors.white
                                                      : Colors.grey[400],
                                                ),
                                              ),
                                            ),

                                            Flexible(
                                              child: AnimatedSize(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                                child: AnimatedOpacity(
                                                  opacity: active ? 1 : 0,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: active ? 7 : 0,
                                                    ),
                                                    child: Text(
                                                      active
                                                          ? item['label']
                                                          : '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        letterSpacing: 0.2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
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
}

class ARMNavigControll extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String office_location;
  final String username;

  ARMNavigControll(this.office_location, this.username);

  late final List<Map<String, dynamic>> items = [
    {'icon': Iconsax.home, 'label': 'Home'},
    {'icon': Iconsax.message4, 'label': 'Inbox'},
    {'icon': Iconsax.send_24, 'label': 'Sent'},
  ];

  late final List<Widget> screens = [
    ARM_Home(office_location: office_location, username: username),
    ARMReceived(office_location: office_location, username: username),
    ARM_Sent(office_location: office_location, username: username),
  ];
}
