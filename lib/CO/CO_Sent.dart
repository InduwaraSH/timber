import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timber_app/CO/CO_SentView.dart';


class CO_Sent extends StatefulWidget {
  final String office_location;
  final String username;
  const CO_Sent({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<CO_Sent> createState() => _CO_SentState();
}

class _CO_SentState extends State<CO_Sent> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;

  String searchQuery = ""; // For search filtering

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('CO_branch_data_saved')
        .child(widget.username)
        .child("Sent");

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
    final String co =
        Sent['timberReportheadlines']['From_CO'] ?? "Not Available";
    final String poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
    final String PlaceOfCoupe_exact_from_arm =
        Sent['timberReportheadlines']['PlaceOfCoupe_exact_from_arm'] ??
        "Not Available";
    final String DateInformed = Sent['timberReportheadlines']['Date'] ?? "N/A";
    final String LetterNo = Sent['timberReportheadlines']['LetterNo'] ?? "N/A";
    final String SerialNum =
        Sent['timberReportheadlines']['serialnum'] ?? "N/A";
    final String OfficerName =
        Sent['timberReportheadlines']['OfficerName'] ?? "N/A";
    final String OfficerPositionAndName =
        Sent['timberReportheadlines']['OfficerPosition&name'] ?? "N/A";
    final String donor_details =
        Sent['timberReportheadlines']['donor_details'] ?? "N/A";
    final String Condition =
        Sent['timberReportheadlines']['Condition'] ?? "N/A";
    final String treeCount =
        Sent['timberReportheadlines']['TreeCount'] ?? "N/A";
    Color activeColor1 = const Color(0xFFEDEBFF);
    Color activeColor2 = const Color(0xFFDAD6FF);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoSentview(
              office_location: widget.office_location,
              co: co,
              poc: poc,
              PlaceOfCoupe_exact_from_arm: PlaceOfCoupe_exact_from_arm,
              DateInformed: DateInformed,
              LetterNo: LetterNo,
              SerialNum: SerialNum,
              OfficerName: OfficerName,
              OfficerPositionAndName: OfficerPositionAndName,
              donor_details: donor_details,
              Condition: Condition,
              treeCount: treeCount,
              user_name: widget.username,
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
            // Left texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poc,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'sfproRoundSemiB',
                    color: Color(0xFF756AB6),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.double_arrow,
                      color: Colors.black.withOpacity(0.4),
                      size: 16,
                    ),
                    Text(
                      co,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'sfproRoundSemiB',
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF756AB6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Color(0xFF756AB6),
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
          children: [
            // Animated Header
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 160 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 28,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Sent",
                                style: TextStyle(
                                  fontSize: 50,
                                  fontFamily: "sfproRoundSemiB",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Modern search bar
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
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

                      // Filter based on POC
                      final String poc =
                          sent['timberReportheadlines']['placeofcoupe'] ?? "";
                      if (searchQuery.isNotEmpty &&
                          !poc.toLowerCase().contains(searchQuery)) {
                        return const SizedBox.shrink(); // Hide non-matching items
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
