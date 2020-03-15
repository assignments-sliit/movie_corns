import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override 
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Center(
        child: new Text('This is where the login form would be.... hello'),
      ),
    );
  }
}