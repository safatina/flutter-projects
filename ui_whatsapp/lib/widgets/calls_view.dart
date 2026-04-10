import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/calls.dart';
import 'package:ui_whatsapp/theme.dart';

class CallsView extends StatelessWidget {
  const CallsView({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: callsList.length,
      itemBuilder: (context, index) {
        final Calls = callsList[index];
        return ListTile(
          leading: Icon(Icons.account_circle, color: Colors.black45, size: 58),
          title: Text(Calls.name, style: customTextStyle),
          subtitle: Text(
            Calls.statusDate,
            style: const TextStyle(color: Colors.black45, fontSize: 16),
          ),
          trailing: Icon(Icons.call, color: whatsappLightGreen, size: 24),
        );
      },
    );
  }
}
