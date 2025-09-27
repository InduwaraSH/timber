import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class page extends StatelessWidget {
  const page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [Text("data", style: TextStyle(color: Colors.black))],
        ),
      ),
    );
  }
}
