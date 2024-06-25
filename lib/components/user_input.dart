import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_programming_fp/themes/theme_provider.dart';
import 'package:mobile_programming_fp/components/my_textfield.dart';

class UserInput extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final String? editingMessage;

  const UserInput({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.onSend,
    this.editingMessage,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: messageController,
              hintText: editingMessage == null
                  ? "Write something..."
                  : "Edit your message...",
              obscureText: false,
              focusNode: focusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: onSend,
              icon: Icon(
                editingMessage == null
                    ? Icons.arrow_circle_right_outlined
                    : Icons.check_circle_outline,
                color: isDarkMode ? Colors.amber : Colors.lightBlueAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
