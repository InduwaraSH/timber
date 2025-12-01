import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:timber_app/ARM/ARMSentImageView.dart';
import 'package:timber_app/ARM/ARM_Sent_timeline.dart';
import 'package:timber_app/RM/RM_RecivedTimeline.dart';
import 'package:timber_app/Snack_Message.dart';

class RmRecivedView_ADGM extends StatefulWidget {
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

  final String ARM_Office;
  final String Income;
  final String Outcome;
  final String Profit;
  final String ARM_Id;
  final String CO_id;
  final String CO_name;
  final String AGM_ID;
  final String Status;
  final String RM_ID;
  final String ADGM_title;

  const RmRecivedView_ADGM({
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
    required this.RM_ID,
    required this.ARM_Office,
    required this.Income,
    required this.Outcome,
    required this.Profit,
    required this.ARM_Id,
    required this.CO_id,
    required this.CO_name,
    required this.AGM_ID,
    required this.Status,
    required this.ADGM_title,
  });

  @override
  State<RmRecivedView_ADGM> createState() => _RmRecivedView_ADGMState();
}

class _RmRecivedView_ADGMState extends State<RmRecivedView_ADGM> {
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String ADGM_Name = "";

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('RM_branch_data_saved')
        .child(widget.office_location)
        .child("Recived")
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
    if (label.contains("Donor")) return Iconsax.ghost;
    if (label.contains("Grade")) return Iconsax.weight;
    if (label.contains("Height")) return Iconsax.arrow_up;
    if (label.contains("Volume")) return Iconsax.cup;
    if (label.contains("Value")) return Iconsax.money;
    if (label.contains("Other")) return Iconsax.menu_board;
    if (label.contains("Income")) return Iconsax.money_add;
    if (label.contains("Outcome")) return Iconsax.money_remove;
    if (label.contains("Profit")) return Iconsax.money_change;
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
                Icon(_getIconForLabel(label), color: Colors.grey, size: 22),
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

  // ----------------- PDF GENERATION -----------------
  Future<void> _generatePdf() async {
    try {
      DatabaseEvent event = await dbref.once();
      List<Map<String, dynamic>> allTrees = [];

      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          Map<dynamic, dynamic> treesData =
              event.snapshot.value as Map<dynamic, dynamic>;
          treesData.forEach((key, value) {
            allTrees.add(Map<String, dynamic>.from(value));
          });
        } else if (event.snapshot.value is List) {
          List<dynamic> treesData = event.snapshot.value as List<dynamic>;
          for (var item in treesData) {
            if (item != null) allTrees.add(Map<String, dynamic>.from(item));
          }
        }
      }

      final pdf = pw.Document();

      final infoItems = [
        {"label": "Status", "value": widget.Status},
        {"label": "Approved By", "value": widget.AGM_ID},
        {"label": widget.ADGM_title, "value": widget.AGM_ID},
        {"label": "RM Office", "value": widget.office_location},
        {"label": "RM", "value": widget.RM_ID},
        {"label": "ARM Office", "value": widget.ARM_Office},
        {"label": "ARM ID", "value": widget.ARM_Id},
        {"label": "CO", "value": widget.CO_name},
        {"label": "CO ID", "value": widget.CO_id},
        {"label": "POC", "value": widget.poc},
        {"label": "POC Exact", "value": widget.PlaceOfCoupe_exact_from_arm},
        {"label": "Date Informed", "value": widget.DateInformed},
        {"label": "Letter No", "value": widget.LetterNo},
        {"label": "Serial No", "value": widget.SerialNum},
        {"label": "Officer Name", "value": widget.OfficerName},
        {"label": "Officer Position", "value": widget.OfficerPositionAndName},
        {"label": "Donor Details", "value": widget.donor_details},
        {"label": "Condition", "value": widget.Condition},
        {"label": "Tree Count", "value": widget.treeCount},
        {"label": "Expected Income", "value": "Rs. ${widget.Income}"},
        {"label": "Expected Expenditure", "value": "Rs. ${widget.Outcome}"},
        {"label": "Expected Profit", "value": "Rs. ${widget.Profit}"},
      ];

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "ARM Received Report",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Field', 'Value'],
              data: infoItems.map((e) => [e['label'], e['value']]).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Tree Details", style: const pw.TextStyle(fontSize: 18)),
            for (int i = 0; i < allTrees.length; i++) ...[
              pw.SizedBox(height: 12),
              pw.Text("Tree ${i + 1}", style: const pw.TextStyle(fontSize: 16)),
              pw.Table.fromTextArray(
                headers: ['Field', 'Value'],
                data: [
                  ["Tree Type", allTrees[i]["Tree Type"] ?? "N/A"],
                  ["Grade", allTrees[i]["Grade"] ?? "N/A"],
                  ["Actual Height", allTrees[i]["Actual Height"] ?? "N/A"],
                  ["Com Height", allTrees[i]["Commercial Height"] ?? "N/A"],
                  [
                    "G at B Height",
                    allTrees[i]["Girth at Breast Height"] ?? "N/A",
                  ],
                  ["Volume", allTrees[i]["Volume"] ?? "N/A"],
                  ["Value", allTrees[i]["Value"] ?? "N/A"],
                  ["Other", allTrees[i]["Other"] ?? "N/A"],
                ],
              ),
            ],
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error generating PDF: $e")));
    }
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
                  "Inbox",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sfproRoundSemiB',
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      heroTag: "printBtn",
                      onPressed: _generatePdf,
                      backgroundColor: Colors.black,
                      child: const Icon(
                        Iconsax.printer,
                        color: Colors.redAccent,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      heroTag: "imageBtn",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Armsentimageview(
                              poc: widget.poc,
                              SerialNum: widget.SerialNum,
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.black,
                      child: const Icon(Iconsax.image5, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      heroTag: "timelineBtn",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RmRecivedtimeline(
                              branchName: widget.ARM_Office,
                              poc: widget.poc,
                              SerialNum: widget.SerialNum,
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.black,
                      child: const Icon(Iconsax.chart_15, color: Colors.green),
                    ),
                  ],
                ),
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final infoItems = [
      {"label": "Status", "value": widget.Status},
      {"label": "Approved By", "value": widget.AGM_ID},
      {"label": widget.ADGM_title, "value": widget.AGM_ID},
      {"label": "RM Office", "value": widget.office_location},
      {"label": "RM", "value": widget.RM_ID},
      {"label": "ARM Office", "value": widget.ARM_Office},
      {"label": "ARM ID", "value": widget.ARM_Id},
      {"label": "CO", "value": widget.CO_name},
      {"label": "CO ID", "value": widget.CO_id},
      {"label": "POC", "value": widget.poc},
      {"label": "POC Exact", "value": widget.PlaceOfCoupe_exact_from_arm},
      {"label": "Date Informed", "value": widget.DateInformed},
      {"label": "Letter No", "value": widget.LetterNo},
      {"label": "Serial No", "value": widget.SerialNum},
      {"label": "Officer Name", "value": widget.OfficerName},
      {"label": "Officer Position", "value": widget.OfficerPositionAndName},
      {"label": "Donor Details", "value": widget.donor_details},
      {"label": "Condition", "value": widget.Condition},
      {"label": "Tree Count", "value": widget.treeCount},
      {"label": "Expected Income", "value": "Rs. ${widget.Income}"},
      {"label": "Expected Expenditure", "value": "Rs. ${widget.Outcome}"},
      {"label": "Expected Profit", "value": "Rs. ${widget.Profit}"},
    ];

    //Money value for RM AGM and DGM

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int total =
              (int.tryParse(widget.Income) ?? 0) +
              (int.tryParse(widget.Outcome) ?? 0);

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
                content: const Text(
                  'This sent job will be approved and recorded under ARM Received.',
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
                      final database = FirebaseDatabase.instance.ref();

                      // Write to ARM_branch_data_saved_test
                      await database
                          .child('ARM_branch_data_saved')
                          .child(widget.ARM_Office)
                          .child("Recived")
                          .child(widget.SerialNum)
                          .set({"from": "RM_Approved"});

                      // Copy allTrees if present
                      DatabaseEvent event = await dbref.once();
                      if (event.snapshot.value != null) {
                        await database
                            .child('ARM_branch_data_saved')
                            .child(widget.ARM_Office)
                            .child("Recived")
                            .child(widget.SerialNum)
                            .child("allTrees")
                            .set(event.snapshot.value);
                      }

                      // Set info under ARM_branch_data_saved_test
                      await database
                          .child('ARM_branch_data_saved')
                          .child(widget.ARM_Office)
                          .child("Recived")
                          .child(widget.SerialNum)
                          .child("timberReportheadlines")
                          .set({
                            "Status": "ADGM Approved",
                            "ADGM_ID": widget.AGM_ID,
                            "serialnum": widget.SerialNum,
                            "placeofcoupe": widget.poc,
                            "dateinformed_from_rm": widget.DateInformed,
                            "donor_details": widget.donor_details,
                            "PlaceOfCoupe_exact_from_arm":
                                widget.PlaceOfCoupe_exact_from_arm,
                            "LetterNo": widget.LetterNo,
                            "Condition": widget.Condition,
                            "RM Office": widget.office_location,
                            "OfficerName": widget.OfficerName,
                            "OfficerPosition&name":
                                widget.OfficerPositionAndName,
                            "TreeCount": widget.treeCount.toString(),
                            "Date": widget.DateInformed,
                            "ARM_location": widget.ARM_Office,
                            "CO_name": widget.CO_name,
                            "CO_id": widget.CO_id,
                            "ARM_Id": widget.ARM_Id,
                            "RM_Id": widget.user_name,
                            "income": widget.Income,
                            "outcome": widget.Outcome,
                            "latest_update": DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()).toString(),
                          });

                      // Also mirror to RM_branch_data_saved_test
                      await database
                          .child('RM_branch_data_saved')
                          .child(widget.office_location)
                          .child("Sent")
                          .child(widget.SerialNum)
                          .set({"from": "RM_Approved"});

                      if (event.snapshot.value != null) {
                        await database
                            .child('RM_branch_data_saved')
                            .child(widget.office_location)
                            .child("Sent")
                            .child(widget.SerialNum)
                            .child("allTrees")
                            .set(event.snapshot.value);
                      }

                      await database
                          .child('RM_branch_data_saved')
                          .child(widget.office_location)
                          .child("Sent")
                          .child(widget.SerialNum)
                          .child("info")
                          .set({
                            "Status": "ADGM Approved",
                            "ADGM_ID": widget.AGM_ID,
                            "serialnum": widget.SerialNum,
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
                            "ARM_location": widget.ARM_Office,
                            "CO_name": widget.CO_name,
                            "CO_id": widget.CO_id,
                            "ARM_Id": widget.ARM_Id,
                            "RM_Id": widget.user_name,
                            "income": widget.Income,
                            "outcome": widget.Outcome,
                            "latest_update": DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()).toString(),
                          })
                          // Update status_of_job_test
                          // await FirebaseDatabase.instance
                          //     .ref()
                          //     .child("Status_of_job")
                          //     .child(widget.office_location.toString())
                          //     .child(widget.SerialNum.toString())
                          //     .child("Status")
                          //     .set("approved");
                          // await FirebaseDatabase.instance
                          //     .ref()
                          //     .child("Status_of_job")
                          //     .child(widget.office_location.toString())
                          //     .child(widget.SerialNum.toString())
                          //     .child("approved")
                          //     .set(
                          //       DateFormat(
                          //         'yyyy-MM-dd',
                          //       ).format(DateTime.now()).toString(),
                          //     )
                          .then((_) {
                            try {
                              FirebaseDatabase.instance
                                  .ref()
                                  .child("RM_branch_data_saved")
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
                                  .child("ARM_branch_data_saved")
                                  .child(widget.ARM_Office.toString())
                                  .child("Sent")
                                  .child(widget.SerialNum.toString())
                                  .remove();
                              print('Data deleted successfully');
                              showTopSnackBar(
                                context,
                                message: "Data sent to ARM successfully",
                                backgroundColor: Colors.green,
                              );
                            } catch (e) {
                              print('Error deleting data: $e');
                              showTopSnackBar(
                                context,
                                message: "Error deleting data: $e",
                                backgroundColor: Colors.red,
                              );
                            }
                          });

                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.redAccent,
        label: const Text(
          "Approve",
          style: TextStyle(
            fontFamily: 'sfproRoundSemiB',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Iconsax.tick_circle, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              const Padding(
                padding: EdgeInsets.only(left: 10.0, top: 8.0),
                child: Text(
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
    );
  }
}
