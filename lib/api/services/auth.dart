

import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

 void signOut() async{
    return firebaseAuth.signOut();
  }

  getCurrentUserUid()async{
   FirebaseUser user = await firebaseAuth.currentUser();
   return user.uid;
  }

}