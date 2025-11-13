import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TreeCutStatus extends StatefulWidget {
  final String office;
  final String rm;
  final String serial;

  const TreeCutStatus({
    super.key,
    required this.office,
    required this.rm,
    required this.serial,
  });

  @override
  State<TreeCutStatus> createState() => _TreeCutStatusState();
}

class _TreeCutStatusState extends State<TreeCutStatus> {
  final database = FirebaseDatabase.instance.ref();
  bool _isLoading = false;
  bool _isUpdated = false;

  Future<void> _updateStatus() async {
    setState(() => _isLoading = true);

    try {
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

      setState(() {
        _isUpdated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating status: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _isUpdated
            ? _buildSuccessCard(context)
            : _buildActionCard(context),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.forest_rounded, size: 64, color: Colors.black),
          const SizedBox(height: 20),
          const Text(
            "Update Tree Cut Status",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "sfproRoundSemiB",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 0),
          const Text(
            "Tap below to update the procurement status.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontFamily: "sfproRoundRegular",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _updateStatus,
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Account verified",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Welcome to clandestine",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
