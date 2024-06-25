import 'package:mobile_programming_fp/pages/profle_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_programming_fp/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_programming_fp/themes/theme_provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.onProfilePressed,
  });

  final VoidCallback onProfilePressed;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final String profileImageUrl = AuthService().getCurrentUser()?.photoURL ??
        'https://avatars.githubusercontent.com/u/87126965?v=4';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePage(), // Replace with your profile page widget
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode ? Colors.amber : Colors.lightBlueAccent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: CircleAvatar(
                radius: 40, // Increased size for visibility
                backgroundImage: NetworkImage(profileImageUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 7.0),
        ],
      ),
    );
  }
}
