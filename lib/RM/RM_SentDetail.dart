
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RM_SentDetail extends StatefulWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String BranchNName;
  

  const RM_SentDetail({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.BranchNName,
    
  });

  @override
  State<RM_SentDetail> createState() => _ARM_SentDetailState();
}

class _ARM_SentDetailState extends State<RM_SentDetail> {
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Review",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sfproRoundSemiB",
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),

                  // CO Profile Card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sent To :",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.5),
                              fontFamily: "sfproRoundSemiB",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.BranchNName} Branch",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "sfproRoundSemiB",
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),

                  // Info Cards
                  _buildInfoCard(
                    "Date Informed",
                    widget.DateInformed,
                    Iconsax.calendar,
                  ),
                  _buildInfoCard(
                    "Letter No",
                    widget.LetterNo,
                    Iconsax.document,
                  ),
                  _buildInfoCard(
                    "Serial Number",
                    widget.SerialNum,
                    Iconsax.hashtag,
                  ),
                  _buildInfoCard(
                    "Place of Coupe",
                    widget.poc,
                    Iconsax.location,
                  ),

                  const SizedBox(height: 40),

                  const SizedBox(height: 20), // Extra space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Info Card
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 253, 253, 253), Color(0xFFEDEBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            // decoration: BoxDecoration(
            //   gradient: const LinearGradient(
            //     colors: [
            //       Color.fromARGB(255, 215, 214, 214),
            //       Color.fromARGB(255, 215, 214, 214),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //   borderRadius: BorderRadius.circular(16),
            // ),
            child: Icon(icon, color: Colors.grey, size: 40),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontFamily: "sfproRoundRegular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "sfproRoundSemiB",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
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
