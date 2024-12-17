import 'package:flutter/material.dart';

import '../../Widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    try {
      return Center(
        child: CustomLoadingScreen(
          message: "We're Still Building This Part",
        ),
      );
    } catch (e) {
      // Display any errors that occur
      return Center(
        child: Text('Error: $e'),
      );
    }
  }
}