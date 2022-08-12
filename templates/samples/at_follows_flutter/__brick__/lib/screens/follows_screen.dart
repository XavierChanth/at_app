import 'package:at_follows_flutter/screens/connections.dart';
import 'package:flutter/material.dart';

import '../services/at_service.dart';
import '../services/notification_service.dart';
import '../utils/app_strings.dart';

class FollowsScreen extends StatefulWidget {
  @override
  _NextScreen createState() => _NextScreen();
}

class _NextScreen extends State<FollowsScreen> {
  String? atSign;
  AtService atService = AtService.getInstance();
  late NotificationService _notificationService;
  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.setOnNotificationClick(onNotificationClick);
  }

  onNotificationClick(String payload) {
    print(
        'clicked inside on notification click and received atsign is $payload');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Next Screen'),
          actions: [
            // if (_atsign != null)
          ],
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Connections(
                                atClientserviceInstance:
                                    atService.atClientServiceInstance!,
                                appColor: Colors.blue)));
                  },
                  child: Text(AppStrings.nextscreen)),
            ),
          );
        }),
      ),
    );
  }
}
