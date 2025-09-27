import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:timber_app/loging.dart';

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
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
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
                        child: Text("Enter Your Id Number"),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // rounded corners
                            borderSide: BorderSide(
                              color: Colors.black, // border color
                              width: 2, // border thickness
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.green, // border color when focused
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // rounded corners
                            borderSide: BorderSide(
                              color: Colors.black, // border color
                              width: 2, // border thickness
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.green, // border color when focused
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
