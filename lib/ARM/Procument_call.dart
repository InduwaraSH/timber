import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

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
  final TextEditingController _countController = TextEditingController();
  final List<TextEditingController> _idControllers = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _valueControllers = [];
  final List<TextEditingController> _mobileControllers = [];

  int holderCount = 0;
  final PageController _pageController = PageController();
  bool showCards = false;

  final databaseRef = FirebaseDatabase.instance.ref();

  void _generateFields() {
    setState(() {
      holderCount = int.tryParse(_countController.text.trim()) ?? 0;
      _idControllers.clear();
      _nameControllers.clear();
      _valueControllers.clear();
      _mobileControllers.clear();

      for (int i = 0; i < holderCount; i++) {
        _idControllers.add(TextEditingController());
        _nameControllers.add(TextEditingController());
        _valueControllers.add(TextEditingController());
        _mobileControllers.add(TextEditingController());
      }

      showCards = holderCount > 0;
    });
  }

  Future<void> _saveData() async {
    final branch = widget.ARM_Branch_Name;
    final serial = widget.SerialNum;
    final office = widget.ARM_Branch_Name;
    final RM = widget.RM_office;

    final database = FirebaseDatabase.instance.ref();
    DatabaseReference ref = database.child('procurement/$branch/$serial');

    for (int i = 0; i < holderCount; i++) {
      String optionKey = 'option${i + 1}';
      await ref.child(optionKey).set({
        'procurement_id': _idControllers[i].text.trim(),
        'procurementer_name': _nameControllers[i].text.trim(),
        'procurement_value': _valueControllers[i].text.trim(),
        'procurement_mobile': _mobileControllers[i].text.trim(),
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

    await FirebaseDatabase.instance
        .ref()
        .child("Status_of_job")
        .child(widget.office_location)
        .child(widget.SerialNum)
        .child("Status")
        .set("procurement");

    await FirebaseDatabase.instance
        .ref()
        .child("Status_of_job")
        .child(widget.office_location)
        .child(widget.SerialNum)
        .child("procurement")
        .set(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Procurement data saved successfully ✅"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _launchDialer(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot launch dialer')),
      );
    }
  }

  @override
  void dispose() {
    _countController.dispose();
    for (var c in _idControllers) c.dispose();
    for (var c in _nameControllers) c.dispose();
    for (var c in _valueControllers) c.dispose();
    for (var c in _mobileControllers) c.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildProcurementCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.25), Colors.teal.withOpacity(0.15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Procurement Option ${index + 1} / $holderCount",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _idControllers[index],
                    decoration: _inputStyle("Procurement ID"),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameControllers[index],
                    decoration: _inputStyle("Procurementer Name"),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _mobileControllers[index],
                          keyboardType: TextInputType.phone,
                          decoration: _inputStyle("Mobile Number"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () =>
                            _launchDialer(_mobileControllers[index].text.trim()),
                        icon: const Icon(Icons.phone_rounded, color: Colors.teal, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _valueControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle("Procurement Value"),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Swipe → to next option",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F5F2),
      appBar: AppBar(
        title: const Text("Procurement Details"),
        backgroundColor: Colors.teal,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: showCards
            ? Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: holderCount,
                      itemBuilder: (context, index) =>
                          _buildProcurementCard(index),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Enter Number of Procurement Holders",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Number of Options",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _generateFields,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text("Start Adding Details"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: showCards
          ? FloatingActionButton.extended(
              onPressed: _saveData,
              icon: const Icon(Icons.save_rounded),
              label: const Text("Save All"),
              backgroundColor: Colors.teal,
              elevation: 8,
            )
          : null,
    );
  }
}