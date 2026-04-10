import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/personal.dart';
import 'package:ui_whatsapp/models/chat.dart';
import 'package:ui_whatsapp/theme.dart';

class PersonalView extends StatefulWidget {

  final Chat chat;

  const PersonalView({super.key, required this.chat});

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {

  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messageList.add(
          Personal(
            message: messageController.text,
            isMe: true,
          ),
        );
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.chat.name),
        backgroundColor: whatsappGreen,
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {

                final message = messageList[index];

                return Container(
                  alignment:
                      message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? Colors.green.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message.message),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}