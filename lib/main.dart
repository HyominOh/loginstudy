import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_sns_login/src/app.dart';
import 'package:sample_sns_login/src/pages/code.dart';
import 'package:url_strategy/url_strategy.dart'; // 패키지를 import.

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      home: const App(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const App(),
        ),
        GetPage(
          name: '/accesstoken',
          page: () => const CodePage(),
        )
      ],
    );
  }
}
