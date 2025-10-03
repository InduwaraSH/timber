import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

class Create_Form_Rm extends StatefulWidget {
  final String office_location;
  final String branch_name;
  const Create_Form_Rm(this.office_location, this.branch_name, {super.key});

  @override
  State<Create_Form_Rm> createState() => _Create_Form_RmState();
}

class _Create_Form_RmState extends State<Create_Form_Rm> {
  DateTime? _selectedDate; // Added to fix undefined name error
  TextEditingController POCController = TextEditingController();
  TextEditingController SerialController = TextEditingController();
  TextEditingController LetterNumController = TextEditingController();

  late DatabaseReference branchReference;
  late DatabaseReference employeeReference;

  String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
                      color: const Color(0xFFDAD6FF).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(
                          Iconsax.paperclip,
                          size: 50,
                          color: Color(0xFF756AB6),
                        ),
                        Center(
                          child: Text(
                            "Timber Registration",
                            style: TextStyle(
                              fontFamily: "sfproRoundSemiB",
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF756AB6),
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
                              color: Color(0xFF756AB6).withOpacity(0.4),
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
                    "Enter Serial Number",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: SerialController,
                  style: TextStyle(
                    color: Colors.black, // text color
                    fontFamily: "sfproRoundRegular", // your custom font
                    fontSize: 16, // text size
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Serial Number",
                    hintText: "Enter your Serial Number",
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

                //poc
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Place Of Cope",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: POCController,
                  style: TextStyle(
                    color: Colors.black, // text color
                    fontFamily: "sfproRoundRegular", // your custom font
                    fontSize: 16, // text size
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Place Of Cope",
                    hintText: "Enter Place Of Cope",
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

                //Enter letter number
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 5),
                  child: Text(
                    "Enter Letter Number",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: LetterNumController,
                  style: TextStyle(
                    color: Colors.black, // text color
                    fontFamily: "sfproRoundRegular", // your custom font
                    fontSize: 16, // text size
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Letter Number",
                    hintText: "Enter Letter Number",
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
                    "Select Your Date",
                    style: TextStyle(
                      fontFamily: "sfproRoundSemiB",
                      fontSize: 16,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => Container(
                        height: 300,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime:
                                    _selectedDate ?? DateTime.now(),
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() {
                                    _selectedDate = newDate;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        _selectedDate != null
                            ? getFormattedDate(_selectedDate)
                            : "Select Date",
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: "sfproRoundSemiB",
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
                        color: Colors.blue.withOpacity(0.2),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "sfproRoundSemiB",
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () async {
                          bool result =
                              await InternetConnection().hasInternetAccess;

                          if (result == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No internet connection',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.grey,
                              ),
                            );
                            return;
                          } else {
                            if (POCController.text.isEmpty ||
                                SerialController.text.isEmpty ||
                                LetterNumController.text.isEmpty ||
                                _selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please fill all fields correctly ${getFormattedDate(_selectedDate)}.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            } else {
                              Map<String, String> reqData = {
                                'Serial Number': SerialController.text,
                                'placeOfCoupe': POCController.text,
                                'LetterNo': LetterNumController.text,
                                'DateInformed': getFormattedDate(
                                  _selectedDate,
                                ).toString(),
                                'ARM_Branch_Name': widget.branch_name
                                    .toString(),
                                "office_location": widget.office_location
                                    .toString(),
                                "from": "RM",
                              };
                              FirebaseDatabase.instance
                                  .ref()
                                  .child("ARM_branch_data_saved")
                                  .child(widget.branch_name.toString())
                                  .child("Recived")
                                  .child(SerialController.text)
                                  .set(reqData)
                                  .then((_) {
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child("RM_branch_data_saved")
                                        .child(
                                          widget.office_location.toString(),
                                        )
                                        .child("Sent")
                                        .push()
                                        .set(reqData);
                                  })
                                  .then((_) {
                                    Map<String, String> status = {
                                      'location': POCController.text,
                                      'Status': "ARM_R_D_One",
                                      'RM_R_D_One': getFormattedDate(
                                        _selectedDate,
                                      ).toString(),
                                      'ARM_R_D_One': DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(DateTime.now()).toString(),
                                      'CO_R_D_One': "",
                                      'ARM_R_D_two': "",
                                      'RM_R_D_two': "",
                                      'approved': "",
                                      'procurement': "",
                                      'tree_removal': "",
                                      'job_completed': "",
                                    };
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child("Status_of_job")
                                        .child(widget.branch_name.toString())
                                        .child(SerialController.text)
                                        .set(status);
                                  })
                                  .then((_) async {
                                    DatabaseReference dbref = FirebaseDatabase
                                        .instance
                                        .ref()
                                        .child("Ongoing_Count")
                                        .child(
                                          widget.office_location.toString(),
                                        )
                                        .child("ongoing");

                                    await dbref.runTransaction((currentData) {
                                      int currentValue =
                                          (currentData as int?) ??
                                          0; // if not exist → 0
                                      return Transaction.success(
                                        currentValue + 1,
                                      );
                                    });
                                  })
                                  .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "Request Sent Successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  })
                                  .catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to update data: $error',
                                        ),
                                      ),
                                    );
                                  });
                            }
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
