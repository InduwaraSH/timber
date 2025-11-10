import 'package:avatar_plus/avatar_plus.dart';
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
  final String username;
  const RmSent({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<RmSent> createState() => _RmSentState();
}

class _RmSentState extends State<RmSent> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String searchQuery = ""; // For search filtering
  String branchName = "";
  String poc = "";
  String DateInformed = "";
  String LetterNo = "";
  String SerialNum = "";
  String key = "";
  String To = "";
  String RM_Id = "";
  Color statusColour = const Color(0xFFEDEBFF);
  String latestUpdate = "";

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
    final String key = Sent['from'];
    if (key == "RM") {
      branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";
      RM_Id = Sent['RM_Id'] ?? "N/A";
      latestUpdate = Sent['latest_update'] ?? "N/A";

      To = "ARM $branchName";
      statusColour = const Color(0xFFFFCB77);
    } else if (key == "RM_Approved") {
      branchName = Sent['info']['ARM_location'] ?? "Not Available";
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      DateInformed = Sent['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      RM_Id = Sent['info']['RM_Id'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "N/A";
      To = "ARM $branchName";

      statusColour = const Color(0xFF17C3B2);
    } else if (key == "RM_N_Approved") {
      branchName = Sent['info']['ARM_location'] ?? "Not Available";
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      DateInformed = Sent['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      RM_Id = Sent['info']['RM_Id'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "N/A";
      To = "AGM";
      statusColour = const Color(0xFFFE6D73);
    }

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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white70,
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
                    latestUpdate != "" ? "$latestUpdate" : "",
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
                          child: AvatarPlus(To, height: 40, width: 40),
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
                        To,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "From",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "sfproRoundSemiB",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      RM_Id,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: "sfproRoundSemiB",
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFBFF), Color(0xFFEDEBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
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
                                      username: widget.username,
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black87, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
