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
import 'package:timber_app/RM/RM_RecivedTimeline.dart';
import 'package:timber_app/Snack_Message.dart';

class Arm_Recived_RejectedView extends StatefulWidget {
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

  final String reasonforreject;
  final String ADGM_Type;
  final String RM_office;
  final String updatedIncome;
  final String updatedOutcome;

  const Arm_Recived_RejectedView({
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
    required this.reasonforreject,
    required this.ADGM_Type,
    required this.RM_office,
    required this.updatedIncome,
    required this.updatedOutcome,
  });

  @override
  State<Arm_Recived_RejectedView> createState() =>
      _aRmRecivedView_ADGMState_Rejected();
}

class _aRmRecivedView_ADGMState_Rejected
    extends State<Arm_Recived_RejectedView> {
  late DatabaseReference dbref;

  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String ADGM_Name = "";
  String Reject_story = "";

  // Mutable variables for editable fields
  late String _currentIncome;
  late String _currentOutcome;
  late String _currentProfit;

  // NEW VARIABLES FOR RAW VALUES
  late String _newRawIncome;
  late String _newRawOutcome;

  // STORE PENDING TREE EDITS LOCALLY: { "treeKey": { "dbField": "newValue" } }
  final Map<String, Map<String, String>> _pendingTreeEdits = {};

  @override
  void initState() {
    super.initState();
    // Initialize mutable variables with widget data
    _currentIncome = widget.Income;
    _currentOutcome = widget.Outcome;
    _currentProfit = widget.Profit;

    // Initialize with existing values so they are not empty if not edited
    _newRawIncome = widget.updatedIncome;
    _newRawOutcome = widget.updatedOutcome;

    dbref = FirebaseDatabase.instance
        .ref()
        .child('ARM_branch_data_saved')
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

  // ----------------- EDIT DIALOG LOGIC -----------------
  // ----------------- UPDATED MODERN EDIT DIALOG -----------------
  Future<void> _showEditDialog(
    String label,
    String oldValue,
    Function(String combinedValue, String rawValue) onSave,
  ) async {
    TextEditingController controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.edit,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          "Update $label",
                          style: const TextStyle(
                            fontFamily: 'sfproRoundSemiB',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Current Value Display ---
                  Text(
                    "CURRENT VALUE",
                    style: TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      oldValue,
                      style: const TextStyle(
                        fontFamily: 'sfproRoundRegular',
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- New Value Input ---
                  Text(
                    "NEW VALUE",
                    style: TextStyle(
                      fontFamily: 'sfproRoundSemiB',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                        fontFamily: 'sfproRoundSemiB',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter new value...",
                        hintStyle: TextStyle(
                          fontFamily: 'sfproRoundRegular',
                          fontSize: 15,
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Buttons ---
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: 'sfproRoundSemiB',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              String combinedValue =
                                  "${controller.text} \n${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString()} \n \n $oldValue  \n  ";
                              String rawValue = controller.text;
                              onSave(combinedValue, rawValue);
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: Colors.black.withOpacity(0.3),
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontFamily: 'sfproRoundSemiB',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  Widget _summaryItem(
    String label,
    String value,
    int index, {
    VoidCallback? onEdit,
  }) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
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
                      if (onEdit != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Iconsax.edit_24,
                              size: 16,
                              color: Color.fromRGBO(0, 145, 255, 1),
                            ),
                          ),
                        ),
                      ],
                    ],
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
    String treeKey = data['key'];

    // 1. Check if there are local edits for this tree and apply them to the display data
    if (_pendingTreeEdits.containsKey(treeKey)) {
      _pendingTreeEdits[treeKey]!.forEach((key, value) {
        // Apply local edit to the data map for rendering
        data[key] = value;
      });
    }

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

    final dbKeyMap = {
      "Tree Type": "Tree Type",
      "Grade": "Grade",
      "Actual Height": "Actual Height",
      "Com Height": "Commercial Height",
      "G at B Height": "Girth at Breast Height",
      "Volume": "Volume",
      "Value": "Value",
      "Other": "Other",
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
          ...fields.entries.map((e) {
            return _summaryItem(
              e.key,
              e.value,
              index,
              onEdit: () {
                _showEditDialog(e.key, e.value, (combinedValue, rawValue) {
                  String dbFieldKey = dbKeyMap[e.key]!;

                  // 2. SAVE TO LOCAL STATE ONLY (Do not update DB yet)
                  setState(() {
                    if (!_pendingTreeEdits.containsKey(treeKey)) {
                      _pendingTreeEdits[treeKey] = {};
                    }
                    _pendingTreeEdits[treeKey]![dbFieldKey] = combinedValue;
                  });

                  // Show feedback
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  // ----------------- PDF GENERATION -----------------
  Future<void> _generatePdf() async {
    try {
      DatabaseEvent event = await dbref.once();
      List<Map<String, dynamic>> allTrees = [];

      // Logic to parse snapshot into list
      dynamic snapshotVal = event.snapshot.value;
      if (snapshotVal != null) {
        if (snapshotVal is Map) {
          Map<dynamic, dynamic> treesData = snapshotVal;
          treesData.forEach((key, value) {
            Map<String, dynamic> tree = Map<String, dynamic>.from(value);
            // Apply pending edits for PDF if any
            if (_pendingTreeEdits.containsKey(key)) {
              _pendingTreeEdits[key]!.forEach((k, v) => tree[k] = v);
            }
            allTrees.add(tree);
          });
        } else if (snapshotVal is List) {
          List<dynamic> treesData = snapshotVal;
          for (int i = 0; i < treesData.length; i++) {
            var item = treesData[i];
            if (item != null) {
              Map<String, dynamic> tree = Map<String, dynamic>.from(item);
              // List keys are usually indices as strings "0", "1" etc in pending edits if referenced that way
              // Note: FirebaseAnimatedList usually provides keys.
              // For simplicity in PDF, we rely on fetched data + edits if keys match.
              // (Complex list key matching omitted for brevity, assuming standard map keys)
              allTrees.add(tree);
            }
          }
        }
      }

      final pdf = pw.Document();

      final infoItems = [
        {"label": "Status", "value": widget.Status},
        {"label": "Rejected By", "value": widget.AGM_ID},
        {"label": "Rejected Reason", "value": widget.reasonforreject},
        {"label": widget.ADGM_Type, "value": widget.AGM_ID},
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
        {"label": "Expected Income", "value": "Rs. $_currentIncome"},
        {"label": "Expected Expenditure", "value": "Rs. $_currentOutcome"},
        {"label": "Expected Profit", "value": "Rs. $_currentProfit"},
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return CupertinoAlertDialog(
                title: const Text(
                  'Re Submittion Alert',
                  style: TextStyle(
                    fontFamily: 'sfproRoundSemiB',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(30, 110, 244, 1),
                    fontSize: 20,
                  ),
                ),
                content: const Text(
                  'Once you press Confirm, your edited document will be sent to the RM.',
                  style: TextStyle(
                    fontFamily: 'sfproRoundRegular',
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
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
                        color: Color.fromRGBO(52, 199, 89, 1),
                      ),
                    ),
                    onPressed: () async {
                      // 1. Calculate Profit
                      String calculatedProfit =
                          ((double.tryParse(_newRawIncome) ?? 0) -
                                  (double.tryParse(_newRawOutcome) ?? 0))
                              .toStringAsFixed(2);

                      Reject_story =
                          "$Reject_story \n [${widget.reasonforreject} rejected by ${widget.ADGM_Type}(${widget.AGM_ID}) and resubmitted by: ARM (${widget.ARM_Id}) on ${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()} ]";
                      final database = FirebaseDatabase.instance.ref();

                      // 2. PREPARE MODIFIED TREES
                      // Fetch current data from DB
                      DatabaseEvent event = await dbref.once();
                      Map<dynamic, dynamic> finalTreesData = {};

                      if (event.snapshot.value != null) {
                        dynamic snapshotVal = event.snapshot.value;
                        if (snapshotVal is List) {
                          // Handle list by converting to map with index keys if needed or keeping as list logic
                          // Simple way: convert to Map for consistent editing
                          for (int i = 0; i < snapshotVal.length; i++) {
                            if (snapshotVal[i] != null)
                              finalTreesData[i.toString()] = snapshotVal[i];
                          }
                        } else {
                          finalTreesData = Map.from(snapshotVal as Map);
                        }

                        // Apply pending edits
                        _pendingTreeEdits.forEach((treeKey, edits) {
                          if (finalTreesData.containsKey(treeKey)) {
                            // Ensure the node is a Map before editing
                            if (finalTreesData[treeKey] is Map) {
                              finalTreesData[treeKey] = Map.from(
                                finalTreesData[treeKey],
                              );
                            } else {
                              // Handle case where it might not be a map (unlikely for tree node)
                              finalTreesData[treeKey] = {};
                            }

                            edits.forEach((field, val) {
                              finalTreesData[treeKey][field] = val;
                            });
                          }
                        });
                      }

                      // 3. WRITE TO DB (ARM -> Sent)
                      await database
                          .child('RM_branch_data_saved')
                          .child(widget.RM_office)
                          .child("Recived")
                          .child(widget.SerialNum)
                          .set({"from": "ARM"});

                      if (finalTreesData.isNotEmpty) {
                        await database
                            .child('RM_branch_data_saved')
                            .child(widget.RM_office)
                            .child("Recived")
                            .child(widget.SerialNum)
                            .child("allTrees")
                            .set(finalTreesData);
                      }

                      // Set info under ARM_branch_data_saved_test
                      await database
                          .child('RM_branch_data_saved')
                          .child(widget.RM_office)
                          .child("Recived")
                          .child(widget.SerialNum)
                          .child("info")
                          .set({
                            "SerialNum": widget.SerialNum,
                            "poc": widget.poc,
                            "DateInformed": widget.DateInformed,
                            "donor_details": widget.donor_details,
                            "PlaceOfCoupe_exact_from_arm":
                                widget.PlaceOfCoupe_exact_from_arm,
                            "LetterNo": widget.LetterNo,
                            "Condition": widget.Condition,
                            "RM Office": widget.office_location,
                            "OfficerName": widget.OfficerName,
                            "OfficerPositionAndName":
                                widget.OfficerPositionAndName,
                            "treeCount": widget.treeCount.toString(),
                            "Date": widget.DateInformed,
                            "ARM_Office": widget.ARM_Office,
                            "CO_name": widget.CO_name,
                            "CO_id": widget.CO_id,
                            "ARM_ID": widget.ARM_Id,
                            "RM_Id": widget.RM_ID,
                            "Income": _currentIncome,
                            "Outcome": _currentOutcome,
                            "updated_income": _newRawIncome,
                            "updated_Outcome": _newRawOutcome,
                            "Profit": calculatedProfit,
                            "Reject_Details": Reject_story,
                            "latest_update": DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()).toString(),
                          });

                      // 4. WRITE TO DB (ARM -> Sent)
                      await database
                          .child('ARM_branch_data_saved')
                          .child(widget.office_location)
                          .child("Sent")
                          .child(widget.SerialNum)
                          .set({"Reciver": "RM"});

                      if (finalTreesData.isNotEmpty) {
                        await database
                            .child('ARM_branch_data_saved')
                            .child(widget.office_location)
                            .child("Sent")
                            .child(widget.SerialNum)
                            .child("allTrees")
                            .set(finalTreesData);
                      }

                      await database
                          .child('ARM_branch_data_saved')
                          .child(widget.office_location)
                          .child("Sent")
                          .child(widget.SerialNum)
                          .child("info")
                          .set({
                            "SerialNum": widget.SerialNum,
                            "poc": widget.poc,
                            "DateInformed": widget.DateInformed,
                            "donor_details": widget.donor_details,
                            "PlaceOfCoupe_exact_from_arm":
                                widget.PlaceOfCoupe_exact_from_arm,
                            "LetterNo": widget.LetterNo,
                            "Condition": widget.Condition,
                            "RM Office": widget.office_location,
                            "OfficerName": widget.OfficerName,
                            "OfficerPositionAndName":
                                widget.OfficerPositionAndName,
                            "treeCount": widget.treeCount.toString(),
                            "Date": widget.DateInformed,
                            "ARM_Office": widget.ARM_Office,
                            "CO_name": widget.CO_name,
                            "CO_id": widget.CO_id,
                            "ARM_ID": widget.ARM_Id,
                            "RM_Id": widget.RM_ID,
                            "Income": _currentIncome,
                            "Outcome": _currentOutcome,
                            "updated_income": _newRawIncome,
                            "updated_Outcome": _newRawOutcome,
                            "Profit": calculatedProfit,
                            "Reject_Details": Reject_story,
                            "latest_update": DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()).toString(),
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
                          })
                          .then((_) {
                            try {
                              FirebaseDatabase.instance
                                  .ref()
                                  .child("ARM_branch_data_saved")
                                  .child(widget.ARM_Office.toString())
                                  .child("Recived")
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

                      // 5. UPDATE SOURCE (Original location: ARM Received)
                      // You requested to update the trees sent to RM,
                      // which implies the source record should also reflect these edits.
                      // if (finalTreesData.isNotEmpty) {
                      //   await dbref.set(finalTreesData);
                      // }

                      Navigator.of(dialogContext).pop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.redAccent,
        icon: const Icon(Iconsax.send_14, color: Colors.white),
        label: const Text(
          "Send TO RM",
          style: TextStyle(
            fontFamily: 'sfproRoundSemiB',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
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
              // Build Info Items Manually to inject Edit Functionality
              _summaryItem("Status", widget.Status, 0),
              _summaryItem("Rejected By", widget.AGM_ID, 1),
              _summaryItem("Rejected Reason", widget.reasonforreject, 2),
              _summaryItem(widget.ADGM_Type, widget.AGM_ID, 3),
              _summaryItem("RM Office", widget.office_location, 4),
              _summaryItem("RM", widget.RM_ID, 5),
              _summaryItem("ARM Office", widget.ARM_Office, 6),
              _summaryItem("ARM ID", widget.ARM_Id, 7),
              _summaryItem("CO", widget.CO_name, 8),
              _summaryItem("CO ID", widget.CO_id, 9),
              _summaryItem("POC", widget.poc, 10),
              _summaryItem("POC Exact", widget.PlaceOfCoupe_exact_from_arm, 11),
              _summaryItem("Date Informed", widget.DateInformed, 12),
              _summaryItem("Letter No", widget.LetterNo, 13),
              _summaryItem("Serial No", widget.SerialNum, 14),
              _summaryItem("Officer Name", widget.OfficerName, 15),
              _summaryItem(
                "Officer Position",
                widget.OfficerPositionAndName,
                16,
              ),
              _summaryItem("Donor Details", widget.donor_details, 17),
              _summaryItem("Condition", widget.Condition, 18),
              _summaryItem("Tree Count", widget.treeCount, 19),

              // Editable Fields
              _summaryItem(
                "Expected Income",
                "Rs. $_currentIncome",
                20,
                onEdit: () {
                  _showEditDialog("Expected Income", _currentIncome, (
                    combinedVal,
                    rawVal,
                  ) {
                    setState(() {
                      _currentIncome = combinedVal;
                      _newRawIncome = rawVal;
                    });
                  });
                },
              ),
              _summaryItem(
                "Expected Expenditure",
                "Rs. $_currentOutcome",
                21,
                onEdit: () {
                  _showEditDialog("Expected Expenditure", _currentOutcome, (
                    combinedVal,
                    rawVal,
                  ) {
                    setState(() {
                      _currentOutcome = combinedVal;
                      _newRawOutcome = rawVal;
                    });
                  });
                },
              ),
              _summaryItem(
                "Expected Profit",
                "Rs. ${((double.tryParse(_newRawIncome) ?? 0) - (double.tryParse(_newRawOutcome) ?? 0)).toStringAsFixed(2)}",
                22,
                // onEdit removed
              ),

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
                  Map data = Map.from(snapshot.value as Map);
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
