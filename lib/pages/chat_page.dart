import 'package:mobile_programming_fp/components/message_list.dart';
import 'package:mobile_programming_fp/components/user_input.dart';
import 'package:mobile_programming_fp/services/auth/auth_service.dart';
import 'package:mobile_programming_fp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  String? editingMessageId;
  String? editingMessage;

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => scrollDown(),
          );
        }
      },
    );

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      if (editingMessageId != null) {
        await _chatService.updateMessage(
            widget.receiverID, editingMessageId!, _messageController.text);
        editingMessageId = null;
        editingMessage = null;
      } else {
        await _chatService.sendMessage(
            widget.receiverID, _messageController.text);
      }
      _messageController.clear();
    }
    scrollDown();
  }

  void editMessage(String messageId, String message) {
    setState(() {
      editingMessageId = messageId;
      editingMessage = message;
      _messageController.text = message;
    });
    myFocusNode.requestFocus();
  }

  void deleteMessage(String messageId) async {
    await _chatService.deleteMessage(widget.receiverID, messageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text(
            widget.receiverEmail,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                receiverID: widget.receiverID,
                scrollController: _scrollController,
                chatService: _chatService,
                authService: _authService,
                onEdit: editMessage,
                onDelete: deleteMessage,
              ),
            ),
            UserInput(
              messageController: _messageController,
              focusNode: myFocusNode,
              onSend: sendMessage,
              editingMessage: editingMessage,
            ),
          ],
        ),
      ),
    );
  }
}
