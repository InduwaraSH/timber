import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';

class ReviewFromFirebasePage extends StatefulWidget {
  const ReviewFromFirebasePage({super.key});

  @override
  State<ReviewFromFirebasePage> createState() => _ReviewFromFirebasePageState();
}

class _ReviewFromFirebasePageState extends State<ReviewFromFirebasePage> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("trees");

  Map<dynamic, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        setState(() {
          data = snapshot.value as Map<dynamic, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          data = {};
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _summaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'sfproRoundSemiB',
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'sfproRoundSemiB',
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeCard(Map<dynamic, dynamic> treeData, int index) {
    final details = treeData['tree_details'] as Map<dynamic, dynamic>? ?? {};
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9FBFF), Color(0xFFEFF3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tree Set: ${treeData['serialnum'] ?? 'N/A'}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'sfproRoundSemiB',
            ),
          ),
          const SizedBox(height: 14),
          _summaryItem("Officer Name", "${treeData['timberReportheadlines']?['OfficerName'] ?? ''}"),
          _summaryItem("Officer Position", "${treeData['timberReportheadlines']?['OfficerPosition&name'] ?? ''}"),
          _summaryItem("Location", "${treeData['timberReportheadlines']?['ARM_location'] ?? ''}"),
          _summaryItem("Condition", "${treeData['timberReportheadlines']?['Condition'] ?? ''}"),
          _summaryItem("Letter No", "${treeData['timberReportheadlines']?['LetterNo'] ?? ''}"),
          _summaryItem("Date", "${treeData['timberReportheadlines']?['Date'] ?? ''}"),
          const SizedBox(height: 14),
          const Text(
            "Tree Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'sfproRoundSemiB',
            ),
          ),
          const SizedBox(height: 8),
          ...details.entries.map((e) {
            final detail = e.value as Map<dynamic, dynamic>;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: detail.entries.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(Iconsax.tree, color: Colors.blueAccent, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${item.key}: ${item.value}",
                            style: const TextStyle(
                              fontFamily: 'sfproRoundSemiB',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      );
    }

    if (data == null || data!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No data available."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      appBar: AppBar(
        title: const Text(
          "Firebase Review",
          style: TextStyle(
            fontFamily: 'sfproRoundSemiB',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: data!.entries
              .map((entry) => _buildTreeCard(entry.value, entry.key))
              .toList(),
        ),
      ),
    );
  }
}