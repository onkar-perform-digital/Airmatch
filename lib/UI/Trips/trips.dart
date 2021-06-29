import 'dart:ui';

import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/Services/analytics_service.dart';
import 'package:am_debug/Services/getstream.dart';
import 'package:am_debug/Services/photos_api.dart';
import 'package:am_debug/UI/Flight%20GroupChat/chat_page.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/loading.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/UI/Trips/tripBottomSheet.dart';
import 'package:flutter_image/flutter_image.dart';

class Trip extends StatefulWidget {
  const Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String url =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png";

  Future<bool> doesGroupAlreadyExist(String grpName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('groups')
        .where('groupName', isEqualTo: grpName)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getImgUrl(String name) async {
    String res = await PhotosApi().getImgUrl(name);
    return res;
  }

  getMembersCount(String grpName) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(grpName)
            .snapshots(),
        builder: (context, snapshot) {
          List<dynamic> array = snapshot.data["members"];
          return snapshot.hasData
              ? mediumText("${array.length} members", Constants.blackClr)
              : Text("loading");
        });
  }

  @override
  void initState() {
    FirebaseAnalytics().setCurrentScreen(screenName: 'Trips screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 70 / 100,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users/${Constants.uid}/User Travel Info')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  return streamSnapshot.hasData
                      ? ListView.builder(
                          itemCount: streamSnapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return tripTile(
                              streamSnapshot.data.docs[index]['Airline Name'],
                              streamSnapshot.data.docs[index]['Airline No'],
                              streamSnapshot.data.docs[index]
                                  ['Flight Arrival time'],
                              streamSnapshot.data.docs[index]
                                  ['Flight Departure time'],
                              streamSnapshot.data.docs[index]['Date'],
                              streamSnapshot.data.docs[index]['Travelling to'],
                              streamSnapshot.data.docs[index]
                                  ['Travelling from'],
                            );
                          })
                      : Loading();
                },
              ),
            ),
            InkWell(
              onTap: () {
                scaffoldKey.currentState
                    .showBottomSheet<void>((BuildContext context) {
                  AnalyticsService().currentScreen("Trip-Bottom sheet");
                  return TripBottomSheet();
                });
              },
              child: Material(
                elevation: 50,
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 13 / 100,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 20),
                        child: largeText(
                          "Add a trip",
                          Constants.blueClr,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tripTile(
    String airlineName,
    String airlineNo,
    String arrivalTime,
    String departureTime,
    String date,
    String arrivalAirport,
    String departureAirport,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white,
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 45,
                child: Row(
                  children: [
                    smallText("$airlineNo", Constants.blackClr),
                    SizedBox(
                      width: 20,
                    ),
                    smallText("$date", Constants.blackClr),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 250,
                    ),
                    //TODO
                    getMembersCount("$date : $airlineNo"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var grpname = "$date : $airlineNo";
                  await AnalyticsService().grpViews(grpname.toString(), Constants.uid);
                  //await GetStream().creatingWatchingChannel(Constants.myname, grpname.toString());

                  if (await doesGroupAlreadyExist(grpname) == true) {
                    await DatabaseMethods()
                        .joinGrp(Constants.myname, grpname)
                        .whenComplete(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  groupId: grpname,
                                  groupName: grpname,
                                  userName: Constants.myname)));
                    });
                  } else {
                    await DatabaseMethods()
                        .createGroup(Constants.myname, grpname)
                        .whenComplete(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  groupId: grpname,
                                  groupName: grpname,
                                  userName: Constants.myname)));
                    });
                  }
                },
                child: FutureBuilder<String>(
                    future: getImgUrl(arrivalAirport.toString()),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Stack(
                              children: [
                                Image.network(
                                  snapshot.data,
                                  fit: BoxFit.fitWidth,
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5.0, sigmaY: 5.0),
                                      child: Container(
                                        height: 155,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      mediumText(
                                                        "$departureAirport",
                                                        0xFFFFFFFF,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      smallText("Departure",
                                                          0XFFFFFFFF),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      mediumText(
                                                          "${departureTime.substring(11, 16)}",
                                                          0xFFFFFFFF)
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  //color: Colors.blue,
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  mediumText(
                                                    "$airlineName",
                                                    0xFFFFFFFF,
                                                  ),
                                                  //SizedBox(height: 10,),
                                                  Text("-------------->"),
                                                ],
                                              )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  mediumText(
                                                    "$arrivalAirport",
                                                    0xFFFFFFFF,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  smallText(
                                                      "Arrival", 0xFFFFFFFF),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  mediumText(
                                                      "${arrivalTime.substring(11, 16)}",
                                                      0xFFFFFFFF)
                                                ],
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Loading();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
