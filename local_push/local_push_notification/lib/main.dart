import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationApp(),
    );
  }
}

class NotificationApp extends StatefulWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  State<NotificationApp> createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  TextEditingController inputController = TextEditingController();

  FlutterLocalNotificationsPlugin? localNotification;
  var task;
  var _selectedParam;
  var val;
  var scheduledTime;

  @override
  void initState() {
    super.initState();
    var androidInitalize = AndroidInitializationSettings("ic_launcher");
    var initializationSettings =
        InitializationSettings(android: androidInitalize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification?.initialize(
      initializationSettings,
    );
  }

  final sound = "lion_roar.wav";
  Future _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Local Notification",
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound("lion_roar"),
        playSound: true);
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    await localNotification?.show(
        0, "title", "body", generalNotificationDetails);

    if (_selectedParam == "Hour") {
      scheduledTime = DateTime.now().add(Duration(hours: val));
    } else if (_selectedParam == "Minutes") {
      scheduledTime = DateTime.now().add(Duration(minutes: val));
    } else if (_selectedParam == "Seconds") {
      scheduledTime = DateTime.now().add(Duration(seconds: val));
    }

    // var scheduledTime = DateTime.now().add(Duration(seconds: 5));
    localNotification!.schedule(
        1, "Times Uppp", inputController.text, scheduledTime, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remainder',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (_val) {
                task = _val;
              },
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DropdownButton(
                      value: _selectedParam,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Seconds"),
                          value: "Seconds",
                        ),
                        DropdownMenuItem(
                          child: Text("Minutes"),
                          value: "Minutes",
                        ),
                        DropdownMenuItem(
                          child: Text("Hour"),
                          value: "Hour",
                        ),
                      ],
                      hint: Text(
                        "Select Your Field.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onChanged: (_val) {
                        setState(() {
                          _selectedParam = _val;
                        });
                      }),
                  DropdownButton<int>(
                      value: val,
                      items: const [
                        DropdownMenuItem(
                          child: Text("1"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("2"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("3"),
                          value: 3,
                        ),
                      ],
                      hint: Text(
                        "Select Value.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onChanged: (_val) {
                        setState(() {
                          val = _val;
                        });
                      })
                ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
