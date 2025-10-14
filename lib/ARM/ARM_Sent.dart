import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/ARM/ARM_Sent_Cardview.dart';
import 'package:timber_app/ARM/ARM_SentView_RM.dart';
import 'package:timber_app/RM/ARM_OfficeIN_RM.dart';

class ARM_Sent extends StatefulWidget {
  final String office_location;
  const ARM_Sent({super.key, required this.office_location});

  @override
  State<ARM_Sent> createState() => _ARM_SentState();
}

class _ARM_SentState extends State<ARM_Sent> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String searchQuery = ""; // Added search variable

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('ARM_branch_data_saved')
        .child(widget.office_location)
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

    String OfficerName = "";
    String OfficerPositionAndName = "";
    String donor_details = "";
    String Condition = "";
    String treeCount = "";
    String CO_name = "";
    String ARM_office = "";
    String to = "";

    if (Reciver == "RM") {
      branchName = Sent['info']['ARM_Office'] ?? "Not Available";
      poc = Sent['info']['poc'] ?? "N/A";
      DateInformed = Sent['info']['Date'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['SerialNum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['TreeCount'] ?? "N/A";
      CO_name = Sent['info']['From_CO'] ?? "N/A";
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      activeColor1 = const Color(0xFFFFE4F0); // very soft pink
      activeColor2 = const Color(0xFFFFCCE0); // slightly deeper pastel pink
      textPrimary = const Color(0xFFEC83B0); // gentle pink for text
      iconPrimary = const Color(0xFFEC83B0); // matching pink for icons
    } else if (Reciver == "CO") {
      branchName = Sent['arm_office_location'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";
      to = Sent['from'] ?? "N/A";

      activeColor1 = const Color(0xFFF2E2FF); // soft pastel purple
      activeColor2 = const Color(0xFFE6D6FA); // slightly deeper pastel
      textPrimary = const Color(0xFF8A4ED8); // medium purple for text
      iconPrimary = const Color(0xFF8A4ED8); // matching purple for icons
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (Reciver == "RM") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArmSentviewCo(
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
                ARM_Office: branchName,
              ),
            ),
          );
        } else if (Reciver == "CO") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ARM_SentCardview(
                branchName: branchName,
                poc: poc,
                DateInformed: DateInformed,
                LetterNo: LetterNo,
                SerialNum: SerialNum,
                office_location: widget.office_location,
                to: to,
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
                    )
                  : null,
            ),

            // Search Bar
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

            // Firebase List
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
                          (sent['info']?['poc'] ?? sent['placeOfCoupe'] ?? "")
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
