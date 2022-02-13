import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:universal_html/html.dart' as whtml;
import 'dart:js' as js;
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String log = '';

  Future<UserCredential> signInWithFacebook() async {
    final identifier = 'my client identifier';
    final secret = 'my client secret';

    final redirectUrl = Uri.parse('http://my-site.com/oauth2-redirect');
    final credentialsFile = File('~/.myapp/credentials.json');

    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential?> signInWithGoogle() async {
    //Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

    final url = Uri.https(
        'account.samsung.com', '/accounts/v1/dropship_client/signInGate', {
      'response_type': 'code',
      'client_id': '5il5jq9wex',
      //'redirect_uri': 'https://us-central1-backend7806.cloudfunctions.net/app/sign_in',
      'redirect_uri': 'http://localhost:8888/accesstoken',
      //'redirect_uri': 'https://backend7806.web.app/accesstoken',
      'state': 'web'
    });

    whtml.window.localStorage.remove('code');
    var newTab = whtml.window.open(url.toString(), '_blank');

    String? authCode;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      authCode = whtml.window.localStorage['code'];
      if (authCode == null) continue;

      whtml.window.localStorage.remove('code');
      break;
    }

    if (authCode == null) {
      print('code is null');
      return null;
    }

    //print(authCode);
    newTab.close();
    setState(() {
      log = authCode!;
    });

    final tokenUrl = Uri.https('api.account.samsung.com', '/auth/oauth2/v2/token', {
      'grant_type': 'authorization_code',
      'client_id': '5il5jq9wex',
      'client_secret': '25C8E772DAACBF345D5F55E7B6DAAD9D',
      'redirect_uri': 'http://localhost:8888/accesstoken',
      //'redirect_uri': 'https://backend7806.web.app/accesstoken',
      'code': authCode,
    });

    var header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Access-Control-Request-Methods':'POST',
      'Access-Control-Request-Headers':'X-PINGOTHER, Content-type',
    };

    print('hmhm bef');
    setState(() {
      log = authCode ?? 'null';
    });

    http.Response? res;
    try {
      res = await http.post(tokenUrl, headers: header);
    } catch (e) {
      setState(() {
        log = e.toString();
      });
    }

    if (res != null) {
      setState(() {
        log = json.decode(res!.body).toString();
      });
      print(json.decode(res.body));
    }

  }

  void login(String redirectUrl) async {
    final url = Uri.https(
      'account.samsung.com', '/accounts/v1/dropship_client/signInGate', {
      'response_type': 'code',
      'client_id': '5il5jq9wex',
      'redirect_uri': redirectUrl,
      'state': 'web'
    });

    whtml.window.localStorage.remove('code');
    var newTab = whtml.window.open(url.toString(), '_blank');
    print("hmhm new tab");
    // var newTab = whtml.window.open(url.toString(),
    //   'oauth2_client::authenticateWindow',
    //   'menubar=no, status=no, scrollbars=no, menubar=no, width=1000, height=500');
    //
    // whtml.window.onMessage
    //       .listen((evt) {
    //         print("hmhm ${evt.toString()}");
    //       });
        // .firstWhere((evt) {
        //   print("hmhm ${evt.toString()}");
        //   return evt.origin == Uri.parse(redirectUrl).origin;
        // });

    //newTab.close();

    //print('hmhm ${messageEvt.data}');
    //return;

    String? authCode;
    while (true) {
      print('hmhm wait code');
      await Future.delayed(const Duration(seconds: 1));
      authCode = whtml.window.localStorage['code'];
      print('hmhm wait code2 $authCode');
      if (authCode == null) continue;

      print('hmhm break $authCode');
      whtml.window.localStorage.remove('code');
      break;
    }

    if (authCode == null) {
      print('hmhm code is null');
      return null;
    }

    //newTab.close();
    print(authCode);
    // Get.offAllNamed('/');
    // //newTab.close();
    //
    // return;
    // final tokenUrl = Uri.https('api.account.samsung.com', '/auth/oauth2/v2/token', {
    //   'grant_type': 'authorization_code',
    //   'client_id': '5il5jq9wex',
    //   'client_secret': '25C8E772DAACBF345D5F55E7B6DAAD9D',
    //   'redirect_uri': redirectUrl,
    //   'code': authCode,
    // });
    //
    // var data = {
    //   'grant_type': 'authorization_code',
    //   'client_id': '5il5jq9wex',
    //   'client_secret': '25C8E772DAACBF345D5F55E7B6DAAD9D',
    //   'redirect_uri': redirectUrl,
    //   'code': authCode,
    // };
    // var parts = [];
    // data.forEach((key, value) {
    //   parts.add('${Uri.encodeQueryComponent(key)}='
    //       '${Uri.encodeQueryComponent(value)}');
    // });
    // var formData = parts.join('&');
    // print('hmhm form $formData');
    //
    //
    // var header = {
    //   'Content-Type': 'application/x-www-form-urlencoded',
    //   //'Access-Control-Allow-Headers': '*',
    //   //"Access-Control-Allow-Origin": "*",
    //   //"Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    // };
    //
    // print('hmhm bef');
    // setState(() {
    //   log = authCode ?? 'null';
    // });
    //
    // var client = BrowserClient()..withCredentials = true;
    //
    // http.Response? res;
    // try {
    //   //res = await http.post(tokenUrl, headers: header);
    //   //res = await client.post(tokenUrl, headers: header);
    //   js.context.callMethod('post3', [authCode]);
    // } catch (e) {
    //   setState(() {
    //     log = e.toString();
    //   });
    // }
    //
    // if (res != null) {
    //   setState(() {
    //     //log = json.decode(res!.body).toString();
    //   });
    //   //print(json.decode(res.body));
    // }
  }

  Future<UserCredential?> signInWithKakao() async {
      // final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      //   'response_type': 'code',
      //   'client_id': '3dc5ab81c61412157853d4b15d0fe90f',
      //   'response_mode': 'form_post',
      //   'redirect_uri': 'https://sugar-quiver-sweatshirt.glitch.me/callbacks/kakao/sign_in',
      //   'state' : 'test'
      // });
      //
      // final result = await FlutterWebAuth.authenticate(
      //     url: url.toString(),
      //     callbackUrlScheme: 'webauthcallback');
      //
      // print('hmhm $result');
      // final body = Uri.parse(result).queryParameters;
      // print(body);
    final url = Uri.https(
      'account.samsung.com', '/accounts/v1/dropship_client/signInGate', {
      'response_type': 'code',
      'client_id': '5il5jq9wex',
      //'redirect_uri': 'https://us-central1-backend7806.cloudfunctions.net/app/sign_in',
      //'redirect_uri': 'http://localhost:8888/accesstoken',
      'redirect_uri': 'https://backend7806.web.app/accesstoken',
      'state': 'web'
    });
    Uri uri = Uri.parse('uri');

    whtml.window.localStorage.remove('code');
    var newTab = whtml.window.open(url.toString(), '_blank');

    String? authCode;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      authCode = whtml.window.localStorage['code'];
      if (authCode == null) continue;

      whtml.window.localStorage.remove('code');
      break;
    }

    if (authCode == null) {
      print('code is null');
      return null;
    }

    //print(authCode);
    newTab.close();

    final tokenUrl = Uri.https('api.account.samsung.com', '/auth/oauth2/v2/token', {
      'grant_type': 'authorization_code',
      'client_id': '5il5jq9wex',
      'client_secret': '25C8E772DAACBF345D5F55E7B6DAAD9D',
      //'redirect_uri': 'http://localhost:8888/accesstoken',
      'redirect_uri': 'https://backend7806.web.app/accesstoken',
      'code': authCode,
    });

    var header = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    print('hmhm bef');
    setState(() {
      log = authCode ?? 'null';
    });


    http.Response? res;
    try {
      res = await http.post(tokenUrl, headers: header);
    } catch (e) {
      setState(() {
        log = e.toString();
      });
    }

    if (res != null) {
      setState(() {
        log = json.decode(res!.body).toString();
      });
      print(json.decode(res.body));
    }

    // final result = await FlutterWebAuth.authenticate(
    //     url: url.toString(),
    //     callbackUrlScheme: 'webauthcallback');
    //
    // final body = Uri
    //     .parse(result)
    //     .queryParameters;
    // print(body);

    // final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
    //   'grant_type': 'authorization_code',
    //   'client_id': '3dc5ab81c61412157853d4b15d0fe90f',
    //   'redirect_uri': 'https://sugar-quiver-sweatshirt.glitch.me/callbacks/kakao/sign_in',
    //   'code':body['code'],
    // });

    // var response = await http.post(tokenUrl);
    // print('hmhm body ${response.body}');
    //
    // var accessTokenResult = json.decode(response.body);
    // print(accessTokenResult['access_token']);
  }

  // app.get("/callbacks/kakao/sign_in", async (request, response) => {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sns login'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                //signInWithGoogle();
                login('http://localhost:8888/accesstoken');
              },
              child: const Text('Samsung(localhost) login')
            ),
            ElevatedButton(
                onPressed: (){
                  //signInWithKakao();
                  login('https://backend7806.web.app/accesstoken');
                },
                child: const Text('Samsung login')
            ),
            Expanded(child: Text(log))
          ],
        ),
      ),
    );
  }
}
