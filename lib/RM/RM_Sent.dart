import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/PositionPicker.dart';
import 'package:timber_app/RM/ARM_OfficeIN_RM.dart';
import 'package:timber_app/RM/createFor.dart';
import 'package:timber_app/RM/sent_CardView.dart';

class RmSent extends StatefulWidget {
  final String office_location;
  const RmSent({super.key, required this.office_location});

  @override
  State<RmSent> createState() => _RmSentState();
}

class _RmSentState extends State<RmSent> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String searchQuery = ""; // For search filtering

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('RM_branch_data_saved')
        .child(widget.office_location)
        .child("Sent");

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listItem({required Map Sent, required int index}) {
    final String branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
    final String poc = Sent['placeOfCoupe'] ?? "N/A";
    final String DateInformed = Sent['DateInformed'] ?? "N/A";
    final String LetterNo = Sent['LetterNo'] ?? "N/A";
    final String SerialNum = Sent['Serial Number'] ?? "N/A";

    Color activeColor1 = const Color(0xFFEDEBFF);
    Color activeColor2 = const Color(0xFFDAD6FF);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SentCardview(
              branchName: branchName,
              poc: poc,
              DateInformed: DateInformed,
              LetterNo: LetterNo,
              SerialNum: SerialNum,
              office_location: widget.office_location,
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
                      branchName,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Animated Header
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 100 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 28,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sent",
                            style: TextStyle(
                              fontSize: 50,
                              fontFamily: "sfproRoundSemiB",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ARM_OfficeIN_RM(
                                    office_location: widget.office_location,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: Colors.black,
                            child: Icon(
                              Iconsax.pen_add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),

            // Search bar below header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
