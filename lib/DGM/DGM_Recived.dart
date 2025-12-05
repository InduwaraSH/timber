import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/AGM/AGM_RecivedView.dart';
import 'package:timber_app/DGM/DGM_RecivedView.dart';
import 'package:timber_app/RM/RM_ProfilePage.dart';

class DgmRecived extends StatefulWidget {
  final String office_location;
  final String username;
  const DgmRecived({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<DgmRecived> createState() => _DgmRecivedState();
}

class _DgmRecivedState extends State<DgmRecived> {
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
        .child('DGM')
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
    String poc_exact =
        Sent['timberReportheadlines']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
    String DateInformed =
        Sent['timberReportheadlines']['dateinformed_from_rm'] ?? "N/A";
    String LetterNo = Sent['timberReportheadlines']['LetterNo'] ?? "N/A";
    String SerialNum = Sent['timberReportheadlines']['serialnum'] ?? "N/A";
    String OfficerName = Sent['timberReportheadlines']['OfficerName'] ?? "N/A";
    String OfficerPositionAndName =
        Sent['timberReportheadlines']['OfficerPosition&name'] ?? "N/A";
    String donor_details =
        Sent['timberReportheadlines']['donor_details'] ?? "N/A";
    String Condition = Sent['timberReportheadlines']['Condition'] ?? "N/A";
    String treeCount = Sent['timberReportheadlines']['TreeCount'] ?? "N/A";
    String CO_name = Sent['timberReportheadlines']['CO_name'] ?? "N/A";
    String CO_id = Sent['timberReportheadlines']['CO_id'] ?? "N/A";
    String ARM_id = Sent['timberReportheadlines']['ARM_Id'] ?? "N/A";
    String Income = Sent['timberReportheadlines']['income'].toString();
    String Outcome = Sent['timberReportheadlines']['outcome'].toString();
    String RM = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
    String RM_office = Sent['timberReportheadlines']['RM Office'] ?? "N/A";
    String reject_details =
        Sent['timberReportheadlines']['reject_details'] ?? " ";
    String Profit;
    String updated_income = "";
    String updated_outcome = "";
    if (reject_details == "" ||
        reject_details.isEmpty ||
        reject_details == "N/A") {
      Profit =
          ((double.tryParse(Income) ?? 0) - (double.tryParse(Outcome) ?? 0))
              .toString();
      updated_income = Income;
      updated_outcome = Outcome;
      reject_details = "";
    } else {
      updated_income = Sent['timberReportheadlines']['updated_income'] ?? "N/A";
      updated_outcome =
          Sent['timberReportheadlines']['updated_outcome'] ?? "N/A";

      Profit =
          ((double.tryParse(updated_income) ?? 0) -
                  (double.tryParse(updated_outcome) ?? 0))
              .toString();
    }
    String latestUpdate =
        Sent['timberReportheadlines']['latest_update'] ?? "N/A";
    String from_doc = "RM Office $RM_office";
    Color statusColour = Color.fromRGBO(255, 204, 0, 1);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DgmRecivedview(
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
              CO_name: CO_name,
              Income: Income,
              Outcome: Outcome,
              CO_id: CO_id,
              ARM_id: ARM_id,
              RM_office: RM_office,
              RM: RM,
              Profit: Profit,
              reject_details: reject_details,
              updated_income: updated_income,
              updated_outcome: updated_outcome,
            ),
          ),
        );
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    poc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 26, // reduce from 33 to fit better
                      fontFamily: "sfproRoundSemiB",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
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
                padding: EdgeInsets.only(bottom: 200),
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
