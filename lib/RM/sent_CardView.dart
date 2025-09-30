import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SentCardView extends StatefulWidget {
  final String branchName;
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;

  const SentCardView({
    super.key,
    required this.branchName,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
  });

  @override
  State<SentCardView> createState() => _SentCardViewState();
}

class _SentCardViewState extends State<SentCardView> {
  final database = FirebaseDatabase.instance.ref();

  List<String> steps = [
    'RM Received',
    'ARM Received',
    'CO Recived',
    'ARM Recived',
    'RM Recived',
    'Approvel',
    'Procument',
    'Removing tree',
    'Job Done',
  ];

  Map<String, dynamic> data = {};
  String locationName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await database.child('trees/tree1').get();
    if (snapshot.exists) {
      setState(() {
        data = Map<String, dynamic>.from(snapshot.value as Map);
        locationName = data['location'] ?? 'Unknown';
      });
    }
  }

  Color getStepColor(String step) {
    String status = data['status'] ?? '';
    int stepIndex = steps.indexOf(step);
    int statusIndex = steps.indexOf(status);
    return stepIndex <= statusIndex ? Colors.green : Colors.grey;
  }

  String getStepDate(String step) {
    return data['dates'] != null && data['dates'][step] != null
        ? data['dates'][step]
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Letter: ${widget.LetterNo}')),
      backgroundColor: Colors.white,
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Branch: ${widget.branchName}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('POC: ${widget.poc}', style: TextStyle(fontSize: 14)),
                  Text(
                    'Date Informed: ${widget.DateInformed}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Location: $locationName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Progress Boxes
                  SafeArea(
                    left: true,
                    right: true,
                    child: Row(
                      children: steps.map((step) {
                        int index = steps.indexOf(step);
                        bool isCircle = index >= 6; // last 3 steps as circle
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: isCircle
                                ? MediaQuery.of(context).size.width * 0.05
                                : MediaQuery.of(context).size.width * 0.09,
                            height: 18,
                            decoration: BoxDecoration(
                              color: getStepColor(step),
                              shape: isCircle
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                              borderRadius: isCircle
                                  ? null
                                  : BorderRadius.circular(9),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Steps List with Dates
                  Expanded(
                    child: ListView.builder(
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        String step = steps[index];
                        String date = getStepDate(step);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                step,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8C9F80),
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8C9F80),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
