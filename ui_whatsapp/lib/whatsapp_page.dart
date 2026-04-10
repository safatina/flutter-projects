import 'package:flutter/material.dart';
import 'package:ui_whatsapp/theme.dart';
import 'package:ui_whatsapp/widgets/calls_view.dart';
import 'package:ui_whatsapp/widgets/chat_view.dart';
import 'package:ui_whatsapp/widgets/status_view.dart';
import 'package:ui_whatsapp/widgets/community_view.dart';

class WhatsAppPage extends StatefulWidget {
  const WhatsAppPage({super.key});

  @override
  State<WhatsAppPage> createState() => _WhatsAppPageState();
}

class _WhatsAppPageState extends State<WhatsAppPage>
    with SingleTickerProviderStateMixin {

  final tabs = const [
    Tab(icon: Icon(Icons.groups)),
    Tab(icon: Icon(Icons.camera_alt)), 
    Tab(text: 'CHATS'),
    Tab(text: 'STATUS'),
    Tab(text: 'CALLS'),
  ];

  TabController? tabController;
  var fabIcon = Icons.message;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: tabs.length, vsync: this);

    tabController!.index = 2;

    tabController!.addListener(() {
      setState(() {
        switch (tabController!.index) {

          case 0:
            fabIcon = Icons.groups;
            break;

          case 1:
            fabIcon = Icons.camera;
            break;

          case 2:
            fabIcon = Icons.message;
            break;

          case 3:
            fabIcon = Icons.camera_alt;
            break;

          case 4:
            fabIcon = Icons.call;
            break;

          default:
            fabIcon = Icons.message;
        }
      });
    });
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        backgroundColor: whatsappGreen,
        actions: const [
          Icon(Icons.search),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.more_vert),
          )
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
          indicatorColor: Colors.white,
        ),
      ),

      body: TabBarView(
        controller: tabController,
        children: const [

          CommunityView(),

          Center(
            child: Icon(Icons.camera_alt),
          ),

          ChatView(),

          StatusView(),

          CallsView(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: whatsappLightGreen,
        child: Icon(fabIcon),
      ),
    );
  }
}
