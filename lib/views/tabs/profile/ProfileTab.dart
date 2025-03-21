import 'package:better_vote/controllers/UserController.dart';
import 'package:better_vote/models/Poll.dart';
import 'package:better_vote/models/User.dart';
import 'package:better_vote/views/tabs/home/Postcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabPage extends StatefulWidget {
  // ProfileTabPage( {Key key}) : super(key: key)
  @override
  State<ProfileTabPage> createState() => ProfileState();
}

class ProfileState extends State<ProfileTabPage> {
  List<Poll> polls;
  int numPollsCreated = 0;
  int numPollsVoted = 0;
  bool _isDisplayingVotedPolls = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          builder: profileBuilder, future: UserController().findProfileData()),
    );
  }

  Widget profileBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      User _user = snapshot.data;
      return FutureBuilder(
          future: getLengths(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              return profileInfo(_user);
            }

            return CircularProgressIndicator();
          });
    }
    if (snapshot.hasError) {
      print(snapshot.stackTrace.toString());
      return Text("An error occurred fetching user data.");
    }

    return Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF00b764))),
    );
  }

  getLengths() async {
    final SharedPreferences prefs = await _prefs;
    int newnum = prefs.getInt("numPollsCreated");
    int newvoted = prefs.getInt("numPollsVoted");
    numPollsCreated = newnum != null ? newnum : 0;
    numPollsVoted = newvoted != null ? prefs.getInt("numPollsVoted") : 0;
  }

  Widget pollsCreated(User _user) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            polls = snapshot.data;
            if (polls.length > 0)
              return ListView.builder(
                  itemCount: polls.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    //Replace this widget

                    return PostCard(polls[index]);
                  });
            else {
              return Center(
                child: Text("No polls to display"),
              );
            }
          }

          if (snapshot.hasError)
            return Text("An error occurred fetching polls.");
          return Center(
            child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF00b764))),
          );
        },
        future: _user.getCreatedPolls());
  }

  Widget pollsVoted(User _user) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            polls = snapshot.data;
            if (polls.length > 0)
              return ListView.builder(
                  itemCount: polls.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    //Replace this widget

                    return PostCard(polls[index]);
                  });
            else {
              return Center(
                child: Text("No polls to display"),
              );
            }
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("An error occurred fetching polls.");
          }
          return Center(
            child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF00b764))),
          );
        },
        future: _user.getVotedPolls());
  }

  Widget profileInfo(User _user) {
    return DefaultTabController(
      length: 2,
      child: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 250,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings_outlined),
                    color: Color(0xFF00b764))
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    // Icon(
                    //   Icons.account_circle_outlined,
                    //   size: 120,
                    //   color: Colors.white,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_user.getAvatar()),
                      ),
                    ),

                    Text(
                      _user.getUsername(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      textScaleFactor: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_user.getnumPollsCreated()} Created",
                              textScaleFactor: 1.1,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              " · ",
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${_user.getnumPollsVoted()} Participated in",
                              textScaleFactor: 1.1,
                              style: TextStyle(color: Colors.black),
                            )
                          ]),
                    ),
                  ]),
                ),
              ),
              floating: true,
              pinned: true,
              snap: true,
              bottom: new TabBar(
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF00b764),
                  labelColor: Color(0xFF00b764),
                  isScrollable: false,
                  tabs: [
                    new Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: new Tab(text: 'Polls I Created'),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: new Tab(text: 'Polls I Voted In'),
                    )
                  ]),
            ),
          ];
        },
        body: new TabBarView(
          children: <Widget>[
            pollsCreated(_user),
            pollsVoted(_user),
          ],
        ),
      ),
    );
  }
}



      // ListView(
      //   children: [
      //     Container(
      //       //Top User Info Bar
      //       alignment: Alignment.topCenter,
      //       color: darkGreen,
      //       height: 275,
      //       child: Column(children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   // 2 Top Buttons
              //   children: [
              //     IconButton(
              //         alignment: Alignment.topLeft,
              //         onPressed: onPressed,
              //         icon: Icon(Icons.arrow_back, size: 50)),
              //     TextButton(
              //         style: TextButton.styleFrom(
              //             primary: Colors.black,
              //             padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
              //             textStyle: TextStyle(
              //                 fontSize: 22, fontWeight: FontWeight.bold)),
              //         onPressed: onPressed,
              //         child: Text("EDIT"))
              //   ],
              // ),
      //         Icon(Icons.account_circle_outlined, size: 150),
      //         Text(
      //           _user.getUsername(),
      //           style: const TextStyle(fontWeight: FontWeight.bold),
      //           textScaleFactor: 2,
      //         ),
      //         Padding(
      //           padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      //           child:
      //               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //             Text("# Polls Created: ", textScaleFactor: 1.1),
      //             Text("# Polls Participated in: ", textScaleFactor: 1.1)
      //           ]),
      //         ),
      //       ]),
      //     ),

      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Expanded(
      //           child: Container(
      //               decoration: BoxDecoration(
      //                   color: darkGreen,
      //                   border: Border(
      //                       top: BorderSide(width: 4, color: Color(0xFF000000)),
      //                       left:
      //                           BorderSide(width: 0, color: Color(0xFF000000)),
      //                       right:
      //                           BorderSide(width: 3, color: Color(0xFF000000)),
      //                       bottom: BorderSide(
      //                           width: 4, color: Color(0xFF000000)))),
      //               child: TextButton(
      //                   style: TextButton.styleFrom(
      //                       primary: Colors.black,
      //                       padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
      //                       textStyle: TextStyle(
      //                           fontSize: 22, fontWeight: FontWeight.bold)),
      //                   onPressed: () {
      //                     getUserCreatedPolls(_user);
      //                   },
      //                   child: Text("Polls I created"))),
      //         ),
      //         Expanded(
      //             child: Container(
      //                 decoration: BoxDecoration(
      //                     color: darkGreen,
      //                     border: Border(
      //                         top: BorderSide(
      //                             width: 4, color: Color(0xFF000000)),
      //                         left: BorderSide(
      //                             width: 3, color: Color(0xFF000000)),
      //                         right: BorderSide(
      //                             width: 0, color: Color(0xFF000000)),
      //                         bottom: BorderSide(
      //                             width: 4, color: Color(0xFF000000)))),
      //                 child: TextButton(
      //                     style: TextButton.styleFrom(
      //                         primary: Colors.black,
      //                         padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
      //                         textStyle: TextStyle(
      //                             fontSize: 22, fontWeight: FontWeight.bold)),
      //                     onPressed: () {
      //                       getUserVotedPolls(_user);
      //                     },
      //                     child: Text("Polls I voted in"))))
      //       ],
      //     ),


          // Container(
          //   height: 50,
          //   padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          //   alignment: Alignment.topLeft,
          //   child: Row(children: [
          //     Text("Sort By: ",
          //         style: const TextStyle(
          //             fontWeight: FontWeight.bold, fontSize: 18)),
          //     DropdownButton<String>(
          //       value: dropdownValue,
          //       onChanged: (value) {
          //         setState(() {
          //           dropdownValue = value;
          //           print(dropdownValue);
          //         });
          //       },
          //       items: <String>['Active', 'Closed', 'Third']
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value,
          //                 style: const TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.black)));
          //       }).toList(),
          //       underline: Container(
          //         height: 1,
          //         color: Colors.deepPurpleAccent,
          //       ),
          //     ),
          //   ]),
          // ),

          //
          //Sort by dropdown
          // Column(
          // ListView.builder(
          //     itemCount: polls.length,
          //     shrinkWrap: true,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Text("Thing");
          //       // Widget to make
          //       // return PollThingy(polls[index]);
          //     })
      //     FutureBuilder(
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             polls = snapshot.data;
      //             return ListView.builder(
      //                 itemCount: polls.length,
      //                 shrinkWrap: true,
      //                 itemBuilder: (BuildContext context, int index) {
      //                   return PostCard(polls[index]);
      //                   // Widget to make
      //                   // return PollThingy(polls[index]);
      //                 });
      //           }

      //           if (snapshot.hasError)
      //             return Text("An error occurred fetching polls.");
      //           return Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         },
      //         future: handleDisplay(_user))

      //     // ) // Polls
      //   ],
      // );