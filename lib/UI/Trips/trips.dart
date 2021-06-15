import 'package:flutter/material.dart';
import 'package:am_debug/UI/Trips/tripBottomSheet.dart';

class Trip extends StatefulWidget {
  const Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
}
