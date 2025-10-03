import 'dart:math';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/ARM/ARM_SendTO_CO.dart';

class Find_CO_for_ARM extends StatefulWidget {
  final String poc;
  final String DateInformed;
  final String LetterNo;
  final String SerialNum;
  final String office_location;

  const Find_CO_for_ARM({
    super.key,
    required this.poc,
    required this.DateInformed,
    required this.LetterNo,
    required this.SerialNum,
    required this.office_location,
  });

  @override
  State<Find_CO_for_ARM> createState() => _Find_CO_for_ARMState();
}

class _Find_CO_for_ARMState extends State<Find_CO_for_ARM>
    with SingleTickerProviderStateMixin {
  late DatabaseReference dbRef;

  late AnimationController _controller;
  List<Map<dynamic, dynamic>> contactList = [];

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance
        .ref()
        .child("Connection ARM_CO")
        .child(widget.office_location);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildUser(
    Map<dynamic, dynamic> user,
    double radius,
    double angle,
    double size,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double dx = cos(angle + _controller.value * 2 * pi) * radius;
        final double dy = sin(angle + _controller.value * 2 * pi) * radius;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ARM_SentTO_CO(
                    poc: widget.poc.toString(),
                    DateInformed: widget.DateInformed.toString(),
                    LetterNo: widget.LetterNo.toString(),
                    SerialNum: widget.SerialNum.toString(),
                    CO_Name: user["CO_Name"].toString(),
                    CO_ID: user["CO_ID"].toString(),
                    office_location: widget.office_location.toString(),
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: size,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user["avatarUrl"] != null
                      ? NetworkImage(user["avatarUrl"])
                      : null,
                  child: user["avatarUrl"] == null
                      ? AvatarPlus(user["CO_Name"], height: 100, width: 100)
                      : null,
                ),
                const SizedBox(height: 6),
                Text(
                  user["CO_Name"] ?? "a",
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "sfproRoundSemiB",
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = min(screenSize.width, screenSize.height) / 2 - 63;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No Contacts Found"));
          }

          Map<dynamic, dynamic> map =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          contactList = [];
          map.forEach((key, value) {
            contactList.add(value);
          });

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Find One",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sfproRoundSemiB',
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 16.0),
                  child: Text(
                    "Search and connect with the most relevant CO to move your project forward efficiently. Find, select, and collaborate easily.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "sfproRoundRegular",
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // rotating dotted orbits
                          CustomPaint(
                            size: Size(maxRadius * 4, maxRadius * 4),
                            painter: DottedCirclePainter(_controller.value),
                          ),

                          //  center icon
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue,
                                  blurRadius: 78,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                            ),
                            child: Icon(
                              Iconsax.send_24,
                              color: Colors.black87,
                              size: 38,
                            ),
                          ),

                          // 👤 user avatars
                          ...List.generate(contactList.length, (i) {
                            final angle = (2 * pi / contactList.length) * i;
                            final radius = i.isEven
                                ? maxRadius * 1.25
                                : maxRadius * 0.75;
                            final size = i.isEven ? 28.0 : 38.0;

                            return _buildUser(
                              contactList[i],
                              radius,
                              angle,
                              size,
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🎨 Custom painter for rotating dotted circles
class DottedCirclePainter extends CustomPainter {
  final double rotation; // value from 0 to 1

  DottedCirclePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final Paint paint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double radiusOuter = size.width / 2.3;
    final double radiusInner = size.width / 3.7;

    // Rotate the canvas
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(2 * pi * rotation); // rotation animation
    canvas.translate(-center.dx, -center.dy);

    _drawDottedCircle(canvas, center, radiusOuter, paint);
    _drawDottedCircle(canvas, center, radiusInner, paint);

    canvas.restore();
  }

  void _drawDottedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    const double dashLength = 8;
    const double gapLength = 9;
    double circumference = 2 * pi * radius;
    int dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashLength + gapLength)) / radius;
      final double sweepAngle = dashLength / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DottedCirclePainter oldDelegate) => true;
}
