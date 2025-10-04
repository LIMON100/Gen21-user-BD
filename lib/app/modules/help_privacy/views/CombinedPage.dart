import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/help_privacy/views/help_screen_view.dart';
import 'package:home_services/app/modules/help_privacy/views/help_view.dart';


class CombinedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Help & Faq'),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Get Started'),
              Tab(text: 'Help & Support'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ImageSliderPage(),
            HelpView(),
          ],
        ),
      ),
    );
  }
}