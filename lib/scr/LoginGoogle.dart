import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({super.key});

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final response = await  http.post(
          Uri.parse('http://localhost:8000/google-login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'token': googleAuth.idToken!,
          }),
        );
        if (response.statusCode == 200) {
          setState(() {
            _currentUser = googleUser;
          });
          print('Google login successful');
        } else {
          print('Google login failed');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Container(
        child: _currentUser != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: _currentUser!,
              ),
              title: Text(_currentUser!.displayName ?? ''),
              subtitle: Text(_currentUser!.email),
            ),
            ElevatedButton(
              child: Text('SIGN OUT'),
              onPressed: _handleSignOut,
            ),
          ],
        )
            : ElevatedButton(
          child: Text('SIGN IN'),
          onPressed: _handleSignIn,
        ),
      ),
    );
  }
}
