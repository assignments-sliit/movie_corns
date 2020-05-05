import 'package:flutter/material.dart';
import 'package:movie_corns/constants/constants.dart';
import 'profile.dart';
import 'movies.dart';
import 'my_reviews.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid})
      : super(key: key); 
  final String title;
  final String uid; 

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex = 0;
  List<Widget> tabs = [MoviePage(), MyReviewsPage(), ProfilePage()];
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.movie), title: Text(TitleConstants.ALL_MOVIES)),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text(TitleConstants.MY_REVIEWS)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text(TitleConstants.PROFILE))
        ],
      ),
    );
  }
}
