import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/RM/ARM_OfficeIN_RM.dart';
import 'package:timber_app/RM/RM_Proc_view.dart';
import 'package:timber_app/RM/RM_SentView_Approve.dart';
import 'package:timber_app/RM/RM_SentView_NotApprove.dart';
import 'package:timber_app/RM/RM_SentView_rejectedbyADGM.dart';
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

  List<Map> _sentList = []; // Added to store and sort items

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

    // Fetch once and listen for changes to apply sorting
    dbref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;
        List<Map> tempList = [];

        data.forEach((key, value) {
          Map sent = value as Map;
          sent['key'] = key;
          tempList.add(sent);
        });

        tempList.sort((a, b) {
          final aDateStr = _extractLatestUpdate(a);
          final bDateStr = _extractLatestUpdate(b);

          final aDate = aDateStr.isNotEmpty
              ? DateTime.tryParse(aDateStr) ?? DateTime(1900)
              : DateTime(1900);
          final bDate = bDateStr.isNotEmpty
              ? DateTime.tryParse(bDateStr) ?? DateTime(1900)
              : DateTime(1900);

          return bDate.compareTo(aDate); // latest first
        });

        setState(() {
          _sentList = tempList;
        });
      }
    });
  }

  String _extractLatestUpdate(Map sent) {
    if (sent['from'] == 'RM') {
      return sent['latest_update'] ?? '';
    } else if (sent['from'] == 'RM_Approved' ||
        sent['from'] == 'RM_N_Approved') {
      return sent['info']?['latest_update'] ?? '';
    }
    return '';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listItem({required Map Sent, required int index}) {
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
    String poc_exact = "";
    String OfficerName = "";
    String OfficerPositionAndName = "";
    String donor_details = "";
    String Condition = "";
    String treeCount = "";
    String CO_name = "";
    String CO_id = "";
    String ARM_Id = "";
    String Income = "";
    String Outcome = "";
    String Profit = "";
    String ARM_office = "";
    String AGM_ID = "";
    String RM_ID = "";
    String Sent_TO = "";
    String Status = "";
    String ADGM_Type = "";
    String Reject_reason = "";
    String Reject_Details = "";
    String Updated_income = "";
    String Updated_Outcome = "";
    String prefix = "";
    String K = (Sent['from'] ?? "").toString().toUpperCase();
    if (K == "RM") {
      branchName = Sent['ARM_Branch_Name'] ?? "Not Available";
      poc = Sent['placeOfCoupe'] ?? "N/A";
      DateInformed = Sent['DateInformed'] ?? "N/A";
      LetterNo = Sent['LetterNo'] ?? "N/A";
      SerialNum = Sent['Serial Number'] ?? "N/A";
      RM_Id = Sent['RM_Id'] ?? "N/A";
      latestUpdate = Sent['latest_update'] ?? "N/A";

      To = "ARM $branchName";
      statusColour = Color.fromRGBO(255, 204, 0, 1);
    } else if (K == "RM_APPROVED") {
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
      DateInformed = Sent['info']['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['TreeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_name'] ?? "N/A";
      CO_id = Sent['info']['CO_id'] ?? "N/A";
      ARM_Id = Sent['info']['ARM_Id'] ?? "N/A";
      Reject_Details = Sent['info']['reject_details'] ?? "N/A";
      Income = Sent['info']['income'].toString() ?? "N/A";
      Outcome = Sent['info']['outcome'].toString() ?? "N/A";
      Profit =
          ((double.tryParse(Income) ?? 0) - (double.tryParse(Outcome) ?? 0))
              .toString();
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
      To = "ARM - $ARM_Id";
      AGM_ID = Sent['info']['ADGM_ID'] ?? "N/A";
      if (AGM_ID == "N/A" || AGM_ID == "") {
        Status = "RM Approved";
        AGM_ID = "RM Approved";
      } else {
        Status = Sent['info']['Status'] ?? "N/A";
      }
    } else if (K == "RM_N_APPROVED") {
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
      DateInformed = Sent['info']['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Sent_TO = Sent['info']['Sent_To'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['TreeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_name'] ?? "N/A";
      CO_id = Sent['info']['CO_id'] ?? "N/A";
      Income = Sent['info']['income'].toString() ?? "N/A";
      Outcome = Sent['info']['outcome'].toString() ?? "N/A";

      Updated_income = Sent['info']['updated_income'].toString() ?? "N/A";
      Updated_Outcome = Sent['info']['updated_outcome'].toString() ?? "N/A";

      Profit =
          ((double.tryParse(Updated_income) ?? 0) -
                  (double.tryParse(Updated_Outcome) ?? 0))
              .toString() ??
          "N/A";
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      RM_ID = Sent['info']['RM_Id'] ?? "N/A";
      ARM_Id = Sent['info']['ARM_Id'] ?? "N/A";
      Reject_Details = Sent['info']['reject_details'] ?? "N/A";
      if (Reject_Details == "" ||
          Reject_Details.isEmpty ||
          Reject_Details == "N/A") {
        prefix = "";
      } else {
        prefix = " - Re submitted";
      }

      latestUpdate = Sent['info']['latest_update'] ?? "N/A";
      if (Sent_TO == "DGM") {
        statusColour = Color.fromRGBO(30, 110, 244, 1);
      } else if (Sent_TO == "AGM") {
        statusColour = Color.fromRGBO(167, 170, 244, 255);
      }

      To = Sent_TO + prefix;
      RM_ID = Sent['info']['RM_Id'] ?? "N/A";
    } else if (K == "PROCUMENTED") {
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
      DateInformed = Sent['info']['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['TreeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_name'] ?? "N/A";
      CO_id = Sent['info']['CO_id'] ?? "N/A";
      ARM_Id = Sent['info']['ARM_Id'] ?? "N/A";
      Income = Sent['info']['income'].toString() ?? "N/A";
      Outcome = Sent['info']['outcome'].toString() ?? "N/A";
      Profit =
          ((double.tryParse(Income) ?? 0) - (double.tryParse(Outcome) ?? 0))
              .toString();
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "";
      statusColour = Color.fromRGBO(52, 199, 89, 1);
      To = "ARM - $ARM_Id Procumented";
      AGM_ID = Sent['info']['ADGM_ID'] ?? "N/A";
      if (AGM_ID == "N/A" || AGM_ID == "") {
        Status = "RM Approved";
        AGM_ID = "RM Approved";
      } else {
        Status = Sent['info']['Status'] ?? "N/A";
      }
    } else if (K == "ADGM_REJECTED") {
      poc = Sent['info']['placeofcoupe'] ?? "N/A";
      poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
      DateInformed = Sent['info']['dateinformed_from_rm'] ?? "N/A";
      LetterNo = Sent['info']['LetterNo'] ?? "N/A";
      SerialNum = Sent['info']['serialnum'] ?? "N/A";
      OfficerName = Sent['info']['OfficerName'] ?? "N/A";
      OfficerPositionAndName = Sent['info']['OfficerPosition&name'] ?? "N/A";
      donor_details = Sent['info']['donor_details'] ?? "N/A";
      Condition = Sent['info']['Condition'] ?? "N/A";
      treeCount = Sent['info']['TreeCount'] ?? "N/A";
      CO_name = Sent['info']['CO_name'] ?? "N/A";
      CO_id = Sent['info']['CO_id'] ?? "N/A";
      ARM_Id = Sent['info']['ARM_Id'] ?? "N/A";
      Income = Sent['info']['income'].toString() ?? "N/A";
      Outcome = Sent['info']['outcome'].toString() ?? "N/A";
      Profit =
          ((double.tryParse(Income) ?? 0) - (double.tryParse(Outcome) ?? 0))
              .toString();
      ARM_office = Sent['info']['ARM_location'] ?? "N/A";
      latestUpdate = Sent['info']['latest_update'] ?? "";
      ADGM_Type = Sent['info']['latest_update'] ?? "";
      Reject_reason = Sent['info']['Reject_reason'] ?? "";
      statusColour = Color.fromRGBO(233, 21, 45, 1);
      Status = Sent['info']['Status'] ?? "N/A";
      To = "ARM - $ARM_Id Rejected";
      AGM_ID = Sent['info']['ADGM_ID'] ?? "N/A";
      RM_ID = Sent['info']['RM_Id'] ?? "N/A";
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (K == "RM") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SentCardview(
                branchName: branchName,
                poc: poc,
                DateInformed: DateInformed,
                LetterNo: LetterNo,
                SerialNum: SerialNum,
                office_location: widget.office_location,
              ),
            ),
          );
        } else if (K == "RM_APPROVED") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RmSentviewApprove(
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
                AGM_ID: AGM_ID,
                Status: Status,
                reject_details: Reject_Details,
              ),
            ),
          );
        } else if (K == "RM_N_APPROVED") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RmSentviewNotapprove(
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
                Reject_Details: Reject_Details,
              ),
            ),
          );
        } else if (K == "PROCUMENTED") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RM_Procumented_view(
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

                CO_id: CO_id,
                CO_name: CO_name,

                Status: Status,
                ARM_Branch_Name: ARM_office,
                ADGM_ID: AGM_ID,
                RM_office: widget.office_location,
                ARM_ID: ARM_Id,
                RM_ID: RM_ID,
                reject_details: Reject_Details,
              ),
            ),
          );
        } else if (K == "ADGM_REJECTED") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RmSentviewRejectedbyadgm(
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
                AGM_ID: AGM_ID,
                Status: Status,
                RM_Id: RM_ID,
                reject_reason: Reject_reason,
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
            // Top Row
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
                        child: AvatarPlus(To, height: 40, width: 40),
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
                      RM_ID,
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
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showHeader ? 100 : 1,
                curve: Curves.easeInOut,
                child: _showHeader
                    ? Padding(
                        padding: const EdgeInsets.only(left: 28, right: 16),
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
                              child: const Icon(
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
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 200),
                  controller: _scrollController,
                  itemCount: _sentList.length,
                  itemBuilder: (context, index) {
                    Map sent = _sentList[index];

                    final String pocVal =
                        sent['placeOfCoupe'] ??
                        sent['info']?['placeofcoupe'] ??
                        "";
                    if (searchQuery.isNotEmpty &&
                        !pocVal.toLowerCase().contains(searchQuery)) {
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
