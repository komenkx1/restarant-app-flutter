import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/header_component.dart';
import 'package:restaurant_app/providers/scheduling_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderComponent(
                  headerText: "Setting Page",
                  subHeaderText: "Setiing up your app",
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    title: const Text('Dark Theme'),
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) => customDialog(context),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Scheduling Daily Restaurant'),
                    trailing: Consumer<SchedulingProvider>(
                      builder: (context, scheduled, _) {
                        return Switch.adaptive(
                          value: scheduled.isScheduled,
                          onChanged: (value) async {
                            if (Platform.isIOS) {
                              customDialog(context);
                            } else {
                              scheduled.scheduledNews(value);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Coming Soon!'),
            content: const Text('This feature will be coming soon!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Coming Soon!'),
            content: const Text('This feature will be coming soon!'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
