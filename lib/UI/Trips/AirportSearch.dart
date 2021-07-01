import 'dart:async';
import 'dart:convert';

import 'package:am_debug/UI/Flights/FlightsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/helpers/AirportModel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AirportSearch extends StatefulWidget {
  const AirportSearch({Key key}) : super(key: key);

  @override
  _AirportSearchState createState() => _AirportSearchState();
}

class _AirportSearchState extends State<AirportSearch> {
  TextEditingController searchController = TextEditingController();
  List<AirportModel> airports = <AirportModel>[];

  // String url =
  //     "http://api.aviationstack.com/v1/airports?access_key=72c69476757a9d606ccfcb4bee84ce62&limit=6472";

  String url = "Data/airports.json";

  Future<void> getAirports(String query) async {
    airports = [];
    //var response = await http.get(url);
    var response = await rootBundle.loadString(url);
    //print(response);

    var jsonData = jsonDecode(response);

    print(jsonData);
    jsonData['data'].forEach((element) {
      if (element['airport_name'] != null &&
          element['country_name'] != null &&
          query != "") {
        if (element['airport_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element['country_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          AirportModel airport = AirportModel();

          airport.name = element['airport_name'];
          airport.country = element['country_name'];

          airports.add(airport);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Airport"),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      style: TextStyle(
                        //color: Colors.white70,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String query) {
                        if (searchController != null) {
                          Timer(Duration(milliseconds: 3000), () {
                            setState(() {
                              getAirports(searchController.text.toString());
                            });
                          });

                          // If above dosen't work try this //TODO
                          // setState(() {
                          //   getAirports(searchController.text.toString());
                          // });
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type search here...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        getAirports(searchController.text.toString());
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                              colors: [Colors.grey, Colors.blueGrey])),
                      height: 45.0,
                      width: 45.0,
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blueGrey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    return SingleChildScrollView(
      child: Container(
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: airports.length,
            itemBuilder: (context, index) {
              return airportTile(
                name: airports[index].name,
                country: airports[index].country,
              );
            }),
      ),
    );
  }

  Widget airportTile({String name, String country}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, "$name");
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  country,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
