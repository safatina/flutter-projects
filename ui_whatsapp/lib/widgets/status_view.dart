import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/status.dart';
import 'package:ui_whatsapp/theme.dart';
import 'package:ui_whatsapp/widgets/channel_view.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [

              Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 35),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: whatsappGreen,
                          child: const Icon(Icons.add,
                              size: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text("My Status")
                ],
              ),

              const SizedBox(width: 15),

              ...statusList.map((status) {
                return statusItem(status.name);
              }).toList(),

            ],
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Channels",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: whatsappGreen,
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text("Explore"),
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        const ChannelView(),
      ],
    );
  }

  Widget statusItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }
}