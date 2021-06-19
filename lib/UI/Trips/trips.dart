import 'dart:ui';

import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/Services/photos_api.dart';
import 'package:am_debug/UI/Flight%20GroupChat/chat_page.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // @override
  // void initState() {
  //   doesGroupAlreadyExist("nova");
  //   super.initState();
  // }

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
                  return ListView.builder(
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
                          streamSnapshot.data.docs[index]['Travelling from'],
                        );
                      });
                },
              ),
            ),
            InkWell(
              onTap: () {
                scaffoldKey.currentState
                    .showBottomSheet<void>((BuildContext context) {
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
                        child: Text(
                          "Add a trip",
                          style: TextStyle(
                              color: Color(0xFF358EE8),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                    Text("$airlineNo"),
                    SizedBox(
                      width: 20,
                    ),
                    Text("$date"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 250,
                    ),
                    //TODO
                    // Text("${FirebaseFirestore.instance.collection('groups').doc('$date : $airlineNo')}"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var grpname = "$date : $airlineNo";
                  if (await doesGroupAlreadyExist(grpname) == true) {
                    DatabaseMethods().joinGrp(Constants.myname, grpname);
                  } else {
                    DatabaseMethods().createGroup(Constants.myname, grpname);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              groupId: grpname,
                              groupName: grpname,
                              userName: Constants.myname)));
                },
                child: FutureBuilder<String>(
                    future: getImgUrl(arrivalAirport.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Stack(
                          children: [
                            Image.network(
                              snapshot.data,
                              fit: BoxFit.cover,
                              height: 155,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //   image: DecorationImage(
                                    //     image: NetworkImage(snapshot.data),
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    height: 155,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "$departureAirport",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Departure"),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("1:15pm")
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
                                              Text(
                                                "$airlineName",
                                                style: TextStyle(fontSize: 15),
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
                                              Text(
                                                "$arrivalAirport",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Arrival"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("3:15pm")
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
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        height: 155,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$departureAirport",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Departure"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("1:15pm")
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  //color: Colors.blue,
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$airlineName",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  //SizedBox(height: 10,),
                                  Text("-------------->"),
                                ],
                              )),
                            ),
                            Expanded(
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$arrivalAirport",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Arrival"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("3:15pm")
                                ],
                              )),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
