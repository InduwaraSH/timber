import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';

class ArmSentTimeline_sent extends StatefulWidget {
  final String branchName;
  final String poc;
  
  final String SerialNum;
  
  const ArmSentTimeline_sent({
    super.key,
    required this.branchName,
    required this.poc,
    
    required this.SerialNum, 
    
  });

  @override
  State<ArmSentTimeline_sent> createState() => _ArmSentTimeline_sentState();
}

class _ArmSentTimeline_sentState extends State<ArmSentTimeline_sent> {
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
        .child(widget.branchName.toString())
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
    return data[step] != null ? data[step] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Info",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "sfproRoundSemiB",
                          ),
                        ),

                       
                        //     Container(
                        //       child: Row(
                        //         children: [
                        //           Icon(
                        //             Iconsax.information,
                        //             color: Colors.black,
                        //             size: 40,
                        //           ),
                        //           SizedBox(width: 8),
                        //           Text(
                        //             "Info Panel",
                        //             style: TextStyle(
                        //               fontSize: 40,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.black,
                        //               fontFamily: "sfproRoundSemiB",
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     SizedBox(width: Size.fromWidth(60).width),
                        //     CupertinoButton(
                        //       onPressed: () {},
                        //       child: Icon(
                        //         Iconsax.share,
                        //         color: Colors.black,
                        //         size: 39,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                        color: const Color.fromARGB(36, 107, 238, 111),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.location5,
                                size: 30,
                                color: Colors.green,
                              ),
                              SizedBox(width: 10),
                              Text(
                                locationName,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontFamily: 'sfproRoundSemiB',
                                ),
                              ),
                            ],
                          ),

                          // Text(
                          //   'Location: $locationName',
                          //   style: TextStyle(
                          //     fontSize: 26,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.green,
                          //     fontFamily: 'sfproRoundSemiB',
                          //   ),
                          // ),
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

                    // ✅ Steps List with Dates (scrolls with page)
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // parent scroll only
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        String step = steps[index];
                        String date = getStepDate(step);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 2.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.15),
                              //     blurRadius: 6,
                              //     offset: const Offset(0, 3),
                              //   ),
                              // ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.tick_circle,
                                      size: 25,
                                      color: getStepColor(step) == Colors.green
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      step_show_only[index],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            getStepColor(step) == Colors.green
                                            ? Colors.black
                                            : Colors.grey,
                                        fontFamily: 'sfproRoundSemiB',
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  date.isNotEmpty ? date : "Pending",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: date.isNotEmpty
                                        ? Colors.green
                                        : Colors.grey,
                                    fontFamily: 'sfproRoundSemiB',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
