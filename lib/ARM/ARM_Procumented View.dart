import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  });

  @override
  State<ARM_Procumented_view> createState() => _ARM_Procumented_viewState();
}

class _ARM_Procumented_viewState extends State<ARM_Procumented_view> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool isLoading = true;
  Map<String, dynamic> procurementData = {};

  @override
  void initState() {
    super.initState();
    _fetchProcurementData();
  }

  Future<void> _fetchProcurementData() async {
    try {
      final snapshot = await _dbRef
          .child('procurement')
          .child(widget.ARM_Branch_Name)
          .child(widget.SerialNum)
          .get();

      if (snapshot.exists) {
        setState(() {
          procurementData = Map<String, dynamic>.from(
            snapshot.value as Map<Object?, Object?>,
          );
          isLoading = false;
        });
      } else {
        setState(() {
          procurementData = {};
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Procurement Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : procurementData.isEmpty
          ? const Center(
              child: Text(
                "No procurement data found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: procurementData.entries.map((entry) {
                final option = entry.key;
                final data = Map<String, dynamic>.from(
                  entry.value as Map<Object?, Object?>,
                );

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.work_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Procurement $option",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _infoTile("Procurement ID", data["procurement_id"]),
                      _infoTile(
                        "Procurementer Name",
                        data["procurementer_name"],
                      ),
                      _infoTile("Mobile", data["procurement_mobile"]),
                      _infoTile("Value", data["procurement_value"]),
                      const Divider(height: 28),

                      // Saved Time
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data["saved_at"] ??
                                DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                ).format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Flexible(
            child: Text(
              value ?? "N/A",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
