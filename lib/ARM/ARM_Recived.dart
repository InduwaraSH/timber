import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timber_app/ARM/ARM_RecivedViewApproved.dart';
import 'package:timber_app/ARM/ARM_RecivedView_CO.dart';
import 'package:timber_app/ARM/ARM_Recived_view.dart';

class ARMReceived extends StatefulWidget {
  final String office_location;
  const ARMReceived({super.key, required this.office_location});

  @override
  State<ARMReceived> createState() => _ARMReceivedState();
}

class _ARMReceivedState extends State<ARMReceived> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  int messageCount = 0;
  String searchQuery = ""; // Added search query variable

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('ARM_branch_data_saved')
        .child(widget.office_location)
        .child("Recived");

    // Listen for changes to update message count dynamically
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
    final String from = Sent['from'] ?? "N/A";

    String branchName = "";
    String poc = "";
    String DateInformed = "";
    String LetterNo = "";
    String SerialNum = "";
    Color activeColor1 = const Color(0xFFE2ECFF);
    Color activeColor2 = const Color(0xFFD6E4FA);
    Color textPrimary = const Color(0xFF5065D8);
    Color iconPrimary = const Color(0xFF5065D8);

    String OfficerName = "";
    String OfficerPositionAndName = "";
    String donor_details = "";
    String Condition = "";
    String treeCount = "";
    String CO_name = "";
    String ARM_office = "";
    String Income = "";
    String Outcome = "";
    String Profit = "";

    if (from == "CO") {
      branchName = Sent['timberReportheadlines']['From_CO'] ?? "Not Available";
      poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
      DateInformed = Sent['timberReportheadlines']['Date'] ?? "N/A";
      LetterNo = Sent['timberReportheadlines']['LetterNo'] ?? "N/A";
      SerialNum = Sent['timberReportheadlines']['serialnum'] ?? "N/A";
      OfficerName = Sent['timberReportheadlines']['OfficerName'] ?? "N/A";
      OfficerPositionAndName =
          Sent['timberReportheadlines']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['timberReportheadlines']['donor_details'] ?? "N/A";
      Condition = Sent['timberReportheadlines']['Condition'] ?? "N/A";
      treeCount = Sent['timberReportheadlines']['TreeCount'] ?? "N/A";
      CO_name = Sent['timberReportheadlines']['From_CO'] ?? "N/A";
      ARM_office = Sent['timberReportheadlines']['ARM_location'] ?? "N/A";
      activeColor1 = const Color(0xFFE9FBE7);
      activeColor2 = const Color(0xFFC8E6C9);
      textPrimary = const Color(0xFF4CAF50);
      iconPrimary = const Color(0xFF4CAF50);
    } else if (from == "RM") {
      branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";

      activeColor1 = const Color(0xFFE2ECFF);
      activeColor2 = const Color(0xFFD6E4FA);
      textPrimary = const Color(0xFF5065D8);
      iconPrimary = const Color(0xFF5065D8);
    } else if (from == "RM_Approved") {
      branchName =
          Sent['timberReportheadlines']['ARM_location'] ?? "Not Available";
      poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
      DateInformed =
          Sent['timberReportheadlines']['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['timberReportheadlines']['LetterNo'] ?? "N/A";
      SerialNum = Sent['timberReportheadlines']['serialnum'] ?? "N/A";
      OfficerName = Sent['timberReportheadlines']['OfficerName'] ?? "N/A";
      OfficerPositionAndName =
          Sent['timberReportheadlines']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['timberReportheadlines']['donor_details'] ?? "N/A";
      Condition = Sent['timberReportheadlines']['Condition'] ?? "N/A";
      treeCount = Sent['timberReportheadlines']['TreeCount'] ?? "N/A";
      CO_name = Sent['timberReportheadlines']['From_CO'] ?? "N/A";
      Income = Sent['timberReportheadlines']['income'].toString() ?? "N/A";
      Outcome = Sent['timberReportheadlines']['outcome'].toString() ?? "N/A";

      activeColor1 = const Color(0xFFFFF3E0);
      activeColor2 = const Color(0xFFFFE0B2);
      textPrimary = const Color(0xFFFF9800);
      iconPrimary = const Color(0xFFFF9800);
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (from == "CO") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArmRecivedviewCo(
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
                user_name: '',
                ARM_Office: ARM_office,
              ),
            ),
          );
        } else if (from == "RM") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ARM_Received_View(
                branchName: branchName,
                poc: poc,
                DateInformed: DateInformed,
                LetterNo: LetterNo,
                SerialNum: SerialNum,
                office_location: widget.office_location,
              ),
            ),
          );
        } else if (from == "RM_Approved") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArmRecivedviewapproved(
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
                user_name: CO_name,
                ARM_Office: ARM_office,
                Income: Income,
                Outcome: Outcome,
                Profit: (Income.isNotEmpty && Outcome.isNotEmpty)
                    ? (((double.tryParse(Income) ?? 0) -
                              (double.tryParse(Outcome) ?? 0))
                          .toString())
                    : "N/A",
              ),
            ),
          );
        }
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
          children: [
            // Animated Header with message count
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 100 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Inbox",
                            style: TextStyle(
                              fontSize: 50,
                              fontFamily: "sfproRoundSemiB",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$messageCount",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'sfproRoundSemiB',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),

            // Search bar
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
                      final String poc =
                          (sent['timberReportheadlines']?['placeofcoupe'] ??
                                  sent['placeOfCoupe'] ??
                                  "")
                              .toString();
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
