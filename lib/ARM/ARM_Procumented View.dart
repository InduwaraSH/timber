import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/ARM/ARM_RecivedViewApproved.dart';
import 'package:timber_app/ARM/ARM_Tree_Cut_state.dart';
import 'package:timber_app/Snack_Message.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Snack_Message.dart' show showTopSnackBar;

class ARM_Procumented_view extends StatefulWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String OfficerName;
  final String OfficerPositionAndName;
  final String donor_details;
  final String Condition;
  final String treeCount;
  final String office_location;
  final String PlaceOfCoupe_exact_from_arm;
  final String user_name;
  final String ARM_Branch_Name;
  final String ARM_Office;
  final String Income;
  final String Outcome;
  final String Profit;
  final String Status;
  final String ADGM_ID;
  final String RM_office;
  final String CO_id;
  final String CO_name;
  final String ARM_ID;
  final String RM_ID;
  final String reject_details;

  const ARM_Procumented_view({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.OfficerName,
    required this.OfficerPositionAndName,
    required this.donor_details,
    required this.Condition,
    required this.treeCount,
    required this.office_location,
    required this.PlaceOfCoupe_exact_from_arm,
    required this.user_name,
    required this.ARM_Branch_Name,
    required this.ARM_Office,
    required this.Income,
    required this.Outcome,
    required this.Profit,
    required this.Status,
    required this.ADGM_ID,
    required this.RM_office,
    required this.CO_id,
    required this.CO_name,
    required this.ARM_ID,
    required this.RM_ID,
    required this.reject_details,
  });

  @override
  State<ARM_Procumented_view> createState() => _ARM_Procumented_viewState();
}

class _ARM_Procumented_viewState extends State<ARM_Procumented_view> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final ScrollController _scrollController = ScrollController();

  bool _isHeaderVisible = true;
  double _lastScrollOffset = 0;
  String searchQuery = "";

  Map<dynamic, dynamic> procurementData = {};
  List<MapEntry<dynamic, dynamic>> _procurementEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchProcurementData();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          // Scrolling down → hide header
          if (_isHeaderVisible) setState(() => _isHeaderVisible = false);
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          // Scrolling up → show header
          if (!_isHeaderVisible) setState(() => _isHeaderVisible = true);
        }
      });
    });
  }

  Future<void> _fetchProcurementData() async {
    try {
      final snapshot = await _dbRef
          .child('procurement')
          .child(widget.ARM_Branch_Name)
          .child(widget.SerialNum)
          .get();

      if (snapshot.exists && snapshot.value is Map) {
        setState(() {
          procurementData = Map<dynamic, dynamic>.from(snapshot.value as Map);
          _procurementEntries = procurementData.entries.toList();
        });
      } else {
        setState(() {
          procurementData = {};
          _procurementEntries = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching data: $e")));
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber == "N/A") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mobile number not available.")),
      );
      return;
    }

    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri(scheme: 'tel', path: sanitizedNumber);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        showTopSnackBar(
          context,
          message: "Cannot launch dialer",
          backgroundColor: Colors.red, // optional
        );
      }
    } catch (e) {
      showTopSnackBar(
        context,
        message: "Error launching dialer: $e",
        backgroundColor: Colors.red, // optional
      );
    }
  }

  void _openArmReceivedSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 0),

                  Expanded(
                    child: CupertinoPageScaffold(
                      backgroundColor: Colors.transparent,

                      child: TreeCutStatus(
                        office: widget.ARM_Branch_Name,

                        rm: widget.RM_office,
                        serial: widget.SerialNum,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _procurementEntries.where((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      final name = data["procurementer_name"]?.toString().toLowerCase() ?? "";
      final valueStr =
          data["procurement_value"]?.toString().toLowerCase() ?? "";
      return searchQuery.isEmpty ||
          name.contains(searchQuery.toLowerCase()) ||
          valueStr.contains(searchQuery.toLowerCase());
    }).toList();

    final lastUpdate = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isHeaderVisible ? 100 : 0,
              child: _isHeaderVisible ? _buildTopHeader(lastUpdate) : null,
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
                  hintText: "Search by name or value",
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: filteredEntries.length,
                itemBuilder: (context, idx) {
                  final entry = filteredEntries[idx];
                  return _buildDarkCard(entry.key, entry.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(String lastUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Proc List",
                      style: TextStyle(
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            _openArmReceivedSheet(context);
                          },
                          backgroundColor: Colors.black,
                          child: const Icon(
                            Icons.forest_rounded,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArmRecivedviewapproved(
                                  poc: widget.poc,
                                  DateInformed: widget.DateInformed,
                                  LetterNo: widget.LetterNo,
                                  SerialNum: widget.SerialNum,
                                  OfficerName: widget.OfficerName,
                                  OfficerPositionAndName:
                                      widget.OfficerPositionAndName,
                                  donor_details: widget.donor_details,
                                  Condition: widget.Condition,
                                  treeCount: widget.treeCount,
                                  office_location: widget.office_location,
                                  PlaceOfCoupe_exact_from_arm:
                                      widget.PlaceOfCoupe_exact_from_arm,
                                  user_name: widget.user_name,
                                  ARM_Branch_Name: widget.ARM_Branch_Name,
                                  ARM_Office: widget.ARM_Office,
                                  Income: widget.Income,
                                  Outcome: widget.Outcome,
                                  Profit: widget.Profit,
                                  Status: widget.Status,
                                  ADGM_ID: widget.ADGM_ID,
                                  RM_office: widget.RM_office,
                                  CO_id: widget.CO_id,
                                  CO_name: widget.CO_name,
                                  ARM_ID: widget.ARM_ID,
                                  RM_ID: widget.RM_ID,
                                  reject_details: widget.reject_details,
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.black,
                          child: const Icon(
                            Iconsax.info_circle4,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkCard(String option, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map<Object?, Object?>);
    final String savedAt =
        data["saved_at"] ??
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final String mobileNumber = data["procurement_mobile"] ?? "N/A";
    final String name = data["procurementer_name"] ?? "Unknown";
    final String id = data["procurement_id"] ?? "—";
    final String valueStr = data["procurement_value"] ?? "—";
    final bool isSelected = data["selected"] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff121212),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTag("Procurement", icon: Iconsax.home),
                  const SizedBox(width: 15),
                  if (isSelected)
                    _buildTag_selected("Selected", icon: Iconsax.verify4),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () => _makePhoneCall(mobileNumber),
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Iconsax.call,
                      size: 25,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: "sfproRoundSemiB",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "NIC: $id",
                style: const TextStyle(
                  fontFamily: "sfproRoundSemiB",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 0),
              Text(
                "VALUE: $valueStr",
                style: const TextStyle(
                  fontFamily: "sfproRoundSemiB",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Icon(Iconsax.call, size: 18, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      mobileNumber,
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "Saved at $savedAt",
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(57, 33, 149, 243),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 22, color: Colors.blueAccent),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: "sfproRoundSemiB",
              fontWeight: FontWeight.normal,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTag_selected(String text, {IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color.fromARGB(47, 233, 30, 98),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 22, color: Colors.pink),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "sfproRoundSemiB",
            fontWeight: FontWeight.normal,
            color: Colors.pink,
          ),
        ),
      ],
    ),
  );
}
