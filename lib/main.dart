import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:task_management/Auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'UKESklDXLaTqRauW6H7QYnqtHfl7eXqAZc54UcCX';
  const keyClientKey = 'bwDDxz0h4NQeDvCGuMR1vsPp5qZHHz5KFSvkHpm9';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}
