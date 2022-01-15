import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
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
  }

  Future<UserCredential?> signInWithKakao() async {
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'response_type': 'code',
      'client_id': '3dc5ab81c61412157853d4b15d0fe90f',
      'response_mode': 'form_post',
      'redirect_uri': 'https://sugar-quiver-sweatshirt.glitch.me/callbacks/kakao/sign_in',
      'state' : 'test'
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'webauthcallback');

    final body = Uri.parse(result).queryParameters;
    print(body);

    final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
      'grant_type': 'authorization_code',
      'client_id': '3dc5ab81c61412157853d4b15d0fe90f',
      'redirect_uri': 'https://sugar-quiver-sweatshirt.glitch.me/callbacks/kakao/sign_in',
      'code':body['code'],
    });
  }

  // app.get("/callbacks/kakao/sign_in", async (request, response) => {
  //   const redirect = `webauthcallback://success?${new URLSearchParams(request.query).toString()}`
  //   console.log(redirect);
  //   response.redirect(307, redirect);
  // });

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
                signInWithGoogle();
              },
              child: const Text('Google login')
            ),
            ElevatedButton(
                onPressed: (){
                  signInWithFacebook();
                },
                child: const Text('Facebook login')
            ),
            ElevatedButton(
                onPressed: (){
                  signInWithKakao();
                },
                child: const Text('Kakao login')
            ),
          ],
        ),
      ),
    );
  }
}
