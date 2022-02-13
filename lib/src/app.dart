import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample_sns_login/src/pages/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home();
    // return FutureBuilder(
    //   future: Firebase.initializeApp(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return const Center(child: Text("error"));
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return const Home();
    //     }
    //     return const CircularProgressIndicator();
    //     return Container();
    //   });
  }
}
