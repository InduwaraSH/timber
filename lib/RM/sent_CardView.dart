import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.LetterNo)));
  }
}
