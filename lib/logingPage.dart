import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:timber_app/AGM/AGM_B_Nav.dart';
import 'package:timber_app/ARM/ARM_B_Nav.dart';
import 'package:timber_app/CO/CO_B_Nav.dart';
import 'package:timber_app/PositionPicker.dart';
import 'package:timber_app/RM/RM_B_Nav.dart';
import 'package:timber_app/office_reg_picker.dart';

class Loging_homePage extends StatefulWidget {
  const Loging_homePage({super.key});

  @override
  State<Loging_homePage> createState() => _Loging_homePageState();
}

class _Loging_homePageState extends State<Loging_homePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible_button = true;
  bool isVisible_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 90),
              Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                    fontFamily: "sfProRoundSemiB",
                  ),
                ),
              ),
              SizedBox(height: 0),
              Center(
                child: Text(
                  "Hi! Welcome Back, you've been missed",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "sfProRoundSemiB",
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Form(
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.maybeOf(primaryFocus!.context!)?.save();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        controller: usernameController,
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
                              color:
                                  Colors.black, // highlight color when focused
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
                      SizedBox(height: 35),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0, left: 5),
                        child: Text(
                          "Enter Your Password",
                          style: TextStyle(
                            fontFamily: "sfproRoundSemiB",
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black, // text color
                          fontFamily: "sfproRoundRegular", // your custom font
                          fontSize: 16, // text size
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter password",
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
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sfproRoundRegular",
                          ),
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ), // eye icon
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: isVisible_button ? 1.0 : 0.0,
                        child: Visibility(
                          visible: isVisible_button,
                          child: CupertinoButton(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Iconsax.login5,
                                size: 65,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (usernameController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please fill in all fields.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'sfpro',
                                        fontSize: 18,
                                      ),
                                    ),
                                    duration: Duration(seconds: 5),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else {
                                setState(() {
                                  isVisible_button = false;
                                  isVisible_loading = true;
                                });
                                () async {
                                  bool result = await InternetConnection()
                                      .hasInternetAccess;

                                  if (result == false) {
                                    setState(() {
                                      isVisible_button = true;
                                      isVisible_loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'No internet connection',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'sfpro',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );

                                    return;
                                  } else if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    setState(() {
                                      isVisible_button = true;
                                      isVisible_loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please fill all fields correctly.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'sfpro',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                            email:
                                                '${usernameController.text}@gmail.com',
                                            password: passwordController.text,
                                          );
                                      print(
                                        "Signed in as: ${usernameController.text}@gmail.com",
                                      );
                                      DatabaseReference dbref = FirebaseDatabase
                                          .instance
                                          .ref()
                                          .child("employee_data_saved")
                                          .child(usernameController.text);

                                      final snapshot = await dbref
                                          .child('employeePosition')
                                          .get();
                                      print(
                                        "employeePosition: ${snapshot.value}",
                                      );

                                      final snapshot_office = await dbref
                                          .child('employeeOffice')
                                          .get();
                                      print(
                                        "employeeOffice: ${snapshot_office.value}",
                                      );
                                      if (snapshot.exists) {
                                        if (snapshot.value == 'RM') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RmBNavbar(
                                                office_location: snapshot_office
                                                    .value
                                                    .toString(),
                                                username:
                                                    usernameController.text,
                                              ),
                                            ),
                                          ).whenComplete(() {
                                            setState(() {
                                              isVisible_button = true;
                                              isVisible_loading = false;
                                            });
                                          });
                                        } else if (snapshot.value == 'ARM') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  arm_b_nav_bar(
                                                    office_location:
                                                        snapshot_office.value
                                                            .toString(),
                                                    username:
                                                        usernameController.text,
                                                  ),
                                            ),
                                          ).whenComplete(() {
                                            setState(() {
                                              isVisible_button = true;
                                              isVisible_loading = false;
                                            });
                                          });
                                        } else if (snapshot.value == 'CO') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => co_b_navbar(
                                                office_location: snapshot_office
                                                    .value
                                                    .toString(),
                                                username:
                                                    usernameController.text,
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.value == 'AGM') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  agm_b_navbar(
                                                    office_location:
                                                        snapshot_office.value
                                                            .toString(),
                                                    username:
                                                        usernameController.text,
                                                  ),
                                            ),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          isVisible_button = true;
                                          isVisible_loading = false;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Something went wrong',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'sfpro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        isVisible_button = true;
                                        isVisible_loading = false;
                                      });
                                      print("FirebaseAuthException: ${e.code}");
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.code,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'sfpro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      // print("FirebaseAuthException: ${credential.user?.email}");
                                      if (e.code == 'user-not-found') {
                                        setState(() {
                                          isVisible_button = true;
                                          isVisible_loading = false;
                                        });
                                        print('No user found for that email.');
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No user found for that email.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'sfpro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else if (e.code == 'wrong-password') {
                                        setState(() {
                                          isVisible_button = true;
                                          isVisible_loading = false;
                                        });
                                        print(
                                          'Wrong password provided for that user.',
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Wrong password provided for that user.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'sfpro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isVisible_button = true;
                                        isVisible_loading = false;
                                      });
                                      print("Unexpected error: $e");
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Unexpected error: $e",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'sfpro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }();
                              }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const Home(),
                              //   ),
                              // );},
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Visibility(
                  visible: isVisible_loading,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      animating: isVisible_loading,
                      radius: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Divider(
                color: Colors.grey.shade400, // line color
                thickness: 1, // line thickness
                indent: 20, // left spacing
                endIndent: 20, // right spacing
              ),
              SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: CupertinoButton(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Iconsax.building,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OfficeRegPicker(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      "If you don't have an account \n Create account",
                      style: TextStyle(
                        fontFamily: "sfproRoundSemiB",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: Container(
                        child: CupertinoButton(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Iconsax.user_add,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Positionpicker(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
