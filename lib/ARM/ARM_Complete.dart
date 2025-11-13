import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ArmComplete extends StatefulWidget {
  final String office;
  final String rm;
  final String serial;

  const ArmComplete({
    super.key,
    required this.office,
    required this.rm,
    required this.serial,
  });

  @override
  State<ArmComplete> createState() => _ArmCompleteState();
}

class _ArmCompleteState extends State<ArmComplete> {
  final database = FirebaseDatabase.instance.ref();
  bool _isLoading = false;

  // Local text controllers for Income & Expenditure
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenditureController = TextEditingController();

  Future<void> _updateStatus() async {
    final income = _incomeController.text.trim();
    final expenditure = _expenditureController.text.trim();

    if (income.isEmpty || expenditure.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both income and expenditure"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Firebase updates (you’ll handle db linkage later)
      await database
          .child('ARM_branch_data_saved')
          .child(widget.office)
          .child("Recived")
          .child(widget.serial)
          .update({"from": "Removing"});

      await database
          .child("Status_of_job")
          .child(widget.office)
          .child(widget.serial)
          .child("Status")
          .set("tree_removal");

      await database
          .child("Status_of_job")
          .child(widget.office)
          .child(widget.serial)
          .child("tree_removal")
          .set(DateFormat('yyyy-MM-dd').format(DateTime.now()));

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
        "Continue",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}
