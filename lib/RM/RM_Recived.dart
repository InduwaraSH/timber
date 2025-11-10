import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/ARM/ARM_RecivedView_CO.dart';
import 'package:timber_app/ARM/ARM_Recived_view.dart';
import 'package:timber_app/PositionPicker.dart';
import 'package:timber_app/RM/ARM_OfficeIN_RM.dart';
import 'package:timber_app/RM/RM_Recived_view_ARM.dart';
import 'package:timber_app/RM/createFor.dart';
import 'package:timber_app/RM/sent_CardView.dart';

class RMRecived extends StatefulWidget {
  final String office_location;
  final String username;
  const RMRecived({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<RMRecived> createState() => _RMRecivedState();
}

class _RMRecivedState extends State<RMRecived> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  int messageCount = 0;
  String searchQuery = ""; // Search filtering

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('RM_branch_data_saved')
        .child(widget.office_location)
        .child("Recived");

    // Get initial message count
    dbref.once().then((event) {
      final data = event.snapshot.value as Map?;
      setState(() {
        messageCount = data?.length ?? 0;
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
    final String Reciver = Sent['Reciver'] ?? "N/A";

    String branchName = "";
    String poc = "";
    String DateInformed = "";
    String LetterNo = "";
    String SerialNum = "";
    Color activeColor1 = const Color(0xFFE2ECFF);
    Color activeColor2 = const Color(0xFFD6E4FA);
    Color textPrimary = const Color(0xFF5065D8);
    Color iconPrimary = const Color(0xFF5065D8);

    // ARM-specific variables
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
    String ARM_Id = "";
    String CO_id = "";
    String poc_exact = "";

    if (Reciver == "RM") {
      branchName = Sent['info']['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['info']['poc'] ?? "N/A";
      poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
      DateInformed = Sent['info']['DateInformed'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['SerialNum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPositionAndName'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['treeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_name'] ?? "N/A";
      CO_id = Sent['info']['CO_id'] ?? "N/A";
      ARM_Id = Sent['info']['ARM_ID'] ?? "N/A";
      Income = Sent['info']['Income'].toString() ?? "N/A";
      Outcome = Sent['info']['Outcome'].toString() ?? "N/A";
      Profit = Sent['info']['profitValue'].toString() ?? "N/A";
      ARM_office = Sent['info']['ARM_Office'] ?? "N/A";

      activeColor1 = const Color(0xFFE9FBE7);
      activeColor2 = const Color(0xFFC8E6C9);
      textPrimary = const Color(0xFF4CAF50);
      iconPrimary = const Color(0xFF4CAF50);
    } else if (Reciver == "CO") {
      branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['poc'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";

      activeColor1 = const Color(0xFFE2ECFF);
      activeColor2 = const Color(0xFFD6E4FA);
      textPrimary = const Color(0xFF5065D8);
      iconPrimary = const Color(0xFF5065D8);
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (Reciver == "RM") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RmRecivedViewArm(
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
                PlaceOfCoupe_exact_from_arm: poc_exact,
                OfficerName: OfficerName,

                user_name: widget.username,
                ARM_Office: ARM_office,
                Income: Income.toString(),
                Outcome: Outcome.toString(),
                Profit: Profit.toString(),
                ARM_Id: ARM_Id,
                CO_id: CO_id,
                CO_name: CO_name,
              ),
            ),
          );
        }
        // } else if (Reciver == "CO") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => ARM_Received_View(
        //         branchName: branchName,
        //         poc: poc,
        //         DateInformed: DateInformed,
        //         LetterNo: LetterNo,
        //         SerialNum: SerialNum,
        //         office_location: widget.office_location,
        //       ),
        //     ),
        //   );
        // }
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
                          Text(
                            "Inbox",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sfproRoundSemiB",
                              color: Colors.black,
                            ),
                          ),

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
                              style: TextStyle(
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

            // Search bar below Inbox row
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
                          sent['info']?['poc'] ?? sent['poc'] ?? "";
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
