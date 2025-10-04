import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:timber_app/logingPage.dart';

class CoHome extends StatelessWidget {
  final String office_location;
  final String username;

  const CoHome({super.key, required this.office_location, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [profile_button(), alert_button()],
            ),
            Text(office_location),
          ],
        ),
      ),
    );
  }
}

class alert_button extends StatelessWidget {
  const alert_button({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        FirebaseAuth.instance.signOut().whenComplete(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Loging_homePage()), // Login page
            (route) => false, // remove all routes
          );
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topRight,
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          radius: 25,
          child: Icon(
            Iconsax.notification,
            color: Colors.green,
            size: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class profile_button extends StatelessWidget {
  const profile_button({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {},
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 20),
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green[100],
          child: Icon(
            Iconsax.user,
            size: 23,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
