import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:timber_app/RM/ARM_OfficeIN_RM.dart';
import 'package:timber_app/RM/RM_ProfilePage.dart';
import 'package:timber_app/logingPage.dart';

class RMHomepage extends StatefulWidget {
  final String office_location;
  final String username;
  const RMHomepage({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<RMHomepage> createState() => _RMHomepageState();
}

class _RMHomepageState extends State<RMHomepage> {
  late final DatabaseReference dbRef;
  Map<String, int> cityOngoing = {};
  int totalOngoing = 0;
  late Stream<DatabaseEvent> _ongoingStream;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance
        .ref()
        .child("RM_branch_data_saved")
        .child(widget.office_location.toString())
        .child("Ongoing_Count");
    // Listen to realtime changes
    _ongoingStream = dbRef.onValue;
    _ongoingStream.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists && mounted) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );
        int total = 0;
        Map<String, int> temp = {};

        data.forEach((city, values) {
          int ongoing = 0;
          if (values is Map && values["ongoing"] != null) {
            // Ensure ongoing is treated as an integer
            ongoing = (values["ongoing"] as num).toInt();
          }
          temp[city] = ongoing;
          total += ongoing;
        });

        setState(() {
          cityOngoing = temp;
          totalOngoing = total;
        });
      } else if (mounted) {
        // Handle case where data is null or doesn't exist
        setState(() {
          cityOngoing = {};
          totalOngoing = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep a background for contrast
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        profile_button(username: widget.username),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome! ",
                              style: const TextStyle(
                                fontFamily: "sfproRoundSemiB",
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.username,
                              style: const TextStyle(
                                fontFamily: "sfproRoundSemiB",
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const alert_button(),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              OngoingCountCard(
                ongoingCount: totalOngoing,
                closedCount: 100, // Dummy data for closed projects
                cityData: cityOngoing,
              ),
              // --- NEW SECTION FOR CATEGORY BUTTONS ---
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CategoryButton(
                        icon: Iconsax.danger, // Example icon
                        title: "Emergency ",
                        textColor: Color(0xFFCE2D49),
                        color: Color(0xFFF6A6BB),
                        onTap: () {
                          // Handle tap for New Projects
                          print("New Projects tapped!");
                        },
                      ),
                    ),
                    const SizedBox(width: 20), // Space between buttons
                    Expanded(
                      child: CategoryButton(
                        icon: Iconsax.pen_add, // Example icon
                        title: "New Case",
                        textColor: Color(0xFF7E53C2),
                        color: Color(0xFFC2A9EF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ARM_OfficeIN_RM(
                                office_location: widget.office_location,
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // --- END NEW SECTION ---
            ],
          ),
        ),
      ),
    );
  }
}

//--- NEW WIDGET: CategoryButton ---
class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color textColor;
  final Color color;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.title,
    required this.textColor,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            20,
          ), // Slightly less rounded than the image for consistency
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Iconsax.arrow_right_34, // Arrow icon
                  color: textColor,
                  size: 18,
                ),
              ),
            ),
            Icon(icon, color: textColor, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: "sfproRoundSemiB",
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

//--- WIDGET WITH REDESIGNED GREEN CARD (No changes from previous) ---
class OngoingCountCard extends StatelessWidget {
  final int ongoingCount;
  final int closedCount;
  final Map<String, int> cityData;

  const OngoingCountCard({
    super.key,
    required this.ongoingCount,
    required this.closedCount,
    required this.cityData,
  });

  // Helper method to build the list of new rows and dividers
  List<Widget> _buildCityRows(Map<String, int> data) {
    final List<Widget> rows = [];
    final cityEntries = data.entries.toList();

    for (int i = 0; i < cityEntries.length; i++) {
      final entry = cityEntries[i];
      rows.add(
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Row(
            children: [
              const Icon(Iconsax.location5, color: Colors.black54, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontFamily: "sfproRoundSemiB",
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    fontFamily: "sfproRoundSemiB",
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Add a divider if it's not the last item in the list
      if (i < cityEntries.length - 1) {
        rows.add(
          Divider(
            color: Colors.black.withOpacity(0.1),
            height: 1,
            indent: 10,
            endIndent: 10,
          ),
        );
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        20,
        30,
        0,
      ), // Adjusted bottom padding to make space for new buttons
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Green accent card with new design
          Positioned(
            top: 120,
            left: 35,
            right: 35,
            child: Container(
              padding: const EdgeInsets.only(
                top: 80,
                bottom: 10,
                left: 15,
                right: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: const Color(0xFF9EF14A),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      100,
                      209,
                      104,
                    ).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 10),
                  ),
                  if (cityData.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "No active locations",
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "sfproRoundSemiB",
                          ),
                        ),
                      ),
                    )
                  else
                    Column(children: _buildCityRows(cityData)),
                ],
              ),
            ),
          ),

          // Top main card (Unchanged)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Projects Overview",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: "sfproRoundSemiB",
                      ),
                    ),
                    Icon(Iconsax.clock, color: Colors.white70, size: 20),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CountDisplay(
                      count: ongoingCount.toString(),
                      label: "ONGOING",
                    ),
                    _CountDisplay(
                      count: closedCount.toString(),
                      label: "CLOSED",
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget to display a number and a label
class _CountDisplay extends StatelessWidget {
  final String count;
  final String label;

  const _CountDisplay({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontFamily: "sfproRoundSemiB",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: "sfproRoundSemiB",
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// --- Your Existing Button Widgets (Unchanged) ---
class alert_button extends StatelessWidget {
  const alert_button({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {},
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.topRight,
        child: const CircleAvatar(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          radius: 25,
          child: Icon(Iconsax.notification5, color: Colors.black, size: 28),
        ),
      ),
    );
  }
}

class profile_button extends StatelessWidget {
  final String username;
  const profile_button({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 0, left: 20, right: 0, bottom: 0),
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(0, 238, 238, 238),
          child: ClipOval(child: AvatarPlus(username, height: 60, width: 60)),
        ),
      ),
    );
  }
}
