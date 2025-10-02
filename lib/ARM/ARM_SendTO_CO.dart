import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ARM_SentTO_CO extends StatelessWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String CO_Name;
  final String CO_ID;

  const ARM_SentTO_CO({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.CO_Name,
    required this.CO_ID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                              ClipOval(
                                child: AvatarPlus(
                                  CO_Name,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CO_Name,
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
                  _buildInfoCard(
                    "Place of Coupe",
                    poc,
                    CupertinoIcons.cube_box_fill,
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: CupertinoButton(
                      color: Colors.blue,
                      child: Text(
                        "Send Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "sfproRoundSemiB",
                        ),
                      ),
                      onPressed: () {},
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
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 215, 214, 214),
                  Color.fromARGB(255, 215, 214, 214),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.black, size: 28),
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
