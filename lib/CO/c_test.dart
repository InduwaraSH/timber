import 'package:flutter/material.dart';

class test extends StatefulWidget {
  final String office_location;
  

  const test({super.key, required this.office_location});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Office Location: ${widget.office_location}")),
    );
  }
}
