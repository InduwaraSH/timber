import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:timber_app/ARM/ARM_B_Nav.dart';
import 'package:timber_app/CO/CO_B_Nav.dart';
import 'package:timber_app/RM/RM_B_Nav.dart';

class Login {
  late final credential;
  Future<void> signIn(
    String employeeId,
    String password,
    BuildContext context,
  ) async {
    bool result = await InternetConnection().hasInternetAccess;

    if (result == false) {
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
    } else if (employeeId.isEmpty || password.isEmpty) {
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
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: '${employeeId.trim()}@gmail.com',
              password: password.trim(),
            );
        DatabaseReference dbref = FirebaseDatabase.instance
            .ref()
            .child("employee_data_saved")
            .child(employeeId);

        final snapshot = await dbref.child('employeePosition').get();

        final snapshot_office = await dbref.child('employeeOffice').get();
        if (snapshot.exists) {
          if (snapshot.value == 'RM') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RmBNavbar(
                  office_location: snapshot_office.value.toString(),
                ),
              ),
            );
          } else if (snapshot.value == 'ARM') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => arm_b_nav_bar(
                  office_location: snapshot_office.value.toString(),
                ),
              ),
            );
          } else if (snapshot.value == 'CO') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => co_b_navbar(
                  office_location: snapshot_office.value.toString(),
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
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
        print("FirebaseAuthException: ${e.code}");
        ScaffoldMessenger.of(context).showSnackBar(
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
          print('No user found for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
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
          print('Wrong password provided for that user.');
          ScaffoldMessenger.of(context).showSnackBar(
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
        print("Unexpected error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
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
  }
}
