import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';

class SentCardView extends StatefulWidget {
  final String branchName;
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String office_location;

  const SentCardView({
    super.key,
    required this.branchName,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.office_location,
  });

  @override
  State<SentCardView> createState() => _SentCardViewState();
}

class _SentCardViewState extends State<SentCardView> {
  final database = FirebaseDatabase.instance.ref();

  List<String> steps = [
    'RM_R_D_One',
    'ARM_R_D_One',
    'CO_R_D_One',
    'ARM_R_D_two',
    'RM_R_D_two',
    'approved',
    'procurement',
    'tree_removal',
    'job_completed',
  ];

  List<String> step_show_only = [
    'RM Received',
    'ARM Received',
    'CO Recived',
    'ARMRecived',
    'RM Recived 2nd',
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
    final snapshot = await database
        .child('Status_of_job')
        .child(widget.office_location.toString())
        .child(widget.SerialNum.toString())
        .get();
    if (snapshot.exists) {
      setState(() {
        data = Map<String, dynamic>.from(snapshot.value as Map);
        locationName = data['location'] ?? 'Unknown';
      });
    }
  }

  Color? getStepColor(String step) {
    String status = data['Status'] ?? '';
    int stepIndex = steps.indexOf(step);
    int statusIndex = steps.indexOf(status);
    return stepIndex <= statusIndex ? Colors.green : Colors.grey[300];
  }

  String getStepDate(String step) {
    return data != null && data[step] != null ? data[step] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.information,
                                color: Colors.black,
                                size: 40,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Info Panel",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "sfproRoundSemiB",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Size.fromWidth(60).width),
                        CupertinoButton(
                          onPressed: () {},
                          child: Icon(
                            Iconsax.document_cloud,
                            color: Colors.blue,
                            size: 39,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location: $locationName',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'sfproRoundSemiB',
                            ),
                          ),
                          SizedBox(height: 20),
                          SafeArea(
                            left: true,
                            right: true,
                            child: Row(
                              children: steps.map((step) {
                                int index = steps.indexOf(step);
                                bool isCircle =
                                    index >= 6; // last 3 steps as circle
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Container(
                                    width: isCircle
                                        ? MediaQuery.of(context).size.width *
                                              0.05
                                        : MediaQuery.of(context).size.width *
                                              0.095,
                                    height: 21,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Progress Boxes

                    // Steps List with Dates
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          String step = steps[index];
                          String date = getStepDate(step);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  step_show_only[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontFamily: 'sfproRoundRegular',
                                  ),
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontFamily: 'sfproRoundRegular',
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
      ),
    );
  }
}
