import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ArmProcumentAdd extends StatefulWidget {
  final String ARM_Office;
  final String SerialNum;
  final String user_name;
  final List<Map<String, dynamic>> allTrees;
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
  final String RM_office;
  final String CO_name;
  final String CO_id;

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
    required this.RM_office,
    required this.CO_name,
    required this.CO_id,
  });

  @override
  State<ArmProcumentAdd> createState() => _ArmProcumentAddState();
}

class _ArmProcumentAddState extends State<ArmProcumentAdd> {
  bool _saving = false;

  // --- Text Controllers ---
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _outcomeController = TextEditingController();

  @override
  void dispose() {
    _incomeController.dispose();
    _outcomeController.dispose();

    super.dispose();
  }

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
          const SizedBox(height: 12),
          ...fields.entries.map((e) => _summaryItem(e.key, e.value)).toList(),
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'sfproRoundSemiB'),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    final database = FirebaseDatabase.instance.ref();
    setState(() => _saving = true);
    try {
      await database
          .child('ARM_branch_data_saved')
          .child(widget.office_location)
          .child("Sent")
          .child(widget.SerialNum)
          .set({"Reciver": "RM"});

      await database
          .child('ARM_branch_data_saved')
          .child(widget.office_location)
          .child("Sent")
          .child(widget.SerialNum)
          .child("allTrees")
          .set(widget.allTrees);

      await database
          .child('ARM_branch_data_saved')
          .child(widget.office_location)
          .child("Sent")
          .child(widget.SerialNum)
          .child("info")
          .set({
            "ARM_Office": widget.ARM_Office,
            "arm_id": widget.user_name,
            "CO_name": widget.CO_name,
            "CO_id": widget.CO_id,
            "poc": widget.poc,
            "DateInformed": widget.DateInformed,
            "LetterNo": widget.LetterNo,
            "OfficerName": widget.OfficerName,
            "OfficerPositionAndName": widget.OfficerPositionAndName,
            "donor_details": widget.donor_details,
            "Condition": widget.Condition,
            "SerialNum": widget.SerialNum,
            "treeCount": widget.treeCount,
            "PlaceOfCoupe_exact_from_arm": widget.PlaceOfCoupe_exact_from_arm,
            "Income": _incomeController.text.trim(),
            "Outcome": _outcomeController.text.trim(),
            "Reciver": "RM",
            "latest_update": DateFormat(
              'yyyy-MM-dd HH:mm:ss',
            ).format(DateTime.now()).toString(),
            "profitValue":
                (double.tryParse(
                      _incomeController.text.trim().isNotEmpty
                          ? _incomeController.text.trim()
                          : "0",
                    ) ??
                    0) -
                (double.tryParse(
                      _outcomeController.text.trim().isNotEmpty
                          ? _outcomeController.text.trim()
                          : "0",
                    ) ??
                    0),
          });

      await database
          .child('RM_branch_data_saved')
          .child(widget.RM_office)
          .child("Recived")
          .child(widget.SerialNum)
          .set({"from": "ARM"});

      await database
          .child('RM_branch_data_saved')
          .child(widget.RM_office)
          .child("Recived")
          .child(widget.SerialNum)
          .child("allTrees")
          .set(widget.allTrees);

      await database
          .child('RM_branch_data_saved')
          .child(widget.RM_office)
          .child("Recived")
          .child(widget.SerialNum)
          .child("info")
          .set({
            "ARM_Office": widget.ARM_Office,
            "ARM_ID": widget.user_name,
            "CO_name": widget.CO_name,
            "CO_id": widget.CO_id,
            "poc": widget.poc,
            "DateInformed": widget.DateInformed,
            "LetterNo": widget.LetterNo,
            "OfficerName": widget.OfficerName,
            "OfficerPositionAndName": widget.OfficerPositionAndName,
            "donor_details": widget.donor_details,
            "Condition": widget.Condition,
            "SerialNum": widget.SerialNum,
            "treeCount": widget.treeCount,
            "PlaceOfCoupe_exact_from_arm": widget.PlaceOfCoupe_exact_from_arm,
            "Income": _incomeController.text.trim(),
            "Outcome": _outcomeController.text.trim(),
            "Reciver": "RM",
            "latest_update": DateFormat(
              'yyyy-MM-dd HH:mm:ss',
            ).format(DateTime.now()).toString(),
            "profitValue":
                (double.tryParse(
                      _incomeController.text.trim().isNotEmpty
                          ? _incomeController.text.trim()
                          : "0",
                    ) ??
                    0) -
                (double.tryParse(
                      _outcomeController.text.trim().isNotEmpty
                          ? _outcomeController.text.trim()
                          : "0",
                    ) ??
                    0),
          })
          .then((_) {
            FirebaseDatabase.instance
                .ref()
                .child("Status_of_job")
                .child(widget.ARM_Office.toString())
                .child(widget.SerialNum.toString())
                .child("Status")
                .set("RM_R_D_two");
          })
          .then((_) {
            FirebaseDatabase.instance
                .ref()
                .child("Status_of_job")
                .child(widget.ARM_Office.toString())
                .child(widget.SerialNum.toString())
                .child("RM_R_D_two")
                .set(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                );
          })
          .then((_) {
            try {
              FirebaseDatabase.instance
                  .ref()
                  .child("ARM_branch_data_saved")
                  .child(widget.office_location.toString())
                  .child("Recived")
                  .child(widget.SerialNum.toString())
                  .remove();
              print('Data deleted successfully');
            } catch (e) {
              print('Error deleting data: $e');
            }
          })
          .then((_) {
            try {
              FirebaseDatabase.instance
                  .ref()
                  .child("RM_branch_data_saved")
                  .child(widget.RM_office.toString())
                  .child("Sent")
                  .child(widget.SerialNum.toString())
                  .remove();
              print('Data deleted successfully');
            } catch (e) {
              print('Error deleting data: $e');
            }
          });
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Data saved successfully",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 10),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 30, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Outcome",
                    style: TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: _saving
                        ? null
                        : () {
                            if (_incomeController.text.trim().isEmpty ||
                                _outcomeController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please fill both Income and Outcome fields.",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            _saveData();
                          },
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
                              Text(
                                "Save Data",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'sfproRoundSemiB',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Iconsax.tick_circle, color: Colors.white),
                            ],
                          ),
                    backgroundColor: const Color(0xFF6C63FF),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 10),
              child: Text(
                " Enter expected income and outcome",
                style: TextStyle(
                  fontFamily: 'sfproRoundSemiB',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            _inputField("Income", _incomeController, Iconsax.money),
            _inputField("Outcome", _outcomeController, Iconsax.wallet_3),

            // const SizedBox(height: 50),
            // // All Tree Cards
            // ...widget.allTrees.asMap().entries.map(
            //   (entry) => _treeCard(entry.value, entry.key),
            // ),
            // const SizedBox(height: 10),

            // New Input Fields
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
