import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/channel.dart';
import 'package:ui_whatsapp/theme.dart';

class ChannelView extends StatelessWidget {
  const ChannelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: channelList.map((channel) {
        return ChannelTile(
          name: channel.name,
          message: channel.message,
          time: "Today",
          count: "3",
        );
      }).toList(),
    );
  }
}

class ChannelTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String count;

  const ChannelTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.green,
        child: Icon(Icons.campaign, color: Colors.white),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(color: Colors.green),
          ),
          const SizedBox(height: 5),
          CircleAvatar(
            radius: 10,
            backgroundColor: whatsappGreen,
            child: Text(
              count,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}