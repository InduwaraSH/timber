import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
    "Tree Type",
    "Grade",
    "Actual Height",
    "Commercial Height",
    "Girth at Breast Height",
    "Volume",
    "Value",
    "Other",
  ];

  late List<Map<String, TextEditingController>> treeControllers;
  String? _focusedField;

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
            content: Text(
              'Please fill "$f"',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "sfproRoundRegular",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.redAccent.shade400,
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
          content: Text(
            "Saved successfully!",
            style: TextStyle(
              fontFamily: "sfproRoundRegular",
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Save failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / widget.treeCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 🌊 Floating Dynamic Island Header (Blue Gradient + Circular Progress)
            // 🌊 Floating Dynamic Island Header (Blue Gradient + Circular Progress)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(
                      left: 16,
                      top: 5,
                      bottom: 18,
                      right: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tree ${currentIndex + 1} of ${widget.treeCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sfproRoundSemiB',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Fill tree information below",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: 'sfproRoundSemiB',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 46,
                              width: 46,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 5,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(48, 209, 88, 1),
                                ),
                              ),
                            ),
                            Text(
                              "${(progress * 100).round()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'sfproRoundSemiB',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _next();
                  },
                  backgroundColor: Colors.black,
                  mini: false,
                  child: const Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),

            // 🌫️ Form Section
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.treeCount,
                itemBuilder: (_, index) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: fields.map((f) {
                      final controller = treeControllers[index][f]!;
                      final isFocused = _focusedField == f;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: isFocused
                                  ? [
                                      const Color(0xFFF9FBFF),
                                      const Color(0xFFEFF3FF),
                                    ]
                                  : [
                                      const Color(0xFFF9FBFF),
                                      const Color(0xFFEFF3FF),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isFocused
                                    ? Colors.black.withOpacity(0.25)
                                    : Colors.grey.withOpacity(0.08),
                                blurRadius: isFocused ? 18 : 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller,
                            onTap: () => setState(() => _focusedField = f),
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'sfproRoundSemiB',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1C1E),
                            ),
                            decoration: InputDecoration(
                              labelText: f,
                              labelStyle: TextStyle(
                                color: isFocused ? Colors.grey : Colors.black54,
                                fontFamily: 'sfproRoundSemiB',
                                fontWeight: isFocused
                                    ? FontWeight.bold
                                    : FontWeight.normal,

                                fontSize: isFocused ? 25 : 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            // 🔘 Bottom Buttons
            Row(
              children: [
                if (currentIndex > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 24),
                    child: FloatingActionButton(
                      onPressed: _back,
                      backgroundColor: Colors.black,
                      mini: true,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16, bottom: 24, top: 8),
            //   child: Row(
            //     children: [
            //       if (currentIndex > 0)
            //         ElevatedButton.icon(
            //           onPressed: _back,
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.black,

            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 10,
            //               vertical: 10,
            //             ),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(14),
            //             ),
            //           ),
            //           icon: const Icon(
            //             Icons.arrow_back_ios_new,
            //             color: Colors.white,
            //             size: 18,
            //           ),
            //           label: const Text(""),
            //         ),
            //       const Spacer(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
