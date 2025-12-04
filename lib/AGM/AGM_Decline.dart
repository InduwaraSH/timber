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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // important
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return CupertinoAlertDialog(
                title: const Text(
                  'Permission Alert',
                  style: TextStyle(
                    fontFamily: 'sfproRoundSemiB',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                content: Text(
                  'Once you confirm, the deal will be marked as approved and forwarded to the ${widget.RM_office} RM.',
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
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'sfpro',
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      if (declineReasonController.text.isEmpty) {
                        print("add value");
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

                        // Set info under ARM_branch_data_saved_test
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
                                  "${declineReasonController.text} ${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}   ",
                              "income": widget.Income,
                              "outcome": widget.Outcome,
                              "latest_update": DateFormat(
                                'yyyy-MM-dd HH:mm:ss',
                              ).format(DateTime.now()).toString(),
                            });

                        // Also mirror to RM_branch_data_saved_test

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
                                  "${declineReasonController.text} ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString()}",
                              "income": widget.Income,
                              "outcome": widget.Outcome,
                              "latest_update": DateFormat(
                                'yyyy-MM-dd HH:mm:ss',
                              ).format(DateTime.now()).toString(),
                            })
                            //Update status_of_job_test
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
        icon: const Icon(Iconsax.tick_circle, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: declineReasonController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Enter reason for declining",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
