import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/Review.dart';

class TreeQuesForm extends StatefulWidget {
  final int treeCount;

  final String LetterNo;
  final String Condition;
  final String OfficerName;
  final String OfficerPosition;
  final String Dateinforemed;
  
  final VoidCallback onDone;
  final String serialnum;
  final String placeofcoupe;
  final String dateinformed_from_rm;
  final String office_location;
final String DonorDetails;
  final String PlaceOfCoupe_exact;

  const TreeQuesForm({
    super.key,
    required this.treeCount,

    required this.LetterNo,
    required this.Condition,
    required this.OfficerName,
    required this.OfficerPosition,
    required this.Dateinforemed,

    required this.onDone,
    required this.serialnum,
    required this.placeofcoupe,
    required this.dateinformed_from_rm,
    required this.office_location,
    required this.PlaceOfCoupe_exact,
    required this.DonorDetails,
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
  late List<Map<String, FocusNode>> _focusNodesPerTree;

  int? _focusedIndex;
  String? _focusedField;

  final Map<String, String> fieldHints = {
    "Tree Type": "Enter the species/type of the tree",
    "Grade": "Enter quality grade (A, B, C, etc.)",
    "Actual Height": "Height in meters measured from base to top",
    "Commercial Height": "Height in meters suitable for timber cutting",
    "Girth at Breast Height": "Circumference at 1.3m from ground (cm)",
    "Volume": "Estimated volume in cubic meters",
    "Value": "Estimated value in currency",
    "Other": "Any additional notes or observations",
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    treeControllers = List.generate(
      widget.treeCount,
      (_) => {for (var f in fields) f: TextEditingController()},
    );

    _focusNodesPerTree = List.generate(widget.treeCount, (tIndex) {
      final map = <String, FocusNode>{};
      for (var f in fields) {
        map[f] = FocusNode();
      }
      return map;
    });

    for (int t = 0; t < widget.treeCount; t++) {
      for (var f in fields) {
        final node = _focusNodesPerTree[t][f]!;
        final treeIndex = t;
        final fieldName = f;
        node.addListener(() {
          if (node.hasFocus) {
            setState(() {
              _focusedIndex = treeIndex;
              _focusedField = fieldName;
            });
          } else {
            if (_focusedIndex == treeIndex && _focusedField == fieldName) {
              setState(() {
                _focusedIndex = null;
                _focusedField = null;
              });
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var map in treeControllers) {
      for (var c in map.values) {
        c.dispose();
      }
    }
    for (var map in _focusNodesPerTree) {
      for (var node in map.values) {
        node.dispose();
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
              style: const TextStyle(
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
          new_sectionNumber: widget.DonorDetails,
          PlaceOfCoupe: widget.PlaceOfCoupe_exact,
          LetterNo: widget.LetterNo,
          Condition: widget.Condition,
          OfficerName: widget.OfficerName,
          OfficerPosition: widget.OfficerPosition,
          Dateinforemed: widget.Dateinforemed,
          location: widget.office_location,
          serialnum: widget.serialnum,
          placeofcoupe: widget.placeofcoupe,
          dateinformed_from_rm: widget.dateinformed_from_rm,
         
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
      "donor_details": widget.DonorDetails,
      "PlaceOfCoupe_exact_from_arm": widget.PlaceOfCoupe_exact,
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
          .child(widget.serialnum)
          .child("tree_details")
          .set(allTrees);

      await database
          .child('trees')
          .child(widget.serialnum)
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
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDFBFF), Color(0xFFEDEBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                    onPressed: _next,
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Iconsax.arrow_right_3,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

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
                        final node = _focusNodesPerTree[index][f]!;
                        final isFocused =
                            (_focusedIndex == index && _focusedField == f);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: isFocused
                                      ? Colors.blue.withOpacity(0.25)
                                      : Colors.grey.withOpacity(0.08),
                                  blurRadius: isFocused ? 18 : 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f, // Title always visible
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'sfproRoundSemiB',
                                    fontWeight: FontWeight.bold,
                                    color: isFocused
                                        ? Colors.blue
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller,
                                  focusNode: node,
                                  autofocus: false,
                                  onTap: () {
                                    for (var tMap in _focusNodesPerTree) {
                                      for (var n in tMap.values) {
                                        if (n != node) n.unfocus();
                                      }
                                    }
                                    FocusScope.of(context).requestFocus(node);
                                    setState(() {
                                      _focusedIndex = index;
                                      _focusedField = f;
                                    });
                                  },
                                  showCursor: true,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'sfproRoundSemiB',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: fieldHints[f], // Hint inside
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontFamily: 'sfproRoundSemiB',
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              Row(
                children: [
                  if (currentIndex > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 2),
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
            ],
          ),
        ),
      ),
    );
  }
}
