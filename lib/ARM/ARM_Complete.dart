import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:timber_app/Snack_Message.dart';

class ArmComplete extends StatefulWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String OfficerName;
  final String SerialNum;
  final String OfficerPositionAndName;
  final String donor_details;
  final String Condition;
  final String treeCount;
  final String PlaceOfCoupe_exact_from_arm;
  final String user_name;
  final String office_location;
  final String ARM_Branch_Name;
  final String ARM_Office;
  final String Income;
  final String Outcome;
  final String Profit;
  final String ADGM_ID;
  final String RM_office;
  final String Status;
  final String CO_id;
  final String CO_name;
  final String ARM_ID;
  final String RM_ID;
  final String reject_details;

  const ArmComplete({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.OfficerName,
    required this.SerialNum,
    required this.OfficerPositionAndName,
    required this.donor_details,
    required this.Condition,
    required this.treeCount,
    required this.PlaceOfCoupe_exact_from_arm,
    required this.user_name,
    required this.office_location,
    required this.ARM_Branch_Name,
    required this.ARM_Office,
    required this.Income,
    required this.Outcome,
    required this.Profit,
    required this.ADGM_ID,
    required this.RM_office,
    required this.Status,
    required this.CO_id,
    required this.CO_name,
    required this.ARM_ID,
    required this.RM_ID,
    required this.reject_details,
  });

  @override
  State<ArmComplete> createState() => _ArmCompleteState();
}

class _ArmCompleteState extends State<ArmComplete> {
  final database = FirebaseDatabase.instance.ref();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool _isLoading = false;
  late Query dbref;
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;
  String ADGM_Name = "";
  Map<dynamic, dynamic> procurementData = {};
  List<MapEntry<dynamic, dynamic>> _procurementEntries = [];

  Future<void> _fetchProcurementData() async {
    try {
      final snapshot = await _dbRef
          .child('procurement')
          .child(widget.ARM_Branch_Name)
          .child(widget.SerialNum)
          .get();

      if (snapshot.exists && snapshot.value is Map) {
        // convert keys to String (Firebase expects string keys)
        final raw = Map<dynamic, dynamic>.from(snapshot.value as Map);
        final Map<String, dynamic> typed = {};
        raw.forEach((k, v) {
          typed[k.toString()] = v;
        });

        if (mounted) {
          setState(() {
            procurementData = typed;
            _procurementEntries = procurementData.entries.toList();
          });
        }
        debugPrint('Fetched procurementData: ${procurementData.length} items');
      } else {
        if (mounted) {
          setState(() {
            procurementData = {};
            _procurementEntries = [];
          });
        }
        debugPrint('No procurement data found at path.');
      }
    } catch (e, st) {
      debugPrint('Error fetching procurement: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching procurementData: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance
        .ref()
        .child('ARM_branch_data_saved')
        .child(widget.office_location)
        .child("Recived")
        .child(widget.SerialNum)
        .child("allTrees");
    print(" d");

    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     if (_showHeader) setState(() => _showHeader = false);
    //   } else if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     if (!_showHeader) setState(() => _showHeader = true);
    //   }
    // });
  }

  // Local text controllers for Income & Expenditure
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenditureController = TextEditingController();
  Future<void> _test() async {
    DatabaseEvent event = await dbref.once();
    if (event.snapshot.value != null) {
      await database
          .child('test')
          .child(widget.ARM_Office)
          .child("Recived")
          .child(widget.SerialNum)
          .child("allTrees")
          .set(event.snapshot.value);
    }
  }

  Future<void> _updateStatus() async {
    final income = _incomeController.text.trim();
    final expenditure = _expenditureController.text.trim();

    if (income.isEmpty || expenditure.isEmpty) {
      showTopSnackBar(
        context,
        message: "Please enter both income and expenditure values.",
        backgroundColor: Colors.green,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Firebase updates (you’ll handle db linkage later)
      // await database
      //     .child('ARM_branch_data_saved')
      //     .child(widget.ARM_Branch_Name)
      //     .child("Recived")
      //     .child(widget.SerialNum)
      //     .update({"from": "Removing"});

      // await database
      //     .child("Status_of_job")
      //     .child(widget.ARM_Branch_Name)
      //     .child(widget.SerialNum)
      //     .child("Status")
      //     .set("tree_removal");

      // await database
      //     .child("Status_of_job")
      //     .child(widget.ARM_Branch_Name)
      //     .child(widget.SerialNum)
      //     .child("tree_removal")
      //     .set(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      DatabaseEvent event = await dbref.once();
      await _fetchProcurementData();
      if (event.snapshot.value != null) {
        await database
            .child('Completed_jobs')
            .child(widget.RM_office)
            .child(widget.ARM_Branch_Name)
            //.child(DateTime.now().year.toString())
            .child("2026")
            .child(widget.SerialNum)
            .child("allTrees")
            .set(event.snapshot.value);
      }

      if (procurementData.isNotEmpty) {
        await database
            .child('Completed_jobs')
            .child(widget.RM_office)
            .child(widget.ARM_Branch_Name)
            //.child(DateTime.now().year.toString())
            .child("2026")
            .child(widget.SerialNum)
            .child("procument")
            .set(procurementData);
      }

      // Set info under ARM_branch_data_saved_test
      await database
          .child('Completed_jobs')
          .child(widget.RM_office)
          .child(widget.ARM_Branch_Name)
          //.child(DateTime.now().year.toString())
          .child("2026")
          .child(widget.SerialNum)
          .child("timberReportheadlines")
          .set({
            "Status": "ADGM Approved",
            //"ADGM_ID": widget.AGM_ID,
            "serialnum": widget.SerialNum,
            "placeofcoupe": widget.poc,
            "dateinformed_from_rm": widget.DateInformed,
            "donor_details": widget.donor_details,
            "PlaceOfCoupe_exact_from_arm": widget.PlaceOfCoupe_exact_from_arm,
            "LetterNo": widget.LetterNo,
            "Condition": widget.Condition,
            "RM Office": widget.office_location,
            "OfficerName": widget.OfficerName,
            "OfficerPosition&name": widget.OfficerPositionAndName,
            "TreeCount": widget.treeCount.toString(),
            "Date": widget.DateInformed,
            "ARM_location": widget.ARM_Office,
            "CO_name": widget.CO_name,
            "CO_id": widget.CO_id,
            "ARM_Id": widget.user_name,
            "RM_Id": widget.user_name,
            "income": widget.Income,
            "outcome": widget.Outcome,
            "reject_details": widget.reject_details,
            "latest_update": DateFormat(
              'yyyy-MM-dd HH:mm:ss',
            ).format(DateTime.now()).toString(),
          });

      // Small delay for smooth UX
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating status: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expenditureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildInputCard(context),
                const SizedBox(height: 30),
                _buildActionButton(context),
              ],
            ),
          ),

          // Cupertino loader overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(radius: 16, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      "Processing...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Icon(
          Icons.done_outline_rounded,
          color: Color.fromRGBO(52, 199, 89, 1),
          size: 72,
        ),
        SizedBox(height: 12),
        Text(
          "Finalize Job",
          style: TextStyle(
            fontSize: 35,
            fontFamily: "sfproRoundSemiB",
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(52, 199, 89, 1),
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Please enter the income and expenditure details below to complete the job.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: CupertinoColors.systemGreen,
            fontFamily: "sfproRoundRegular",
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _incomeController,
            label: "Income",
            placeholder: "Enter income amount",
            prefixIcon: CupertinoIcons.money_dollar_circle,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _expenditureController,
            label: "Expenditure",
            placeholder: "Enter expenditure amount",
            prefixIcon: CupertinoIcons.creditcard,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontFamily: "sfproRoundSemiB",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          keyboardType: keyboardType,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Icon(prefixIcon, color: CupertinoColors.black),
          ),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(14),
          ),
          style: const TextStyle(
            color: CupertinoColors.black,
            fontFamily: "sfproRoundSemiB",
            fontSize: 15,
          ),
          placeholderStyle: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontFamily: "sfproRoundSemiB",
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return CupertinoButton.filled(
      color: Color.fromRGBO(52, 199, 89, 1),
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      onPressed: _isLoading ? null : _updateStatus,
      child: const Text(
        "Confirm",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}
