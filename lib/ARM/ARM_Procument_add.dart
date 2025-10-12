import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ArmProcumentAdd extends StatefulWidget {
  final String ARM_Office;
  final String SerialNum;
  final String user_name;
  final List<Map<String, dynamic>> allTrees;
  // Other fields can be added here as needed
  final String ARM_Branch_Name;
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String OfficerName;
  final String OfficerPositionAndName;
  final String donor_details;
  final String Condition;
  final String treeCount;
  final String office_location;
  final String PlaceOfCoupe_exact_from_arm;

  const ArmProcumentAdd({
    super.key,
    required this.ARM_Office,
    required this.SerialNum,
    required this.user_name,
    required this.allTrees,
    required this.ARM_Branch_Name,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.OfficerName,
    required this.OfficerPositionAndName,
    required this.donor_details,
    required this.Condition,
    required this.treeCount,
    required this.office_location,
    required this.PlaceOfCoupe_exact_from_arm,
  });

  @override
  State<ArmProcumentAdd> createState() => _ArmProcumentAddState();
}

class _ArmProcumentAddState extends State<ArmProcumentAdd> {
  bool _saving = false;

  IconData _getIconForLabel(String label) {
    if (label.contains("Type")) return Iconsax.tree4;
    if (label.contains("Grade")) return Iconsax.chart_15;
    if (label.contains("Height")) return Iconsax.arrow_up;
    if (label.contains("Girth")) return Iconsax.ruler;
    if (label.contains("Volume")) return Iconsax.box;
    if (label.contains("Value")) return Iconsax.money;
    if (label.contains("Other")) return Iconsax.note;
    return Iconsax.info_circle;
  }

  Widget _summaryItem(String label, String value) {
    return Container(
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

    return Container(
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
            ],
          ),
          const SizedBox(height: 12),
          ...fields.entries.map((e) => _summaryItem(e.key, e.value)).toList(),
        ],
      ),
    );
  }

  Future<void> _saveData() async {
    final database = FirebaseDatabase.instance.ref();
    setState(() => _saving = true);
    try {
      await database
          .child('Reports')
          .child(widget.SerialNum)
          .child("new")
          .child("allTrees")
          .set(widget.allTrees)
          .then((_) async {
            await database
                .child('Reports')
                .child(widget.SerialNum)
                .child("new")
                .child("info")
                .set({
                  "ARM_Office": widget.ARM_Office,
                  "user_name": widget.user_name,
                  "ARM_Branch_Name": widget.ARM_Branch_Name,
                  "poc": widget.poc,
                  "DateInformed": widget.DateInformed,
                  "LetterNo": widget.LetterNo,
                  "OfficerName": widget.OfficerName,
                  "OfficerPositionAndName": widget.OfficerPositionAndName,
                  "donor_details": widget.donor_details,
                  "Condition": widget.Condition,
                  "treeCount": widget.treeCount,
                  "office_location": widget.office_location,
                  "PlaceOfCoupe_exact_from_arm":
                      widget.PlaceOfCoupe_exact_from_arm,
                });
          });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving data: $e")));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      appBar: AppBar(
        title: const Text("Procument Add"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ...widget.allTrees.asMap().entries.map(
              (entry) => _treeCard(entry.value, entry.key),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _saveData,
        label: _saving
            ? const Row(
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(width: 10),
                  Text("Saving..."),
                ],
              )
            : const Row(
                children: [
                  Text("Save Data"),
                  SizedBox(width: 8),
                  Icon(Iconsax.tick_circle),
                ],
              ),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }
}
