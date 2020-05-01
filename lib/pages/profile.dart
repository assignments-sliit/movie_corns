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
        Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 30.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          snapshot["fname"],
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        SizedBox(height: 20.0),
        Text(
          snapshot["surname"],
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
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
          height: MediaQuery.of(context).size.height * 0.512,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(54, 60, 100, .9)),
          child: Center(
            child: header,
          ),
        ),
      ],
    );

    final movieDetail = Text(
      "Please press the below button if you want to delete your account",
      style: TextStyle(fontSize: 15.5),
    );

    final addReviewButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          icon: Icon(Icons.delete, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          onPressed: () => {print('Delete account')},
          color: Colors.red,
          label: Text("DELETE ACCOUNT", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[movieDetail, addReviewButton],
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
}
