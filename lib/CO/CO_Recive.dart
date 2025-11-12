import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/CO/CO_Recived_View.dart';
import 'package:timber_app/RM/RM_ProfilePage.dart';

class CORecived extends StatefulWidget {
  final String office_location;
  final String username;
  const CORecived({
    super.key,
    required this.office_location,
    required this.username,
  });

  @override
  State<CORecived> createState() => _CORecivedState();
}

class _CORecivedState extends State<CORecived> {
  late DatabaseReference dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  int messageCount = 0;
  String searchQuery = "";
  List<Map> allItems = [];

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('CO_branch_data_saved')
        .child(widget.username)
        .child("Recived");

    dbref.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        List<Map> tempList = [];
        data.forEach((key, value) {
          if (value is Map) {
            value['key'] = key;
            tempList.add(value);
          }
        });

        tempList.sort((a, b) {
          final aUpdate = a['latest_update'] ?? '';
          final bUpdate = b['latest_update'] ?? '';
          DateTime aDate, bDate;
          try {
            aDate = DateTime.parse(aUpdate);
          } catch (_) {
            aDate = DateTime.fromMillisecondsSinceEpoch(0);
          }
          try {
            bDate = DateTime.parse(bUpdate);
          } catch (_) {
            bDate = DateTime.fromMillisecondsSinceEpoch(0);
          }
          return bDate.compareTo(aDate);
        });

        setState(() {
          allItems = tempList;
          messageCount = tempList.length;
        });
      } else {
        setState(() {
          allItems = [];
          messageCount = 0;
        });
      }
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
    final String branchName = Sent['arm_office_location'] ?? "Not Available";
    final String poc = Sent['placeOfCoupe'] ?? "N/A";
    final String DateInformed = Sent['DateInformed'] ?? "N/A";
    final String LetterNo = Sent['LetterNo'] ?? "N/A";
    final String SerialNum = Sent['Serial Number'] ?? "N/A";
    final String about_me = Sent['from'] ?? "Not Available";
    final String RM_office = Sent['RM_office'] ?? "Not Available";
    final String ARM_ID = Sent['ARM_id'] ?? "";

    String latestUpdate = Sent['latest_update'] ?? "";
    String from_doc = "ARM $ARM_ID";
    Color statusColour = Color.fromRGBO(255, 204, 0, 1);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CO_Received_View(
              branchName: branchName,
              poc: poc,
              DateInformed: DateInformed,
              LetterNo: LetterNo,
              SerialNum: SerialNum,
              username: widget.username,
              about_me: about_me,
              RM_office: RM_office,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = allItems.where((item) {
      final poc = item['placeOfCoupe']?.toString().toLowerCase() ?? "";
      return searchQuery.isEmpty || poc.contains(searchQuery);
    }).toList();

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
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showHeader ? 180 : 1,
                  curve: Curves.easeInOut,
                  child: _showHeader
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: 5,
                            right: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 18),
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
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
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
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      listItem(Sent: filteredItems[index], index: index),
                  childCount: filteredItems.length,
                ),
              ),
            ],
          ),
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
      child: CircleAvatar(
        radius: 30,
        backgroundColor: const Color.fromARGB(0, 238, 238, 238),
        child: ClipOval(child: AvatarPlus(username, height: 60, width: 60)),
      ),
    );
  }
}
