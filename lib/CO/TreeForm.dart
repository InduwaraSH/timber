import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timber_app/CO/Review.dart';


class TreeQuesForm extends StatefulWidget {
  final int treeCount;
  final String sectionNumber;
  final String PlaceOfCoupe;
  final String LetterNo;
  final String Condition;
  final String OfficerName;
  final String OfficerPosition;
  final String Dateinforemed;
  final String position;
  final VoidCallback onDone;
  final String serialnum;
  final String placeofcoupe;
  final String dateinformed_from_rm;
  final String office_location;

  const TreeQuesForm({
    super.key,
    required this.treeCount,
    required this.sectionNumber,
    required this.PlaceOfCoupe,
    required this.LetterNo,
    required this.Condition,
    required this.OfficerName,
    required this.OfficerPosition,
    required this.Dateinforemed,
    required this.position,
    required this.onDone,
    required this.serialnum,
    required this.placeofcoupe,
    required this.dateinformed_from_rm,
    required this.office_location,
  });

  @override
  State<TreeQuesForm> createState() => _TreeQuesFormState();
}

class _TreeQuesFormState extends State<TreeQuesForm> {
  int currentIndex = 0;
  late PageController _pageController;

  final List<String> fields = [
    "ගස් වර්ගය",
    "පංතිය",
    "සත්‍ය උස",
    "වාණීජමය උස",
    "පපු මට්ටමේ වට",
    "පරිමාව",
    "වටිනාකම",
    "වෙනත්",
  ];

  late List<Map<String, TextEditingController>> treeControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    treeControllers = List.generate(
      widget.treeCount,
      (_) => {for (var f in fields) f: TextEditingController()},
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var map in treeControllers) {
      for (var c in map.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _next() {
    final currentFields = treeControllers[currentIndex];
    for (var f in fields) {
      if (currentFields[f]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill "$f"'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    if (currentIndex < widget.treeCount - 1) {
      setState(() => currentIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _review();
    }
  }

  void _back() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _review() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          fields: fields,
          treeControllers: treeControllers,
          treeCount: widget.treeCount.toString(),
          new_sectionNumber: widget.sectionNumber,
          PlaceOfCoupe: widget.PlaceOfCoupe,
          LetterNo: widget.LetterNo,
          Condition: widget.Condition,
          OfficerName: widget.OfficerName,
          OfficerPosition: widget.OfficerPosition,
          Dateinforemed: widget.Dateinforemed,
          location: widget.office_location,
          serialnum: widget.serialnum,
          placeofcoupe: widget.placeofcoupe,
          dateinformed_from_rm: widget.dateinformed_from_rm,
          position: widget.position,
          onEdit: (index) {
            Navigator.pop(context);
            setState(() {
              currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          onConfirm: _save,
        ),
      ),
    );
  }

  void _save() async {
    final database = FirebaseDatabase.instance.ref();
    List<Map<String, String>> allTrees = [];

    for (var tree in treeControllers) {
      Map<String, String> treeData = {};
      for (var field in fields) {
        treeData[field] = tree[field]!.text.trim();
      }
      allTrees.add(treeData);
    }

    Map<String, String> timberReportheadlines = {
      "serialnum": widget.serialnum,
      "placeofcoupe": widget.placeofcoupe,
      "dateinformed_from_rm": widget.dateinformed_from_rm,
      "doner_details": widget.sectionNumber,
      "PlaceOfCoupe_exact_from_arm": widget.PlaceOfCoupe,
      "LetterNo": widget.LetterNo,
      "Condition": widget.Condition,
      "OfficerName": widget.OfficerName,
      "OfficerPosition&name": widget.OfficerPosition,
      "TreeCount": widget.treeCount.toString(),
      "Date": widget.Dateinforemed,
      "ARM_location": widget.office_location,
    };

    try {
      await database
          .child('trees')
          .child(widget.sectionNumber)
          .child("tree_details")
          .set(allTrees);

      await database
          .child('trees')
          .child(widget.sectionNumber)
          .child('timberReportheadlines')
          .set(timberReportheadlines);

      widget.onDone();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved successfully!"),
          duration: Duration(seconds: 1),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context); // close review
      Navigator.pop(context); // close TreeQuesForm
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5C50C5),
        elevation: 0,
        title: const Text("Tree Details", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.treeCount,
              itemBuilder: (_, index) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: fields
                      .map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: treeControllers[index][f],
                              decoration: InputDecoration(
                                labelText: f,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (currentIndex > 0)
                  ElevatedButton.icon(
                    onPressed: _back,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(currentIndex == widget.treeCount - 1 ? "Review" : "Next"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}