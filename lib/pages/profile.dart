import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_corns/api/services/auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this
  final Auth auth = new Auth();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  String userId = "";
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user?.uid;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Your Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sign Out"),
                        content: Text("Are you sure want to sign out?"),
                        actions: [
                          FlatButton(
                            child: Text("CANCEL"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("YES"),
                            onPressed: () {
                              widget.auth.signOut();
                              print('User signout Complete');
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/login", (_) => false);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: _prepareDetailAndBody(context, userId));
  }

  Widget _prepareDetailAndBody(BuildContext context, String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('users').document(userId).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _movieDetailBody(context, snapshot.data);
      },
    );
  }

  Widget _movieDetailBody(BuildContext context, DocumentSnapshot snapshot) {
    print(userId);
    final rating = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        snapshot["email"],
        style: TextStyle(color: Colors.white),
      ),
    );

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          snapshot["fname"] + " " + snapshot["surname"],
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        SizedBox(height: 20.0),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Expanded(child: rating)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        )
      ],
    );

    final headerContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/5b2c320e96e76f7d01013067/1530825643239-9KF07AF9QGKARM6XQKY4/ke17ZwdGBToddI8pDm48kOQScsc5TY8jCuObUFgfhqRZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpydfvc957wEB9Bk1XYZkNiy-OPlMj7dW9OZ3-IR2fYHYSbnS5Sr8t-axcDC25WJZaM/Man-Gentleman-Silhouette-Gray-Free-Illustrations-F-0424.jpg"),
                  fit: BoxFit.cover),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(54, 60, 100, .9)),
          child: Center(
            child: header,
          ),
        ),
      ],
    );

    final editProfileButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          icon: Icon(Icons.edit, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          onPressed: () => {_displayDialog(context, snapshot)},
          color: Theme.of(context).primaryColor,
          label: Text("EDIT PROFILE", style: TextStyle(color: Colors.white)),
        ));

    final deleteAccountButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          icon: Icon(Icons.delete, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          onPressed: () => {},
          color: Colors.red,
          label: Text("DELETE PROFILE", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[editProfileButton, deleteAccountButton],
        ),
      ),
    );

    //and fiiiinally..........
    return new Scaffold(
      body: Column(
        children: <Widget>[headerContent, bottomContent],
      ),
    );
  }

  String getMovieUrl(String snapUrl) {
    if (snapUrl.isEmpty)
      return "https://www.google.com/url?sa=i&url=http%3A%2F%2Fgearr.scannain.com%2Fmovies%2Fcharlie-lennon-ceol-on-gcroi%2F&psig=AOvVaw2yh_ZWeDf6OwCYaUroCkSU&ust=1588220621163000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJi9_YHljOkCFQAAAAAdAAAAABAI";

    return snapUrl;
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  _displayDialog(BuildContext context, DocumentSnapshot snapshot) async {
    TextEditingController fnameController = new TextEditingController();
    TextEditingController surnameConroller = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Profile'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            content: Container(
              height: 100,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: fnameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: snapshot["fname"]),
                    ),
                    TextField(
                      controller: surnameConroller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: snapshot["surname"]),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                //enableFeedback: 
                onPressed: () {
                  //return false;
                  if(surnameConroller.text.isEmpty ||
                    fnameController.text.isEmpty){
                  String fname = "";
                  String surname = "";

                  if (fnameController.text.isEmpty)
                    fname = snapshot["fname"];
                  else
                    fname = fnameController.text;

                  if (surnameConroller.text.isEmpty)
                    surname = snapshot["surname"];
                  else
                    surname = surnameConroller.text;

                  print(widget.uid);

                  Firestore.instance
                      .collection('users')
                      .document(userId)
                      .setData({
                    "fname": fname,
                    "surname": surname,
                    "email": snapshot["email"],
                    "uid": userId
                  });
                  Navigator.of(context).pop();
                  return true;
                  }else{
                    return false;
                  }
                },
                child: Text("UPDATE"),
              ),
            ],
          );
        });
  }
}
