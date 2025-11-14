import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/AGM/AGM_Sent_view_ok.dart';
import 'package:timber_app/DGM/DGM_Sent_View.dart';

class DgmSent extends StatefulWidget {
  final String office_location;
  final String username;
  const DgmSent({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<DgmSent> createState() => _DgmSentState();
}

class _DgmSentState extends State<DgmSent> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String searchQuery = ""; // For search filtering

  List<Map> _sentList = []; // Store and sort items

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('Head_office_data_saved')
        .child('DGM')
        .child('Send');

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showHeader) setState(() => _showHeader = true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showHeader) setState(() => _showHeader = false);
      }
    });

    // Fetch and listen
    dbref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;
        List<Map> tempList = [];

        data.forEach((key, value) {
          Map sent = value as Map;
          sent['key'] = key;
          tempList.add(sent);
        });

        // Sort items by latest_update descending
        tempList.sort((a, b) {
          String aDateStr = _extractLatestUpdate(a);
          String bDateStr = _extractLatestUpdate(b);

          DateTime aDate = aDateStr.isNotEmpty
              ? DateTime.tryParse(aDateStr) ?? DateTime(1900)
              : DateTime(1900);
          DateTime bDate = bDateStr.isNotEmpty
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

  String _extractLatestUpdate(Map sent) {
    if (sent['info'] != null && sent['info']['latest_update'] != null) {
      return sent['info']['latest_update'];
    }
    return '';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listItem({required Map Sent, required int index}) {
    String branchName = Sent['info']['ARM_location'] ?? "Not Available";
    String poc = Sent['info']['placeofcoupe'] ?? "N/A";
    String poc_exact = Sent['info']['PlaceOfCoupe_exact_from_arm'] ?? "N/A";
    String DateInformed = Sent['info']['dateinformed_from_rm'] ?? "N/A";
    String LetterNo = Sent['info']['LetterNo'] ?? "N/A";
    String SerialNum = Sent['info']['serialnum'] ?? "N/A";
    String OfficerName = Sent['info']['OfficerName'] ?? "N/A";
    String OfficerPositionAndName =
        Sent['info']['OfficerPosition&name'] ?? "N/A";
    String donor_details = Sent['info']['donor_details'] ?? "N/A";
    String Condition = Sent['info']['Condition'] ?? "N/A";
    String treeCount = Sent['info']['TreeCount'] ?? "N/A";
    String CO_name = Sent['info']['CO_name'] ?? "N/A";
    String CO_id = Sent['info']['CO_id'] ?? "N/A";
    String ARM_id = Sent['info']['ARM_Id'] ?? "N/A";
    String Income = Sent['info']['income'].toString();
    String Outcome = Sent['info']['outcome'].toString();
    String RM = Sent['info']['RM_Id'] ?? "N/A";
    String RM_office = Sent['info']['RM_office'] ?? "N/A";
    String latestUpdate = Sent['info']['latest_update'] ?? "N/A";
    String TO_DOC = "RM Office $RM_office";
    String ADGM_Id = Sent['info']['RM_Id'] ?? "N/A";
    Color statusColour = Color.fromRGBO(52, 199, 89, 1);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DGM_Sent_approved_view(
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
              Profit: (Income.isNotEmpty && Outcome.isNotEmpty)
                  ? (((double.tryParse(Income) ?? 0) -
                            (double.tryParse(Outcome) ?? 0))
                        .toString())
                  : "N/A",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: AvatarPlus(TO_DOC, height: 40, width: 40),
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
                        TO_DOC,
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
                      ADGM_Id,
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

              /// Search Bar
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
                  controller: _scrollController,
                  itemCount: _sentList.length,
                  itemBuilder: (context, index) {
                    Map sent = _sentList[index];
                    final String pocVal = sent['info']?['placeofcoupe'] ?? "";
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
