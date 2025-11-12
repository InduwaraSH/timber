import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/RM/RM_Received_view_ADGM.dart';
import 'package:timber_app/RM/RM_Recived_view_ARM.dart';

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
    final String Reciver = Sent['from'] ?? "N/A";

    String poc = "";
    String DateInformed = "";
    String LetterNo = "";
    String SerialNum = "";

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
    String? Profit = "";
    String ARM_Id = "";
    String CO_id = "";
    String poc_exact = "";

    String from_doc = Reciver == "RM" ? "ARM" : "CO";
    Color statusColour = Colors.black12;
    String latestUpdate = "";
    String AGM_ID = "";
    String RM_ID = "";
    String Status = "";

    if (Reciver == "ARM") {
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
      latestUpdate = Sent['info']['latest_update'] ?? "";
      statusColour = Color.fromRGBO(255, 204, 0, 1);
      from_doc = "ARM - $ARM_Id";
    } else if (Reciver == "AGM_Approved") {
      poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
      poc_exact =
          Sent['timberReportheadlines']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
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
      CO_name = Sent['timberReportheadlines']['CO_name'] ?? "N/A";
      CO_id = Sent['timberReportheadlines']['CO_id'] ?? "N/A";

      Income = Sent['timberReportheadlines']['income'].toString() ?? "N/A";
      Outcome = Sent['timberReportheadlines']['outcome'].toString() ?? "N/A";
      Profit =
          ((double.tryParse(Income) ?? 0) - (double.tryParse(Outcome) ?? 0))
              .toString() ??
          "N/A";
      ARM_office = Sent['timberReportheadlines']['ARM_location'] ?? "N/A";
      RM_ID = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
      ARM_Id = Sent['timberReportheadlines']['ARM_Id'] ?? "N/A";
      RM_ID = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
      latestUpdate = Sent['timberReportheadlines']['latest_update'] ?? "N/A";
      AGM_ID = Sent['timberReportheadlines']['ADGM_id'] ?? "";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
      Status = "AGM Approved";
      from_doc = "$AGM_ID";
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (Reciver == "ARM") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RmRecivedViewArm(
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
        } else if (Reciver == "AGM_Approved") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RmRecivedView_ADGM(
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
                RM_ID: RM_ID,
                user_name: widget.username,
                ARM_Office: ARM_office,
                Income: Income.toString(),
                Outcome: Outcome.toString(),
                Profit: Profit.toString(),
                ARM_Id: ARM_Id,
                CO_id: CO_id,
                CO_name: CO_name,
                AGM_ID: AGM_ID,
                Status: Status,
              ),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                      style: const TextStyle(
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
            const SizedBox(height: 10),
            const Divider(thickness: 0.6, color: Colors.black12),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Document Recived From :",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: AvatarPlus(from_doc, height: 40, width: 40),
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
                        from_doc,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'sfproRoundSemiB',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
