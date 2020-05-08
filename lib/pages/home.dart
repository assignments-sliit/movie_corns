import 'package:flutter/material.dart';
import 'package:movie_corns/constants/constants.dart';
import 'profile.dart';
import 'movies.dart';
import 'my_reviews.dart';

/* 
* IT17143950 - G.M.A.S. Bastiansz
*
* The home.dart file is containing with the bottom navigation of the app.
* The bottom navigation of the app contains with 3 tabs namely "Home", "My Reviews", "Profile" 
* which are redirected the user to movie page, my reviews page & user profile page respectively.
* The reason for coding the bottom navigation seperately is avoiding the unnecessary lengths of 
* source code in each page & the easiness of doung editting in navigation tabs without wasting time 
*/

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid}) : super(key: key);
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

  //build bottom navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          //create 'All Movies' tab
          BottomNavigationBarItem(
              icon: Icon(Icons.movie), title: Text(TitleConstants.ALL_MOVIES)),

          //create 'My Reviews' tab
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text(TitleConstants.MY_REVIEWS)),

          //create 'Profile' tab
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text(TitleConstants.PROFILE))
        ],
      ),
    );
  }
}
