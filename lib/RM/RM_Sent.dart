import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/PositionPicker.dart';

class RmSent extends StatefulWidget {
  const RmSent({super.key});

  @override
  State<RmSent> createState() => _RmSentState();
}

class _RmSentState extends State<RmSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: CupertinoButton(
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Iconsax.edit_25,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Positionpicker(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
