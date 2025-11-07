import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/CO_Create.dart';
import 'package:timber_app/CO/CO_Timeline.dart';

class CO_Received_View extends StatelessWidget {
  final String branchName;
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String username;
  final String about_me;
  final String RM_office;

  const CO_Received_View({
    super.key,
    required this.branchName,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.username,
    required this.about_me,
    required this.RM_office,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFBFF), Color(0xFFEDEBFF)], // pastel gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: SingleChildScrollView(
              // ✅ scrollable
              physics: const BouncingScrollPhysics(), // iOS feel
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sfproRoundSemiB",
                          color: Colors.black87,
                          letterSpacing: -1,
                        ),
                      ),
                      Row(
                        children: [
                          FloatingActionButton(
                            heroTag: "info_panel",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CO_timeline(
                                    branchName: branchName,

                                    SerialNum: SerialNum,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: Colors.black,
                            child: Icon(
                              Iconsax.chart_15,
                              color: Colors.lightGreen,
                              size: 35,
                            ),
                          ),
                          const SizedBox(width: 16),

                          FloatingActionButton(
                            heroTag: "find_co",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormCO(
                                    poc: poc,
                                    DateInformed: DateInformed,
                                    LetterNo: LetterNo,
                                    SerialNum: SerialNum,
                                    username: username,
                                    about_me: about_me,
                                    branch_name: branchName,
                                    RM_office: RM_office,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: Colors.black,
                            child: Icon(
                              Iconsax.attach_circle4,
                              color: Colors.white,
                              size: 39,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(Icons.double_arrow, size: 20, color: Colors.grey),
                      Text(
                        "From: $branchName",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "sfproRoundSemiB",

                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Bigger, softer info cards
                  _buildInfoCard(
                    "Date Informed",
                    DateInformed,
                    CupertinoIcons.calendar,
                  ),
                  _buildInfoCard(
                    "Letter No",
                    LetterNo,
                    CupertinoIcons.doc_text_fill,
                  ),
                  _buildInfoCard(
                    "Serial Number",
                    SerialNum,
                    CupertinoIcons.number_square_fill,
                  ),

                  _buildInfoCard("Place of Coupe", poc, Iconsax.location5),

                  const SizedBox(height: 40),

                  // Floating elegant Send button
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: "sfproRoundRegular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: "sfproRoundSemiB",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
