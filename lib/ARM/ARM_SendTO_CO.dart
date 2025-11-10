import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

class ARM_SentTO_CO extends StatefulWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String CO_Name;
  final String CO_ID;
  final String office_location;
  final String RM_office;

  const ARM_SentTO_CO({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.CO_Name,
    required this.CO_ID,
    required this.office_location,
    required this.RM_office,
  });

  @override
  State<ARM_SentTO_CO> createState() => _ARM_SentTO_COState();
}

class _ARM_SentTO_COState extends State<ARM_SentTO_CO> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFBFF), Color(0xFFEDEBFF)], // pastel gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Review",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sfproRoundSemiB",
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),

                  // CO Profile Card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sent To :",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.5),
                              fontFamily: "sfproRoundSemiB",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              ClipOval(
                                child: AvatarPlus(
                                  widget.CO_Name,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.CO_Name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "sfproRoundSemiB",
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),

                  // Info Cards
                  _buildInfoCard(
                    "Date Informed",
                    widget.DateInformed,
                    Iconsax.calendar,
                  ),
                  _buildInfoCard(
                    "Letter No",
                    widget.LetterNo,
                    Iconsax.document,
                  ),
                  _buildInfoCard(
                    "Serial Number",
                    widget.SerialNum,
                    Iconsax.hashtag,
                  ),
                  _buildInfoCard(
                    "Place of Coupe",
                    widget.poc,
                    Iconsax.location,
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: CupertinoButton(
                      color: Colors.blue,
                      child: Text(
                        "Send Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "sfproRoundSemiB",
                        ),
                      ),
                      onPressed: () async {
                        bool result =
                            await InternetConnection().hasInternetAccess;

                        if (result == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'No internet connection',
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.grey,
                            ),
                          );
                          return;
                        } else {
                          Map<String, String> reqData = {
                            'Serial Number': widget.SerialNum,
                            'placeOfCoupe': widget.poc,
                            'LetterNo': widget.LetterNo,
                            'DateInformed': widget.DateInformed,

                            "arm_office_location": widget.office_location
                                .toString(),
                            "from": "CO ${widget.CO_Name}",
                            "Reciver": "CO",
                            "RM_office": widget.RM_office.toString(),
                            "latest_update": DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()).toString(),
                          };
                          FirebaseDatabase.instance
                              .ref()
                              .child("CO_branch_data_saved")
                              .child(widget.CO_ID.toString())
                              .child("Recived")
                              .child(widget.SerialNum.toString())
                              .set(reqData)
                              .then((_) {
                                FirebaseDatabase.instance
                                    .ref()
                                    .child("ARM_branch_data_saved")
                                    .child(widget.office_location.toString())
                                    .child("Sent")
                                    .child(widget.SerialNum.toString())
                                    .set(reqData);
                              })
                              .then((_) async {
                                DatabaseReference ongoingRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child("ARM_branch_data_saved")
                                    .child(widget.office_location.toString())
                                    .child("Ongoing_Count")
                                    .child(widget.CO_ID.toString())
                                    .child("ongoing");

                                await ongoingRef.runTransaction((currentData) {
                                  int currentValue =
                                      (currentData as int?) ??
                                      0; // if not exist → 0
                                  return Transaction.success(currentValue + 1);
                                });
                              })
                              .then((_) {
                                FirebaseDatabase.instance
                                    .ref()
                                    .child("Status_of_job")
                                    .child(widget.office_location.toString())
                                    .child(widget.SerialNum.toString())
                                    .child("Status")
                                    .set("CO_R_D_One");
                              })
                              .then((_) {
                                FirebaseDatabase.instance
                                    .ref()
                                    .child("Status_of_job")
                                    .child(widget.office_location.toString())
                                    .child(widget.SerialNum.toString())
                                    .child("CO_R_D_One")
                                    .set(
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(DateTime.now()).toString(),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Job Placed Successfully",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              })
                              .then((_) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                              .catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update data: $error',
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Extra space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Info Card
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 253, 253, 253), Color(0xFFEDEBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            // decoration: BoxDecoration(
            //   gradient: const LinearGradient(
            //     colors: [
            //       Color.fromARGB(255, 215, 214, 214),
            //       Color.fromARGB(255, 215, 214, 214),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //   borderRadius: BorderRadius.circular(16),
            // ),
            child: Icon(icon, color: Colors.grey, size: 40),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontFamily: "sfproRoundRegular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "sfproRoundSemiB",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
