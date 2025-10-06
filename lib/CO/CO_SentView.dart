import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/c_test.dart';

class CoSentview extends StatefulWidget {
  final String office_location;
  final String co;
  final String poc;
  final String PlaceOfCoupe_exact_from_arm;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String OfficerName;
  final String OfficerPositionAndName;
  final String donor_details;
  final String Condition;
  final String treeCount;
  final String user_name;

  const CoSentview({
    super.key,
    required this.office_location,
    required this.co,
    required this.poc,
    required this.PlaceOfCoupe_exact_from_arm,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.OfficerName,
    required this.OfficerPositionAndName,
    required this.donor_details,
    required this.Condition,
    required this.treeCount,
    required this.user_name,
  });

  @override
  State<CoSentview> createState() => _CoSentviewState();
}

class _CoSentviewState extends State<CoSentview> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('CO_branch_data_saved')
        .child(widget.user_name)
        .child("Sent")
        .child(widget.SerialNum)
        .child("allTrees");

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

  IconData _getIconForLabel(String label) {
    if (label.contains("Serial")) return Iconsax.code;
    if (label.contains("Date")) return Iconsax.calendar_1;
    if (label.contains("Officer")) return Iconsax.user;
    if (label.contains("Condition")) return Iconsax.danger;
    if (label.contains("Letter")) return Iconsax.document_text_1;
    if (label.contains("Tree")) return Iconsax.tree4;
    if (label.contains("Place")) return Iconsax.map;
    if (label.contains("CO")) return Iconsax.user_octagon;
    if (label.contains("POC")) return Iconsax.user_square;
    return Iconsax.info_circle;
  }

  Widget _summaryItem(String label, String value, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForLabel(label),
                  color: const Color(0xFF6C63FF),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _treeCard(Map data, int index) {
    final fields = {
      "Tree Type": data["Tree Type"] ?? "N/A",
      "Grade": data["Grade"] ?? "N/A",
      "Actual Height": data["Actual Height"] ?? "N/A",
      "Com Height": data["Commercial Height"] ?? "N/A",
      "G at B Height": data["Girth at Breast Height"] ?? "N/A",
      "Volume": data["Volume"] ?? "N/A",
      "Value": data["Value"] ?? "N/A",
      "Other": data["Other"] ?? "N/A",
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tree header
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 20.0),
                child: Text(
                  "Tree ${index + 1}",
                  style: const TextStyle(
                    fontFamily: 'sfproRoundSemiB',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),

          ...fields.entries
              .map((e) => _summaryItem(e.key, e.value, index))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showHeader ? 100 : 0,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _showHeader
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sent",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sfproRoundSemiB',
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            test(office_location: widget.office_location),
                      ),
                    );
                  },
                  backgroundColor: Colors.black,
                  child: const Icon(Iconsax.chart_15, color: Colors.green),
                ),
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final infoItems = [
      {"label": "CO", "value": widget.co},
      {"label": "POC", "value": widget.poc},
      {"label": "Place of Coupe", "value": widget.PlaceOfCoupe_exact_from_arm},
      {"label": "Date Informed", "value": widget.DateInformed},
      {"label": "Letter No", "value": widget.LetterNo},
      {"label": "Serial No", "value": widget.SerialNum},
      {"label": "Officer Name", "value": widget.OfficerName},
      {"label": "Officer Position", "value": widget.OfficerPositionAndName},
      {"label": "Donor Details", "value": widget.donor_details},
      {"label": "Condition", "value": widget.Condition},
      {"label": "Tree Count", "value": widget.treeCount},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 16),
              ...infoItems
                  .asMap()
                  .entries
                  .map(
                    (entry) => _summaryItem(
                      entry.value["label"]!,
                      entry.value["value"]!,
                      entry.key,
                    ),
                  )
                  .toList(),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                child: const Text(
                  "Tree Details",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sfproRoundSemiB',
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FirebaseAnimatedList(
                query: dbref,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                defaultChild: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                ),
                itemBuilder: (context, snapshot, animation, index) {
                  Map data = snapshot.value as Map;
                  data['key'] = snapshot.key;
                  return _treeCard(data, index);
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // floatingActionButton: Container(
      //   margin: const EdgeInsets.only(bottom: 10),
      //   child: FloatingActionButton.extended(
      //     backgroundColor: const Color(0xFF6C63FF),
      //     elevation: 6,
      //     onPressed: () {},
      //     label: const Row(
      //       children: [
      //         Text(
      //           "Confirm & Save",
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontFamily: 'sfproRoundSemiB',
      //             fontSize: 16,
      //             color: Colors.white,
      //           ),
      //         ),
      //         SizedBox(width: 8),
      //         Icon(Iconsax.tick_circle, color: Colors.white),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
