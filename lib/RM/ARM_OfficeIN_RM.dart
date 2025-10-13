import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:timber_app/RM/createFor.dart';

class ARM_OfficeIN_RM extends StatefulWidget {
  final String office_location;
  const ARM_OfficeIN_RM({super.key, required this.office_location});

  @override
  State<ARM_OfficeIN_RM> createState() => _ARM_OfficeIN_RMState();
}

class _ARM_OfficeIN_RMState extends State<ARM_OfficeIN_RM> {
  int _selectedTown = 0;

  static const double _kItemExtent = 32.0;
  List<String> _townName = [];
  String get location => widget.office_location.toString();

  @override
  void initState() {
    super.initState();
    fetchTownNames(location); // ✅ call fetch on init
  }

  void fetchTownNames(String location) async {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child("Connection RM_ARM")
        .child(location);

    DataSnapshot snapshot = await dbRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      _townName = data.keys.map((key) => key.toString()).toList();
      setState(() {});
    } else {
      _townName = ["No data"];
      setState(() {});
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70),
              Center(
                child: Text(
                  "Find a ARM ",
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFF756AB6),
                    fontWeight: FontWeight.bold,
                    fontFamily: "sfproRoundSemiB",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                child: Text(
                  "Before registering, we need to know who you are. Please select your role from the dropdown list: RM, ARM, or CO. This step is important because it helps us identify your position and verify your information. After you submit your registration, we will carefully check the details you provided with your original data. If everything matches correctly, your account will be successfully registered and approved to use this platform securely.",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "sfproRoundRegular",
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDAD6FF).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    height: 70,
                    width: size.width - 150,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: CupertinoColors.label.resolveFrom(context),
                        fontSize: 22.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _townName.isEmpty
                                    ? null
                                    : () => _showDialog(
                                        CupertinoPicker(
                                          magnification: 1.32,
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          itemExtent: _kItemExtent,
                                          selectionOverlay:
                                              CupertinoPickerDefaultSelectionOverlay(
                                                background: Color(
                                                  0xFFDAD6FF,
                                                ).withOpacity(0.7),
                                              ),
                                          scrollController:
                                              FixedExtentScrollController(
                                                initialItem: _selectedTown,
                                              ),
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                                setState(() {
                                                  _selectedTown = selectedItem;
                                                });
                                              },
                                          children: List<Widget>.generate(
                                            _townName.length,
                                            (int index) {
                                              return Center(
                                                child: Text(
                                                  _townName[index],
                                                  style: TextStyle(
                                                    color: Color(0xFF756AB6),
                                                    fontFamily:
                                                        "sfproRoundRegular",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25.0,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    color: const Color.fromARGB(
                                      0,
                                      64,
                                      195,
                                      255,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    child: Text(
                                      _townName.isNotEmpty
                                          ? _townName[_selectedTown]
                                          : "Select Role",
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                        color: Color(0xFF756AB6),
                                        fontFamily: "sfproRoundSemiB",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "RM - Regional Manager",
                style: TextStyle(
                  fontFamily: "sfproRoundRegular",
                  fontSize: 15,
                  color: Color(0xFF756AB6),
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "ARM - Assistant Regional Manager",
                style: TextStyle(
                  fontFamily: "sfproRoundRegular",
                  fontSize: 15,
                  color: Color(0xFF756AB6),
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "CO - Cope Officer",
                style: TextStyle(
                  fontFamily: "sfproRoundRegular",
                  fontSize: 15,
                  color: Color(0xFF756AB6),
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 20,
                    ),
                    child: Container(
                      child: CupertinoButton(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF756AB6),
                          child: Icon(
                            Iconsax.next,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Create_Form_Rm(
                                widget.office_location.toString(),
                                _townName[_selectedTown].toString(),
                              ),
                            ),
                          );
                        },
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
