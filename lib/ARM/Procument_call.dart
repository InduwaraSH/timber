import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/Snack_Message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax/iconsax.dart';

class ARM_Pro_call extends StatefulWidget {
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

  const ARM_Pro_call({
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
  State<ARM_Pro_call> createState() => _ARM_Pro_callState();
}

class _ARM_Pro_callState extends State<ARM_Pro_call> {
  int currentIndex = 0;
  final TextEditingController _countController = TextEditingController();
  bool showCards = false;
  int holderCount = 0;
  int? selectedOptionIndex;

  late PageController _pageController;

  final List<String> fields = ["Procurement ID", "Name", "Mobile", "Value"];
  late List<Map<String, TextEditingController>> _controllersPerOption;
  late List<Map<String, FocusNode>> _focusNodesPerOption;

  int? _focusedIndex;
  String? _focusedField;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _generateFields() {
    setState(() {
      holderCount = int.tryParse(_countController.text.trim()) ?? 0;

      _controllersPerOption = List.generate(holderCount, (index) {
        return {for (var f in fields) f: TextEditingController()};
      });

      _focusNodesPerOption = List.generate(holderCount, (index) {
        return {for (var f in fields) f: FocusNode()};
      });

      // Focus listeners
      for (int i = 0; i < holderCount; i++) {
        for (var f in fields) {
          _focusNodesPerOption[i][f]!.addListener(() {
            if (_focusNodesPerOption[i][f]!.hasFocus) {
              setState(() {
                _focusedIndex = i;
                _focusedField = f;
              });
            } else if (_focusedIndex == i && _focusedField == f) {
              setState(() {
                _focusedIndex = null;
                _focusedField = null;
              });
            }
          });
        }
      }

      showCards = holderCount > 0;
    });
  }

  void _next() {
    if (currentIndex < holderCount - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveData();
    }
  }

  void _back() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveData() async {
    if (selectedOptionIndex == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //       "Please select a procurement option before saving.",
      //       style: TextStyle(fontFamily: "sfproRoundSemiB"),
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showTopSnackBar(
        context,
        message: "Please select a procurement option before saving.",
        backgroundColor: Colors.red, // optional
      );
      return;
    }

    final i = selectedOptionIndex!;
    final controllers = _controllersPerOption[i];

    // Validate fields
    for (var f in fields) {
      if (controllers[f]!.text.trim().isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("$f is required!"),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        showTopSnackBar(
          context,
          message: "$f is required!",
          backgroundColor: Colors.red, // optional
        );
        return;
      }
    }

    final branch = widget.ARM_Branch_Name;
    final serial = widget.SerialNum;
    final office = widget.ARM_Branch_Name;
    final RM = widget.RM_office;
    final database = FirebaseDatabase.instance.ref();
    DatabaseReference ref = database.child('procurement/$branch/$serial');

    for (int j = 0; j < holderCount; j++) {
      await ref.child('option${j + 1}').set({
        'procurement_id': _controllersPerOption[j]["Procurement ID"]!.text
            .trim(),
        'procurementer_name': _controllersPerOption[j]["Name"]!.text.trim(),
        'procurement_value': _controllersPerOption[j]["Value"]!.text.trim(),
        'procurement_mobile': _controllersPerOption[j]["Mobile"]!.text.trim(),
        'selected': j == selectedOptionIndex,
        'saved_at': DateTime.now().toIso8601String(),
      });
    }

    await database
        .child('ARM_branch_data_saved')
        .child(office)
        .child("Recived")
        .child(serial)
        .update({"from": "Procumented"});
    await database
        .child('RM_branch_data_saved')
        .child(RM)
        .child("Sent")
        .child(serial)
        .update({"from": "Procumented"});
    await database
        .child("Status_of_job")
        .child(widget.office_location)
        .child(serial)
        .child("Status")
        .set("procurement");
    await database
        .child("Status_of_job")
        .child(widget.office_location)
        .child(serial)
        .child("procurement")
        .set(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if (mounted) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Procurement data saved successfully ✅"),
      //     backgroundColor: Colors.black,
      //   ),
      // );
      showTopSnackBar(
        context,
        message: "Procurement data saved successfully!",
        backgroundColor: Colors.green, // optional
      );
      Navigator.pop(context);
    }
  }

  Future<void> _launchDialer(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot launch dialer')));
    }
  }

  Widget _buildOptionPage(int index) {
    final controllers = _controllersPerOption[index];
    final focusNodes = _focusNodesPerOption[index];
    double progress = (index + 1) / holderCount;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Dynamic Island–style top card
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Option ${index + 1} of $holderCount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Fill procurement details below",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: "sfproRoundSemiB",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    Text(
                      "${(progress * 100).round()}%",
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Fields
        ...fields.map((f) {
          final controller = controllers[f]!;
          final node = focusNodes[f]!;
          final isFocused = (_focusedIndex == index && _focusedField == f);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: isFocused
                        ? Colors.black12
                        : Colors.grey.withOpacity(0.08),
                    blurRadius: isFocused ? 18 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFocused ? Colors.black : Colors.black87,
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          focusNode: node,
                          keyboardType: f == "Mobile" || f == "Value"
                              ? TextInputType.number
                              : TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter $f",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: "sfproRoundSemiB",
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _focusedIndex = index;
                              _focusedField = f;
                            });
                          },
                        ),
                      ),
                      if (f == "Mobile")
                        IconButton(
                          onPressed: () =>
                              _launchDialer(controller.text.trim()),
                          icon: const Icon(
                            Iconsax.call5,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),

        // Navigation Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (index > 0)
              FloatingActionButton(
                onPressed: _back,
                mini: true,
                backgroundColor: Colors.black,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            FloatingActionButton(
              onPressed: _next,
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Checkbox to select option
        Row(
          children: [
            Transform.scale(
              scale: 1.8,
              child: CupertinoCheckbox(
                value: selectedOptionIndex == index,
                onChanged: (val) {
                  setState(() {
                    selectedOptionIndex = val! ? index : null;
                  });
                },
                activeColor: Colors.black87,
              ),
            ),
            const Text(
              "Select this option as the chosen procurement",
              style: TextStyle(fontSize: 16, fontFamily: "sfproRoundSemiB"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: showCards
            ? PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: holderCount,
                itemBuilder: (_, index) => _buildOptionPage(index),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Number of\nProcurement Holders",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "sfproRoundSemiB",
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _countController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "sfproRoundSemiB",
                      ),
                      decoration: InputDecoration(
                        hintText: "Number of Options",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontFamily: "sfproRoundSemiB",
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _generateFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "sfproRoundSemiB",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
