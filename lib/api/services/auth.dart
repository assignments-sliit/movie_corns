import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * IT17050272 - D. Manoj Kumar
 * 
 * This auth.dart file is consisting with services which used to authenticate logged user
 * & get the user ID of logged user
 * Also here is the source code for Signout function too 
 */

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return firebaseAuth.signOut();
  }

  getCurrentUserUid() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }
}
