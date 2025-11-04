import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timber_app/AGM/AGM_RecivedView.dart';
import 'package:timber_app/CO/CO_Recived_View.dart';
import 'package:timber_app/RM/RM_ProfilePage.dart';

class AGMRecived extends StatefulWidget {
  final String office_location;
  final String username;
  const AGMRecived({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<AGMRecived> createState() => _AGMRecivedState();
}

class _AGMRecivedState extends State<AGMRecived> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  int messageCount = 0; // New message count variable
  String searchQuery = ""; // For search filtering

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('Head_office_data_saved')
        .child('AGM')
        .child("Recived");

    // Listen to changes in the database to dynamically update the message count
    dbref.onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        if (data is Map) {
          messageCount = data.length;
        } else {
          messageCount = 0;
        }
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listItem({required Map Sent, required int index}) {
    String branchName =
        Sent['timberReportheadlines']['ARM_location'] ?? "Not Available";
    String poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
    String DateInformed =
        Sent['timberReportheadlines']['dateinformed_from_rm'] ?? "N/A";
    String LetterNo = Sent['timberReportheadlines']['LetterNo'] ?? "N/A";
    String SerialNum = Sent['timberReportheadlines']['serialnum'] ?? "N/A";
    String OfficerName = Sent['timberReportheadlines']['OfficerName'] ?? "N/A";
    String OfficerPositionAndName =
        Sent['timberReportheadlines']['OfficerPosition&name'] ?? "N/A";
    String donor_details = Sent['timberReportheadlines']['donor_details'] ?? "N/A";
    String Condition = Sent['timberReportheadlines']['Condition'] ?? "N/A";
    String treeCount = Sent['timberReportheadlines']['TreeCount'] ?? "N/A";
    String CO_name = Sent['timberReportheadlines']['From_CO'] ?? "N/A";
    String Income = Sent['timberReportheadlines']['income'].toString() ?? "N/A";
    String Outcome = Sent['timberReportheadlines']['outcome'].toString() ?? "N/A";
    String RM = Sent['timberReportheadlines']['From'] ?? "N/A";

    Color activeColor1 = const Color(0xFFE2ECFF);
    Color activeColor2 = const Color(0xFFD6E4FA);
    Color textPrimary = const Color(0xFF5065D8);
    Color iconPrimary = const Color(0xFF5065D8);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgmRecivedview(
                ARM_Branch_Name: branchName,
                poc: poc,
                DateInformed: DateInformed,
                LetterNo: LetterNo,
                SerialNum: SerialNum,
                OfficerPositionAndName: OfficerPositionAndName,
                donor_details: donor_details,
                Condition: Condition,
                treeCount: treeCount,
                office_location: widget.office_location,
                PlaceOfCoupe_exact_from_arm: poc,
                OfficerName: OfficerName,
                user_name: widget.username,
                CO_name: CO_name,
                Income: Income,
                Outcome: Outcome,
                RM: RM,
                Profit: (Income.isNotEmpty && Outcome.isNotEmpty)
                    ? (((double.tryParse(Income) ?? 0) -
                              (double.tryParse(Outcome) ?? 0))
                          .toString())
                    : "N/A",
              ),
            ),
          );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [activeColor1, activeColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: activeColor1.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poc,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'sfproRoundSemiB',
                    color: textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.double_arrow,
                      color: textPrimary.withOpacity(0.6),
                      size: 16,
                    ),
                    Text(
                      branchName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'sfproRoundSemiB',
                        color: textPrimary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.apartment_rounded,
                color: iconPrimary,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Animated Header
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 180 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 5,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  profile_button(username: widget.username),

                                  const Text(
                                    "Inbox",
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontFamily: "sfproRoundSemiB",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  // Message count
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "$messageCount",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "sfproRoundSemiB",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Modern Search Bar
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Search by POC",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "sfproRoundSemiB",
                                ),
                                border: InputBorder.none,
                                icon: Icon(Icons.search, color: Colors.grey),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            //const SizedBox(height: 10),

            // Firebase list
            Expanded(
              child: FirebaseAnimatedList(
                controller: _scrollController,
                query: dbref,
                itemBuilder:
                    (
                      BuildContext context,
                      DataSnapshot snapshot,
                      Animation<double> animation,
                      int index,
                    ) {
                      Map sent = snapshot.value as Map;
                      sent['key'] = snapshot.key;

                      // Filter by POC
                      final String poc = sent['placeOfCoupe'] ?? "";
                      if (searchQuery.isNotEmpty &&
                          !poc.toLowerCase().contains(searchQuery)) {
                        return const SizedBox.shrink();
                      }

                      return listItem(Sent: sent, index: index);
                    },
              ),
            ),
          ],
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
        margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
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
