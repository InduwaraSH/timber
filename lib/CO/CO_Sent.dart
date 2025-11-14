import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
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
  String searchQuery = "";

  List<Map> _sentList = [];

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
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      }
    });

    dbref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;
        List<Map> tempList = [];

        data.forEach((key, value) {
          Map sent = Map<String, dynamic>.from(value as Map);
          sent['key'] = key;
          tempList.add(sent);
        });

        // Sort by latest_update (latest first)
        tempList.sort((a, b) {
          final aDateStr = a['timberReportheadlines']?['latest_update'] ?? '';
          final bDateStr = b['timberReportheadlines']?['latest_update'] ?? '';

          final aDate = aDateStr.isNotEmpty
              ? DateTime.tryParse(aDateStr) ?? DateTime(1900)
              : DateTime(1900);
          final bDate = bDateStr.isNotEmpty
              ? DateTime.tryParse(bDateStr) ?? DateTime(1900)
              : DateTime(1900);

          return bDate.compareTo(aDate);
        });

        setState(() {
          _sentList = tempList;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listItem({required Map sent, required int index}) {
    final Map<String, dynamic> head = Map<String, dynamic>.from(
      sent['timberReportheadlines'] ?? {},
    );

    final String co = head['From_CO'] ?? "Not Available";
    final String poc = head['placeofcoupe'] ?? "N/A";
    final String exactPOC =
        head['PlaceOfCoupe_exact_from_arm'] ?? "Not Available";
    final String dateInformed = head['Date'] ?? "N/A";
    final String letterNo = head['LetterNo'] ?? "N/A";
    final String serialNum = head['serialnum'] ?? "N/A";
    final String officer = head['OfficerName'] ?? "N/A";
    final String officerPosition = head['OfficerPosition&name'] ?? "N/A";
    final String donor = head['donor_details'] ?? "N/A";
    final String condition = head['Condition'] ?? "N/A";
    final String treeCount = head['TreeCount'] ?? "N/A";
    final String latestUpdate = head['latest_update'] ?? "";

    const Color greenStatus = Color.fromRGBO(52, 199, 89, 1);

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
              PlaceOfCoupe_exact_from_arm: exactPOC,
              DateInformed: dateInformed,
              LetterNo: letterNo,
              SerialNum: serialNum,
              OfficerName: officer,
              OfficerPositionAndName: officerPosition,
              donor_details: donor,
              Condition: condition,
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
            /// Header Row
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color.fromARGB(16, 0, 0, 0),
                  child: Icon(Iconsax.location5, color: Colors.black, size: 35),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    poc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 26,
                      fontFamily: "sfproRoundSemiB",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Serial Number
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
                      serialNum,
                      style: const TextStyle(
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),

                if (latestUpdate.isNotEmpty)
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
                      DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.parse(latestUpdate)),
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

            const Text(
              "Document Sent To :",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "sfproRoundSemiB",
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: AvatarPlus("ARM", height: 40, width: 40),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: greenStatus,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /// Header only
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 70 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? Padding(
                      padding: const EdgeInsets.only(left: 28, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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

            /// Search Bar (always visible)
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
                  setState(() => searchQuery = val.toLowerCase());
                },
              ),
            ),

            /// List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _sentList.length,
                itemBuilder: (context, index) {
                  final Map sent = _sentList[index];
                  final String poc =
                      sent['timberReportheadlines']?['placeofcoupe'] ?? "";

                  if (searchQuery.isNotEmpty &&
                      !poc.toLowerCase().contains(searchQuery)) {
                    return const SizedBox.shrink();
                  }

                  return listItem(sent: sent, index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
