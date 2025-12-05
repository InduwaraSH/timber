import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/Snack_Message.dart';

class AgmDecline extends StatefulWidget {
  final String office;
  final String rm_office;
  final String serial;
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
  final String user_name;
  final String ARM_Branch_Name;
  final String Income;
  final String Outcome;
  final String Profit;
  final String RM_office;
  final String CO_id;
  final String CO_name;
  final String ARM_ID;
  final String RM_ID;
  final String reject_details;
  final String updated_income;
  final String updated_outcome;
  final Object? tree;
  const AgmDecline({
    super.key,
    required this.office,
    required this.rm_office,
    required this.serial,
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
    required this.user_name,
    required this.ARM_Branch_Name,
    required this.Income,
    required this.Outcome,
    required this.Profit,
    required this.RM_office,
    required this.CO_id,
    required this.CO_name,
    required this.ARM_ID,
    required this.RM_ID,
    required this.tree,
    required this.reject_details,
    required this.updated_income,
    required this.updated_outcome,
  });

  @override
  State<AgmDecline> createState() => _AgmDeclineState();
}

class _AgmDeclineState extends State<AgmDecline> {
  TextEditingController declineReasonController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();

  late Query dbref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // iOS Grouped Background Color

      resizeToAvoidBottomInset: true,
      // --- BUTTON STYLE UNCHANGED AS REQUESTED ---
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return CupertinoAlertDialog(
                  title: const Text(
                    'Rejection Alert',
                    style: TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                  content: Text(
                    'Once you press Reject, this document will be marked as Rejected and forwarded to the relevant ARM through the RM office, along with your rejection reason.',
                    style: TextStyle(
                      fontFamily: 'sfproRoundRegular',
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () async {
                        if (declineReasonController.text.isEmpty) {
                          print("add value");
                          // Optional: Add a snackbar here to tell user to add text
                        } else {
                          final database = FirebaseDatabase.instance.ref();

                          // Write to ARM_branch_data_saved_test
                          if (widget.tree != null) {
                            await database
                                .child('RM_branch_data_saved')
                                .child(widget.RM_office)
                                .child("Recived")
                                .child(widget.serial)
                                .set({"from": "ADGM_Rejected"});
                          }

                          // Copy allTrees if present
                          await database
                              .child('RM_branch_data_saved')
                              .child(widget.RM_office)
                              .child("Recived")
                              .child(widget.serial)
                              .child("allTrees")
                              .set(widget.tree);

                          // Set info
                          await database
                              .child('RM_branch_data_saved')
                              .child(widget.RM_office)
                              .child("Recived")
                              .child(widget.serial)
                              .child("timberReportheadlines")
                              .set({
                                "serialnum": widget.serial,
                                "placeofcoupe": widget.poc,
                                "dateinformed_from_rm": widget.DateInformed,
                                "donor_details": widget.donor_details,
                                "PlaceOfCoupe_exact_from_arm":
                                    widget.PlaceOfCoupe_exact_from_arm,
                                "LetterNo": widget.LetterNo,
                                "Condition": widget.Condition,
                                "OfficerName": widget.OfficerName,
                                "OfficerPosition&name":
                                    widget.OfficerPositionAndName,
                                "TreeCount": widget.treeCount.toString(),
                                "Date": widget.DateInformed,
                                "ARM_location": widget.ARM_Branch_Name,
                                "CO_name": widget.CO_name,
                                "CO_id": widget.CO_id,
                                "ARM_Id": widget.ARM_ID,
                                "RM_Id": widget.RM_ID,
                                "ADGM_id": widget.user_name,
                                "ADGM_type": "AGM",
                                "Reason":
                                    "{${widget.reject_details}}  ${declineReasonController.text} on ${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}   ",
                                "income": widget.Income,
                                "outcome": widget.Outcome,
                                "updated_income": widget.updated_income,
                                "updated_outcome": widget.updated_outcome,
                                "profit": widget.Profit,
                                "latest_update": DateFormat(
                                  'yyyy-MM-dd HH:mm:ss',
                                ).format(DateTime.now()).toString(),
                              });

                          // Head office data saved
                          if (widget.tree != null) {
                            await database
                                .child('Head_office_data_saved')
                                .child("AGM")
                                .child("Send")
                                .child(widget.serial)
                                .set({"from": "ADGM_Rejected"});

                            await database
                                .child('Head_office_data_saved')
                                .child("AGM")
                                .child("Send")
                                .child(widget.serial)
                                .child("allTrees")
                                .set(widget.tree);
                          }

                          await database
                              .child('Head_office_data_saved')
                              .child("AGM")
                              .child("Send")
                              .child(widget.serial)
                              .child("info")
                              .set({
                                "serialnum": widget.serial,
                                "placeofcoupe": widget.poc,
                                "dateinformed_from_rm": widget.DateInformed,
                                "donor_details": widget.donor_details,
                                "PlaceOfCoupe_exact_from_arm":
                                    widget.PlaceOfCoupe_exact_from_arm,
                                "LetterNo": widget.LetterNo,
                                "Condition": widget.Condition,
                                "OfficerName": widget.OfficerName,
                                "OfficerPosition&name":
                                    widget.OfficerPositionAndName,
                                "TreeCount": widget.treeCount.toString(),
                                "Date": widget.DateInformed,
                                "ARM_location": widget.ARM_Branch_Name,
                                "RM_office": widget.RM_office,
                                "CO_name": widget.CO_name,
                                "CO_id": widget.CO_id,
                                "ARM_Id": widget.ARM_ID,
                                "RM_Id": widget.RM_ID,
                                "ADGM_id": widget.user_name,
                                "ADGM_type": "AGM",
                                "Reason":
                                    "{${widget.reject_details}}  ${declineReasonController.text} on ${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}   ",
                                "income": widget.Income,
                                "outcome": widget.Outcome,
                                "profit": widget.Profit,
                                "updated_income": widget.updated_income,
                                "updated_outcome": widget.updated_outcome,
                                "latest_update": DateFormat(
                                  'yyyy-MM-dd HH:mm:ss',
                                ).format(DateTime.now()).toString(),
                              })
                              .then((_) {
                                try {
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child('Head_office_data_saved')
                                      .child("AGM")
                                      .child("Recived")
                                      .child(widget.serial.toString())
                                      .remove();
                                  print('Data deleted successfully');
                                  showTopSnackBar(
                                    context,
                                    message: "Data sent to RM successfully",
                                    backgroundColor: Colors.green,
                                  );
                                } catch (e) {
                                  showTopSnackBar(
                                    context,
                                    message: "Error deleting data: $e",
                                    backgroundColor: Colors.red,
                                  );
                                }
                              })
                              .then((_) {
                                try {
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child("RM_branch_data_saved")
                                      .child(widget.RM_office.toString())
                                      .child("Sent")
                                      .child(widget.serial.toString())
                                      .remove();
                                  print('Data deleted successfully');
                                } catch (e) {
                                  print('Error deleting data: $e');
                                }
                              });

                          Navigator.of(dialogContext).pop();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.redAccent,
          label: const Text(
            "Reject",
            style: TextStyle(
              fontFamily: 'sfproRoundSemiB',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          icon: const Icon(Iconsax.close_circle, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.warning_2,
                            color: Colors.orangeAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Serial No.",
                                style: TextStyle(
                                  fontFamily: 'sfproRoundRegular',
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                widget.serial,
                                style: const TextStyle(
                                  fontFamily: 'sfproRoundSemiB',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 15),
                    _buildInfoRow("ARM Office", widget.office),
                    const SizedBox(height: 10),
                    _buildInfoRow("POC", widget.poc),
                    const SizedBox(height: 10),
                    _buildInfoRow("Date Informed", widget.DateInformed),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- SECTION 2: Input Area ---
              const Text(
                "Reason for Rejection",
                style: TextStyle(
                  fontFamily: 'sfproRoundSemiB',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: declineReasonController,
                  maxLines: 8,
                  style: const TextStyle(
                    fontFamily: 'sfproRoundRegular',
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "Please explain why this proposal is being rejected...",
                    hintStyle: TextStyle(
                      fontFamily: 'sfproRoundRegular',
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),

              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the summary card rows
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'sfproRoundRegular',
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'sfproRoundSemiB',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
