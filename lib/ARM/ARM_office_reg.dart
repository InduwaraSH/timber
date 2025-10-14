import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ArmOfficeRegister extends StatefulWidget {
  const ArmOfficeRegister({super.key});

  @override
  State<ArmOfficeRegister> createState() => _ArmOfficeRegisterState();
}

class _ArmOfficeRegisterState extends State<ArmOfficeRegister> {
  int _selectedTown = 0;
  int _selectedarmOfficeLocation = 0;

  TextEditingController idController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  late DatabaseReference branchReference;
  late DatabaseReference employeeReference;

  static const double _kItemExtent = 32.0;
  static const List<String> _rmOfficeLocation = <String>[
    'Matara',
    'Colombo',
    'Ratnapura',
    'Jaffna',
    'Anuradhapura',
    'Kandy',
  ];

  static const List<String> _armOfficeLocation = <String>[
    "Embilipitya",
    "Matara",
    "Galle",
    "Colombo",
    "Gampaha",
    "Kelaniya",
    "Hambantota",
    "Tangalle",
    "Weligama",
    "Ahangama",
    "Kegalle",
    'Jaffna',
  ];

  @override
  void initState() {
    super.initState();

    employeeReference = FirebaseDatabase.instance.ref().child("employees");
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 250,
                    width: size.width - 30,

                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Icon(
                            Iconsax.building_34,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                        Center(
                          child: Text(
                            "ARM Office Reg",
                            style: TextStyle(
                              fontFamily: "sfproRoundSemiB",
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            "Please complete your registration by providing accurate details. Submitted information will be reviewed by the administration, and once verified, your account will be approved. Thank you for your trust.",
                            style: TextStyle(
                              fontFamily: "sfproRoundRegular",
                              fontSize: 15,
                              color: Colors.green[300],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// Enter Your Id Number
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Enter Your Id Number",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: idController,
                  style: TextStyle(
                    color: Colors.black, // text color
                    fontFamily: "sfproRoundRegular", // your custom font
                    fontSize: 16, // text size
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "ID Number",
                    hintText: "Enter your ID Number",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "sfproRoundRegular",
                      fontWeight: FontWeight.bold,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: "sfproRoundRegular",
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey.shade400, // thin grey border
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.black, // highlight color when focused
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "sfproRoundRegular",
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Enter your mobile number
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Enter Your Mobile Number",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: mobileController,
                  style: TextStyle(
                    color: Colors.black, // text color
                    fontFamily: "sfproRoundRegular", // your custom font
                    fontSize: 16, // text size
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    hintText: "Enter your Mobile Number",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "sfproRoundRegular",
                      fontWeight: FontWeight.bold,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: "sfproRoundRegular",
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey.shade400, // thin grey border
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.black, // highlight color when focused
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "sfproRoundRegular",
                    ),
                  ),
                ),

                SizedBox(height: 20),

                //Enter your office name
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Enter Your RM Office location",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      height: 50,
                      width: size.width - 180,

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
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                            setState(() {
                                              _selectedTown = selectedItem;
                                            });
                                          },
                                      children: List<Widget>.generate(
                                        _rmOfficeLocation.length,
                                        (int index) {
                                          return Center(
                                            child: Text(
                                              _rmOfficeLocation[index],
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
                                        _rmOfficeLocation[_selectedTown],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
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

                //Enter your office name
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Enter Your Office location",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      height: 50,
                      width: size.width - 180,

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
                                            initialItem:
                                                _selectedarmOfficeLocation,
                                          ),
                                      // This is called when selected item is changed.
                                      onSelectedItemChanged:
                                          (int selectedarmItem) {
                                            setState(() {
                                              _selectedarmOfficeLocation =
                                                  selectedarmItem;
                                            });
                                          },
                                      children: List<Widget>.generate(
                                        _armOfficeLocation.length,
                                        (int index) {
                                          return Center(
                                            child: Text(
                                              _armOfficeLocation[index],
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
                                        _armOfficeLocation[_selectedarmOfficeLocation],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
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

                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CupertinoButton(
                        color: Colors.green.withOpacity(0.2),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "sfproRoundSemiB",
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () async {
                          if (idController.text.isEmpty ||
                              mobileController.text.isEmpty ||
                              _armOfficeLocation[_selectedarmOfficeLocation]
                                  .toString()
                                  .isEmpty ||
                              _rmOfficeLocation[_selectedTown]
                                  .toString()
                                  .isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fill all fields correctly',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          } else {
                            branchReference = FirebaseDatabase.instance
                                .ref()
                                .child("ARM_branches");
                            Map<String, String> branchData = {
                              "branchId": idController.text,
                              "Relevent RO Branch":
                                  _rmOfficeLocation[_selectedTown].toString(),
                              "branchLocation":
                                  _armOfficeLocation[_selectedarmOfficeLocation]
                                      .toString(),
                              "mobile": mobileController.text,
                            };
                            branchReference
                                .child(idController.text)
                                .set(branchData)
                                .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Registration Successful ${_armOfficeLocation[_selectedarmOfficeLocation].toString()}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                })
                                .catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Failed to save branch data: $error",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
