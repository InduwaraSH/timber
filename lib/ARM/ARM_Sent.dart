import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/ARM/ARM_Sent_Cardview.dart';
import 'package:timber_app/ARM/ARM_SentView_RM.dart';

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
  String searchQuery = "";

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

    String OfficerName = "";
    String OfficerPositionAndName = "";
    String donor_details = "";
    String Condition = "";
    String treeCount = "";
    String CO_name = "";
    String ARM_office = "";
    String to = "";
    String ARM_ID = "";
    String co_id = "";
    String latestUpdate = "";
    String To_Doc = Sent['To'] ?? "N/A";
    String RM_Id = Sent['From_RM_ID'] ?? "N/A";
    Color statusColour = Colors.green;

    if (Reciver == "RM") {
      branchName = Sent['info']['ARM_Office'] ?? "Not Available";
      poc = Sent['info']['poc'] ?? "N/A";
      DateInformed = Sent['info']['DateInformed'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['SerialNum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPositionAndName'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['treeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_id'] ?? "N/A";
      ARM_ID = Sent['info']['arm_id'] ?? "N/A";
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "";
      To_Doc = "RM";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
    } else if (Reciver == "CO") {
      branchName = Sent['arm_office_location'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";
      latestUpdate = Sent['latest_update'] ?? "";
      to = Sent['from'] ?? "N/A";
      co_id = Sent['CO_ID'] ?? "N/A";
      ARM_ID = Sent['ARM_id'] ?? "N/A";
      To_Doc = to;

      statusColour = Color.fromRGBO(255, 204, 0, 1);
    }

    // format only date
    String formattedDate = "";
    if (latestUpdate != "" && latestUpdate != "N/A") {
      try {
        formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(latestUpdate));
      } catch (e) {
        formattedDate = "";
      }
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
                    formattedDate,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color.fromARGB(0, 238, 238, 238),
                      child: ClipOval(
                        child: AvatarPlus(To_Doc, height: 40, width: 40),
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
                        To_Doc,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "From",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "sfproRoundSemiB",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ARM_ID,
                      style: const TextStyle(
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
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showHeader ? 100 : 1,
              curve: Curves.easeInOut,
              child: _showHeader
                  ? const Padding(
                      padding: EdgeInsets.only(top: 0, left: 28, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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

            // 🔥 Sorted List
            Expanded(
              child: StreamBuilder(
                stream: dbref.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  Map data =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<Map> items = [];

                  data.forEach((key, value) {
                    Map item = value;
                    item['key'] = key;
                    items.add(item);
                  });

                  // ✅ Sort by latest_update descending
                  items.sort((a, b) {
                    String aDate =
                        (a['info']?['latest_update'] ??
                                a['latest_update'] ??
                                "")
                            .toString();
                    String bDate =
                        (b['info']?['latest_update'] ??
                                b['latest_update'] ??
                                "")
                            .toString();

                    DateTime aParsed, bParsed;
                    try {
                      aParsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(aDate);
                    } catch (e) {
                      aParsed = DateTime.fromMillisecondsSinceEpoch(0);
                    }
                    try {
                      bParsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(bDate);
                    } catch (e) {
                      bParsed = DateTime.fromMillisecondsSinceEpoch(0);
                    }
                    return bParsed.compareTo(aParsed);
                  });

                  // ✅ Filter by POC
                  final filtered = items.where((sent) {
                    final String poc =
                        (sent['info']?['poc'] ?? sent['placeOfCoupe'] ?? "")
                            .toString()
                            .toLowerCase();
                    return searchQuery.isEmpty ||
                        poc.contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return listItem(Sent: filtered[index], index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
