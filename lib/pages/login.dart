import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:movie_corns/constants/constants.dart';
import 'package:movie_corns/pages/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
 * IT17050272 - D. Manoj Kumar
 * 
 *  This source code in login.dart file is used to create the user interface 
 * as well as the backend tasks of the Login page of the app. In order to
 * signin to the app user needs to provide the email address as the username
 * & the password which he/she mentioed while registering the app 
 * (mentioned in register.dart). Once the user enters the username & password the
 * system will compare those credentials with database. If creadentials matched,
 * user will be redirected to the next page, movie page with relavant user id.
 * If creadentials not matched then, the system will display relavant error
 * message. Also, user needs to provide both username & password before clicks on
 * 'LOGIN' button, if not the system will provide relavant error messages telling that
 * fields are empty. Apart from these, the user can redirected to register.dart file
 * if user doesn't signup before.
 *  These are the tasks which are fulfilled by this dart file. 
 */

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

  Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  //Start email & password validation
  //Start email validation
  //check whether all the necessary points in email are included in user entered email/username
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
  //End email validation

  //Start Password validation
  String pwdValidator(String value) {
    //check whether the number of characters in tha password less than 8
    if (value.length < 8) {
      return ValidatorConstants.WEAK_PASSWORD;
    } else {
      return null;
    }
  }
  //End password validation
  //End email & password validation

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
                        labelText: LabelConstants.LABEL_EMAIL,
                        hintText: HintTextConstants.HINT_EMAIL),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_PASSWORD,
                        hintText: HintTextConstants.HINT_PASSWORD),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                                    title: TitleConstants
                                                        .ALL_MOVIES,
                                                    uid: currentUser.user.uid,
                                                  )));
                                    }).whenComplete(() {
                                      toast(
                                          ToastConstants.WELCOME,
                                          Toast.LENGTH_LONG,
                                          ToastGravity.BOTTOM,
                                          Colors.blueGrey);
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
        toast(ToastConstants.INCORRECT_PASSWORD, Toast.LENGTH_LONG,
            ToastGravity.BOTTOM, Colors.blueGrey);
        break;

      default:
        toast(ToastConstants.UNKNOWN_AUTH_ERROR, Toast.LENGTH_LONG,
            ToastGravity.BOTTOM, Colors.blueGrey);
        break;
    }
  }
}
