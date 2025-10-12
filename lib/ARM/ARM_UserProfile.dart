import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timber_app/logingPage.dart';

class UserProfilePage_ARM extends StatelessWidget {
  const UserProfilePage_ARM({super.key});

  // Modern color system
  static const Color _primaryColor = Color(0xFF2563EB); // Deep modern blue
  static const Color _secondaryColor = Color(0xFF10B981); // Soft green accent
  static const Color _backgroundColor = Color(0xFFF8FAFC);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textLight = Color(0xFF64748B);
  static const Color _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context),
              const SizedBox(height: 25),
              _buildProfileHeader(),
              const SizedBox(height: 30),
              _buildUserStats(),
              const SizedBox(height: 25),

              const SizedBox(height: 40),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // Header with title and icons
  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Profile Overview",
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  // Profile avatar and info
  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            _primaryColor.withOpacity(0.12),
            _secondaryColor.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(radius: 40),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Aria Montgomery",
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Product Designer | UI Enthusiast",
                  style: TextStyle(color: _textLight, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.pencil, color: _primaryColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Stats row (projects, followers, etc.)
  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("Projects", "24"),
        _statCard("Followers", "1.4K"),
        _statCard("Level", "Pro"),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(color: _textLight, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // About / Info section

  // Modern activity/task overview

  // Bottom buttons
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: _primaryColor.withOpacity(0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().whenComplete(() {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Loging_homePage()),
                  (route) => false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Log Out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
