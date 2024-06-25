import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  // Function to get the background color based on the theme
  Color getTileColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? Colors.grey.shade800
        : Theme.of(context).colorScheme.secondary;
  }

  // Function to get the icon color based on the theme
  Color getIconColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.amber : Colors.lightBlue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: getTileColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(
                1.0,
                2.0,
              ),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Profile
            Icon(Icons.person_2_outlined, color: getIconColor(context)),

            const SizedBox(
              width: 10,
            ),

            // Username (unchanged text style)
            Text(text),
          ],
        ),
      ),
    );
  }
}
