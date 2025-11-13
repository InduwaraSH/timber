import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/Snack_Message.dart';

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

class _ArmProcumentAddState extends State<ArmProcumentAdd>
    with SingleTickerProviderStateMixin {
  bool _saving = false;

  // text controllers
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _outcomeController = TextEditingController();

  double _profit = 0.0;

  @override
  void initState() {
    super.initState();
    _incomeController.addListener(_updateProfit);
    _outcomeController.addListener(_updateProfit);
  }

  void _updateProfit() {
    final income = double.tryParse(_incomeController.text.trim()) ?? 0.0;
    final outcome = double.tryParse(_outcomeController.text.trim()) ?? 0.0;
    setState(() => _profit = income - outcome);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  Widget _topProfitCard(BuildContext context) {
    final profitPositive = _profit >= 0;
    final formatted = NumberFormat('#,##0.00', 'en_US').format(_profit.abs());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.black.withOpacity(0.03)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profit Overview",
                      style: TextStyle(
                        fontFamily: 'sfproRoundSemiB',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // big number row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'sfproRoundSemiB',
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: profitPositive
                            ? const Color.fromRGBO(52, 199, 89, 1)
                            : const Color.fromRGBO(233, 21, 45, 1),
                      ),
                      child: Text(
                        "රු ${profitPositive ? '' : '-'}${NumberFormat('#,##0.00', 'en_US').format(_profit.abs())}",
                        overflow: TextOverflow.ellipsis, // or .fade or .clip
                        maxLines: 1, // important for overflow to work
                        softWrap: false, // prevent wrapping
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  profitPositive
                      ? "You gained \$${formatted} this week. That's the best result in the last three months."
                      : "You lost \$${formatted} this week. Review outcome items.",
                  style: TextStyle(
                    color: const Color.fromARGB(91, 255, 255, 255),
                    fontFamily: 'sfproRoundSemiB',
                    fontSize: 13.5,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassyInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'sfproRoundSemiB',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      hintText: label,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // inline clear icon
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Iconsax.close_circle,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep the app background white as requested
    return Scaffold(
      backgroundColor: Colors.white, // always white background

      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 14, bottom: 92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top spacing + title
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Budget",
                        style: TextStyle(
                          fontFamily: 'sfproRoundSemiB',
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () async {
                          if (_incomeController.text.trim().isEmpty ||
                              _outcomeController.text.trim().isEmpty) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //       "Please fill both Income and Outcome fields.",
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     backgroundColor: Colors.redAccent,
                            //   ),
                            // );
                            showTopSnackBar(
                              context,
                              message:
                                  "Please fill both Income and Outcome fields.",
                              backgroundColor: Colors.redAccent,
                            );
                            return;
                          } else {
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
                                    "OfficerPositionAndName":
                                        widget.OfficerPositionAndName,
                                    "donor_details": widget.donor_details,
                                    "Condition": widget.Condition,
                                    "SerialNum": widget.SerialNum,
                                    "treeCount": widget.treeCount,
                                    "PlaceOfCoupe_exact_from_arm":
                                        widget.PlaceOfCoupe_exact_from_arm,
                                    "Income": _incomeController.text.trim(),
                                    "Outcome": _outcomeController.text.trim(),
                                    "Reciver": "RM",
                                    "latest_update": DateFormat(
                                      'yyyy-MM-dd HH:mm:ss',
                                    ).format(DateTime.now()).toString(),
                                    "profitValue":
                                        (double.tryParse(
                                              _incomeController.text
                                                      .trim()
                                                      .isNotEmpty
                                                  ? _incomeController.text
                                                        .trim()
                                                  : "0",
                                            ) ??
                                            0) -
                                        (double.tryParse(
                                              _outcomeController.text
                                                      .trim()
                                                      .isNotEmpty
                                                  ? _outcomeController.text
                                                        .trim()
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
                                    "OfficerPositionAndName":
                                        widget.OfficerPositionAndName,
                                    "donor_details": widget.donor_details,
                                    "Condition": widget.Condition,
                                    "SerialNum": widget.SerialNum,
                                    "treeCount": widget.treeCount,
                                    "PlaceOfCoupe_exact_from_arm":
                                        widget.PlaceOfCoupe_exact_from_arm,
                                    "Income": _incomeController.text.trim(),
                                    "Outcome": _outcomeController.text.trim(),
                                    "Reciver": "RM",
                                    "latest_update": DateFormat(
                                      'yyyy-MM-dd HH:mm:ss',
                                    ).format(DateTime.now()).toString(),
                                    "profitValue":
                                        (double.tryParse(
                                              _incomeController.text
                                                      .trim()
                                                      .isNotEmpty
                                                  ? _incomeController.text
                                                        .trim()
                                                  : "0",
                                            ) ??
                                            0) -
                                        (double.tryParse(
                                              _outcomeController.text
                                                      .trim()
                                                      .isNotEmpty
                                                  ? _outcomeController.text
                                                        .trim()
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
                                          .child(
                                            widget.office_location.toString(),
                                          )
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
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       "Data saved successfully",
                              //       style: const TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //     backgroundColor: Colors.green,
                              //   ),
                              // );
                              showTopSnackBar(
                                context,
                                message: "Data saved successfully",
                                backgroundColor: Colors.green,
                              );
                            } catch (e) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text("Error saving data: $e"),
                              //   ),
                              // );
                              showTopSnackBar(
                                context,
                                message: "Error saving data: $e",
                                backgroundColor: Colors.redAccent,
                              );
                            } finally {
                              setState(() => _saving = false);
                            }
                          }
                          ();
                        },

                        backgroundColor: Colors.black,
                        label: const Text(
                          "Approve",
                          style: TextStyle(
                            fontFamily: 'sfproRoundSemiB',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(52, 199, 89, 1),
                            fontSize: 16,
                          ),
                        ),
                        icon: const Icon(
                          Iconsax.tick_circle,
                          color: Color.fromRGBO(52, 199, 89, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // profit card
                _topProfitCard(context),
                // info line
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 6, bottom: 2),
                  child: Text(
                    "Enter expected income and outcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'sfproRoundSemiB',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // inputs
                _glassyInput(
                  label: "Income (LKR)",
                  icon: Iconsax.money_4,
                  controller: _incomeController,
                ),
                _glassyInput(
                  label: "Outcome (LKR)",
                  icon: Iconsax.wallet_3,
                  controller: _outcomeController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
