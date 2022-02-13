import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample_sns_login/src/pages/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage()
    // body: StreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder:(BuildContext context,  AsyncSnapshot<User?> snapshot) {
    //     if (!snapshot.hasData) {
    //       return const LoginPage();
    //     } else {
    //       return Center(
    //         child: Text('${snapshot.data?.displayName} welcome')
    //       );
    //     }
    //   }
    // ),
    );
  }

}
