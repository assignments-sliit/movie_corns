import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:movie_corns/constants/constants.dart';
import 'package:movie_corns/pages/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  ProgressDialog pr;
  Auth auth;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return ValidatorConstants.INVALID_EMAIL_FORMAT;
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return ValidatorConstants.WEAK_PASSWORD;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: ProgressDialogMesssageConstants.LOGGING_IN,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            TitleConstants.LOGIN,
            textAlign: TextAlign.justify,
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_EMAIL, hintText: HintTextConstants.HINT_EMAIL),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_PASSWORD, hintText: HintTextConstants.HINT_PASSWORD),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, 
                      children: <Widget>[
                        Text(ButtonConstants.LOGIN_BUTTON),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_loginFormKey.currentState.validate()) {
                        await pr.show();
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => Firestore.instance
                                .collection("users")
                                .document(currentUser.user.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                    pr.hide().then((isHidden) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    title: TitleConstants.ALL_MOVIES,
                                                    uid: currentUser.user.uid,
                                                  )));
                                    }).whenComplete(() {
                                      Toast.show(ToastConstants.WELCOME, context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }))
                                .catchError((err) => print(err)))
                            .catchError((err) {
                          pr.hide();
                          showAuthError(err.code, context);
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 300,
                  ),
                  Text(LabelConstants.LABEL_NEW_HERE),
                  RaisedButton(
                    textColor: Theme.of(context).primaryColor,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Text(ButtonConstants.JOIN_BUTTON),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            ))));
  }

  void showAuthError(errorCode, BuildContext context) {
    switch (errorCode) {
      case FirebaseAuthErrorConstants.ERROR_WRONG_PASSWORD:
        Toast.show(ToastConstants.INCORRECT_PASSWORD, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        break;

      default:
        Toast.show(ToastConstants.UNKNOWN_AUTH_ERROR, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        break;
    }
  }
}
