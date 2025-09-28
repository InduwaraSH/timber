import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CoRegister extends StatefulWidget {
  const CoRegister({super.key});

  @override
  State<CoRegister> createState() => _CoRegisterState();
}

class _CoRegisterState extends State<CoRegister> {
  int _selectedTown = 0;

  static const double _kItemExtent = 32.0;
  static const List<String> _townName = <String>['RM', 'ARM', 'CO'];

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
                  "co You are?",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.blue,
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
                      color: Colors.lightBlueAccent.withOpacity(0.3),
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
                                // Display a CupertinoPicker with list of Stands.
                                onPressed: () => _showDialog(
                                  CupertinoPicker(
                                    magnification: 1.32,
                                    squeeze: 1.2,
                                    useMagnifier: true,
                                    itemExtent: _kItemExtent,

                                    // This sets the initial item.
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem: _selectedTown,
                                        ),
                                    // This is called when selected item is changed.
                                    onSelectedItemChanged: (int selectedItem) {
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
                                              color: Colors.black,
                                              fontFamily: "sfproRoundRegular",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // This displays the selected fruit name.
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
                                      _townName[_selectedTown],
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.blue,
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
                  color: Colors.lightBlue[500],
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "ARM - Assistant Regional Manager",
                style: TextStyle(
                  fontFamily: "sfproRoundRegular",
                  fontSize: 15,
                  color: Colors.lightBlue[500],
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "CO - Cope Officer",
                style: TextStyle(
                  fontFamily: "sfproRoundRegular",
                  fontSize: 15,
                  color: Colors.lightBlue[500],
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
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Iconsax.next,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                         
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
