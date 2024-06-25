import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_programming_fp/components/chat_bubble.dart';
import 'package:mobile_programming_fp/services/auth/auth_service.dart';
import 'package:mobile_programming_fp/services/chat/chat_service.dart';

class MessageList extends StatelessWidget {
  final String receiverID;
  final ScrollController scrollController;
  final ChatService chatService;
  final AuthService authService;
  final void Function(String messageId, String message) onEdit;
  final void Function(String messageId) onDelete;

  const MessageList({
    super.key,
    required this.receiverID,
    required this.scrollController,
    required this.chatService,
    required this.authService,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String senderID = authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: chatService.getMessages(receiverID, senderID),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error getting messages.");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading . . .");
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            return _buildMessageItem(doc);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
        onEdit: () => onEdit(doc.id, data["message"]),
        onDelete: () => onDelete(doc.id),
      ),
    );
  }
}
