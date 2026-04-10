import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/chat.dart';
import 'package:ui_whatsapp/theme.dart';
import 'package:ui_whatsapp/widgets/personal_view.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final chat = chatList[index];

        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(chat.image),
          ),

          title: Text(
            chat.name,
            style: customTextStyle,
          ),

          subtitle: Text(
            chat.mostRecentMessage,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),

          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              chat.messageDate,
              style: const TextStyle(
                color: Colors.black45,
              ),
            ),
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalView(chat: chat),
              ),
            );
          },
        );
      },
    );
  }
}