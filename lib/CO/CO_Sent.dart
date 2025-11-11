import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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

    final String latestUpdate =
        Sent['timberReportheadlines']['latest_update'] ?? "";

    Color statusColour = Color.fromRGBO(52, 199, 89, 1);

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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Profile + Switch Account
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color.fromARGB(16, 0, 0, 0),
                      child: Center(
                        child: Icon(
                          Iconsax.location5,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      poc,
                      style: TextStyle(
                        fontSize: 33,
                        fontFamily: "sfproRoundSemiB",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Balance section
            const Text(
              "Serial Number",
              style: TextStyle(
                fontFamily: "sfproRoundSemiB",
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.hashtag,
                      size: 20,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      SerialNum.toString(),
                      style: const TextStyle(
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    latestUpdate != ""
                        ? DateFormat(
                            'yyyy-MM-dd',
                          ).format(DateTime.parse(latestUpdate))
                        : "",
                    style: const TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            // // Action buttons
            // // Row(
            // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // //   children: [
            // //     _ActionButton(icon: Icons.add, label: "Top Up"),
            // //     _ActionButton(icon: Icons.arrow_forward, label: "Transfer"),
            // //     _ActionButton(icon: Icons.history, label: "History"),
            // //   ],
            // // ),
            const SizedBox(height: 10),
            const Divider(thickness: 0.6, color: Colors.black12),
            const SizedBox(height: 10),

            // Last Transaction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Document Sent To :",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "sfproRoundSemiB",
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Transaction Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                      ),
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: const Color.fromARGB(0, 238, 238, 238),
                        child: ClipOval(
                          child: AvatarPlus("ARM", height: 40, width: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColour,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "ARM",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'sfproRoundSemiB',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       "From",
                //       style: TextStyle(
                //         fontSize: 14,
                //         fontFamily: "sfproRoundSemiB",
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black87,
                //       ),
                //     ),
                //     SizedBox(height: 2),
                //     Text(
                //       RM_Id,
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: Colors.grey,
                //         fontFamily: "sfproRoundSemiB",
                //       ),
                //     ),
                //   ],
                // ),
              ],
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
