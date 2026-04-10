import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/community.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: communityList.length,
      itemBuilder: (context, index) {

        final community = communityList[index];

        return Column(
          children: [

            // COMMUNITY HEADER
            ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green,
                child: Icon(Icons.groups, color: Colors.white),
              ),
              title: Text(
                community.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Divider(),

            // ANNOUNCEMENT
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.campaign, color: Colors.white),
              ),
              title: const Text("Announcements"),
              subtitle: Text(community.description),
              trailing: const Text("Today"),
            ),

            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.group, color: Colors.white),
              ),
              title: Text("General Discussion"),
              subtitle: Text("Admin menambahkan anggota baru"),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "View all",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Divider(),

          ],
        );
      },
    );
  }
}
