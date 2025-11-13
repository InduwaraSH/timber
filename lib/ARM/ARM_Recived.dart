import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/ARM/ARM_Cutting_view.dart';
import 'package:timber_app/ARM/ARM_Procumented%20View.dart';
import 'package:timber_app/ARM/ARM_RecivedViewApproved.dart';
import 'package:timber_app/ARM/ARM_RecivedView_CO.dart';
import 'package:timber_app/ARM/ARM_Recived_view.dart';
import 'package:timber_app/ARM/ARM_Remove_view.dart';
import 'package:timber_app/ARM/Procument_call.dart';

class ARMReceived extends StatefulWidget {
  final String office_location;
  final String username;
  const ARMReceived({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<ARMReceived> createState() => _ARMReceivedState();
}

class _ARMReceivedState extends State<ARMReceived> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  int messageCount = 0;
  String searchQuery = "";
  List<Map> allItems = []; // store all items temporarily

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('ARM_branch_data_saved')
        .child(widget.office_location)
        .child("Recived");

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

    Color statusColour = Colors.grey;

    String OfficerName = "";
    String OfficerPositionAndName = "";
    String donor_details = "";
    String Condition = "";
    String treeCount = "";
    String CO_name = "";
    String ARM_office = "";
    String Income = "";
    String Outcome = "";
    String RM_office = "";
    String CO_id = "";
    String poc_exact = "";
    String latestUpdate = "";
    String from_doc = Sent['to'] ?? "N/A";
    String Status = "";
    String ADGM_ID = "";
    String RM_ID = "";
    String ARM_ID = "";

    if (from == "CO") {
      CO_id = Sent['timberReportheadlines']['CO_id'] ?? "Not Available";
      poc = Sent['timberReportheadlines']['placeofcoupe'] ?? "N/A";
      poc_exact =
          Sent['timberReportheadlines']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
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
      RM_office = Sent['timberReportheadlines']['RM_office'] ?? "N/A";
      latestUpdate = Sent['timberReportheadlines']['latest_update'] ?? "N/A";
      from_doc = "CO $CO_name";
      statusColour = Color.fromRGBO(30, 110, 244, 1);
    } else if (from == "RM") {
      branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";
      RM_office = Sent['RM_location'] ?? "N/A";
      latestUpdate = Sent['latest_update'] ?? "N/A";

      from_doc = "RM $RM_office";
      statusColour = Color.fromRGBO(255, 204, 0, 1);
    } else if (from == "RM_Approved") {
      Status = Sent['timberReportheadlines']['Status'] ?? "N/A";
      ADGM_ID = Sent['timberReportheadlines']['ADGM_ID'] ?? "N/A";
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
      Income = Sent['timberReportheadlines']['income'].toString();
      Outcome = Sent['timberReportheadlines']['outcome'].toString();
      latestUpdate = Sent['timberReportheadlines']['latest_update'] ?? "N/A";
      RM_office = Sent['timberReportheadlines']['RM Office'] ?? "N/A";
      CO_id = Sent['timberReportheadlines']['CO_id'] ?? "Not Available";
      from_doc = "RM $RM_office";
      RM_ID = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
      ARM_ID = Sent['timberReportheadlines']['ARM_Id'] ?? "N/A";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
    } else if (from == "Procumented") {
      Status = Sent['timberReportheadlines']['Status'] ?? "N/A";
      ADGM_ID = Sent['timberReportheadlines']['ADGM_ID'] ?? "N/A";
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
      Income = Sent['timberReportheadlines']['income'].toString();
      Outcome = Sent['timberReportheadlines']['outcome'].toString();
      latestUpdate = Sent['timberReportheadlines']['latest_update'] ?? "N/A";
      RM_office = Sent['timberReportheadlines']['RM Office'] ?? "N/A";
      CO_id = Sent['timberReportheadlines']['CO_id'] ?? "Not Available";
      from_doc = "RM $RM_office - Procumented";
      RM_ID = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
      ARM_ID = Sent['timberReportheadlines']['ARM_Id'] ?? "N/A";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
    } else if (from == "Removing") {
      Status = Sent['timberReportheadlines']['Status'] ?? "N/A";
      ADGM_ID = Sent['timberReportheadlines']['ADGM_ID'] ?? "N/A";
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
      Income = Sent['timberReportheadlines']['income'].toString();
      Outcome = Sent['timberReportheadlines']['outcome'].toString();
      latestUpdate = Sent['timberReportheadlines']['latest_update'] ?? "N/A";
      RM_office = Sent['timberReportheadlines']['RM Office'] ?? "N/A";
      CO_id = Sent['timberReportheadlines']['CO_id'] ?? "Not Available";
      from_doc = "RM $RM_office - Tree Removing";
      RM_ID = Sent['timberReportheadlines']['RM_Id'] ?? "N/A";
      ARM_ID = Sent['timberReportheadlines']['ARM_Id'] ?? "N/A";
      statusColour = Color.fromRGBO(255, 146, 48, 1);
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (from == "CO") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArmRecivedviewCo(
                co_name: CO_name,
                CO_id: CO_id,
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
                RM_office: RM_office,
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
                RM_office: RM_office,
                user_name: widget.username,
              ),
            ),
          );
        } else if (from == "RM_Approved") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ARM_Pro_call(
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
                RM_office: RM_office,
                CO_id: CO_id,
                CO_name: CO_name,
                ARM_ID: ARM_ID,
                RM_ID: RM_ID,
                Status: Status,
                ADGM_ID: ADGM_ID,
                Profit: (Income.isNotEmpty && Outcome.isNotEmpty)
                    ? (((double.tryParse(Income) ?? 0) -
                              (double.tryParse(Outcome) ?? 0))
                          .toString())
                    : "N/A",
              ),
            ),
          );
        } else if (from == "Procumented") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ARM_Procumented_view(
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
                RM_office: RM_office,
                CO_id: CO_id,
                CO_name: CO_name,
                ARM_ID: ARM_ID,
                RM_ID: RM_ID,
                Status: Status,
                ADGM_ID: ADGM_ID,
                Profit: (Income.isNotEmpty && Outcome.isNotEmpty)
                    ? (((double.tryParse(Income) ?? 0) -
                              (double.tryParse(Outcome) ?? 0))
                          .toString())
                    : "N/A",
              ),
            ),
          );
        } else if (from == "Removing") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArmCuttingView(
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
                RM_office: RM_office,
                CO_id: CO_id,
                CO_name: CO_name,
                ARM_ID: ARM_ID,
                RM_ID: RM_ID,
                Status: Status,
                ADGM_ID: ADGM_ID,
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
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDFBFF), Color(0xFFEDEBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
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
              Expanded(
                child: StreamBuilder(
                  stream: dbref.onValue,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data?.snapshot.value == null) {
                      return const Center(child: Text("No records found"));
                    }
                    final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map,
                    );
                    final items = data.entries
                        .map(
                          (e) => {
                            ...Map<String, dynamic>.from(e.value),
                            "key": e.key,
                          },
                        )
                        .toList();

                    // sort by latestUpdate (descending)
                    items.sort((a, b) {
                      final aDate =
                          DateTime.tryParse(
                            (a['latest_update'] ??
                                    a['timberReportheadlines']?['latest_update'] ??
                                    "")
                                .toString(),
                          ) ??
                          DateTime(1970);
                      final bDate =
                          DateTime.tryParse(
                            (b['latest_update'] ??
                                    b['timberReportheadlines']?['latest_update'] ??
                                    "")
                                .toString(),
                          ) ??
                          DateTime(1970);
                      return bDate.compareTo(aDate);
                    });

                    // filter by search
                    final filtered = items.where((sent) {
                      final poc =
                          (sent['timberReportheadlines']?['placeofcoupe'] ??
                                  sent['placeOfCoupe'] ??
                                  "")
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
      ),
    );
  }
}
