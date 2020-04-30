import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
