import 'dart:html';

import 'package:better_vote/network/NetworkHandler.dart';
import 'package:better_vote/views/tabs/CreatePollTab.dart';
import 'package:better_vote/views/tabs/ExploreTab.dart';
import 'package:better_vote/views/tabs/HomeTab.dart';
import 'package:better_vote/views/tabs/NotificationsTab.dart';
import 'package:better_vote/views/tabs/ProfileTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'CreateAPoll.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  int _selectedIndex = 0;
  var _jsonWebToken;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
<<<<<<< HEAD
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Explore',
      style: optionStyle,
    ),
    CreateAPoll(),
    Text(
      'Index 3: Notifications',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
=======
  static List<Widget> _screenOptions = <Widget>[
    HomeTabPage(),
    ExploreTabPage(),
    CreatePollPage(),
    NotificationsTabPage(),
    ProfilePage()
>>>>>>> 4ebad4127833eace575383dcac873ef6e5be0b94
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Widget handleScreenDisplay(data) {
      //Check if token has expired
      _jsonWebToken = data;

      return _screenOptions[_selectedIndex];
    }

    Widget navBar() {
      return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Poll',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      );
    }

    return Scaffold(
      // appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder(
          future: FlutterSecureStorage().read(key: "jwt"),
          builder: (context, snapshot) => snapshot.hasData
              ?
              //snapshot.data is the json web token.
              Center(
                  child: handleScreenDisplay(snapshot.data),
                )
              : snapshot.hasError
                  ? const Text("An error occurred logging in.")
                  : const CircularProgressIndicator()),

      bottomNavigationBar: navBar(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     setState(() {
      //       _selectedIndex = 2;
      //     });
      //   },
      // ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
