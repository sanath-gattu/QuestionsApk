import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/dashboard.dart';
import 'package:phnauthnew/screens/loginpage.dart';
class AuthService {

  AuthCredential authCreds;
  String verId;
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return DashboardPage();
          } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  // //SignIn
  // signIn(AuthCredential authCreds) {
  //
  //   FirebaseAuth.instance.signInWithCredential(authCreds);
  // }

  signInWithOTP(smsCode, verId) {
    authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(authCreds);
    this.verId=verId;


  }
}
