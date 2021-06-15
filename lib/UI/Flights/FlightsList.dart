import 'dart:convert';

import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Trips/trips.dart';
import 'package:flutter/material.dart';
import '../../helpers/FlightsModel.dart';
import 'package:http/http.dart' as http;

class FlightsList extends StatefulWidget {
  // const FlightsList({Key key}) : super(key: key);

  String date, arrivalAirport, departureAirport, bookingNo;
  FlightsList(
      {this.arrivalAirport, this.date, this.departureAirport, this.bookingNo});

  @override
  _FlightsListState createState() => _FlightsListState();
}

class _FlightsListState extends State<FlightsList> {
  List<FlightsModel> flights = <FlightsModel>[];
  String url =
      "http://api.aviationstack.com/v1/flights?access_key=72c69476757a9d606ccfcb4bee84ce62";

  Future<void> getAirlines() async {
    flights = [];
    var response = await http.get(url);
    //print(response);

    var jsonData = jsonDecode(response.body);

    print(jsonData);
    jsonData['data'].forEach((element) {
      if (element['flight_date'] == '${widget.date}') {
        if (element['departure']['airport'] == "${widget.departureAirport}" &&
            element['arrival']['airport'] == "${widget.arrivalAirport}") {
          FlightsModel flight = FlightsModel();

          flight.airlineName = element['airline']['name'];
          flight.airlineNo = element['flight']['iata'];
          flight.departureTime = element['departure']['scheduled'];
          flight.arrivalTime = element['arrival']['scheduled'];

          flights.add(flight);
          print(flight.airlineName);
          print(flight.arrivalTime);
          print(flight.departureTime);
          print(flight.airlineNo);
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    getAirlines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Select your Flight",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  return airportTile(
                    airlineName: flights[index].airlineName,
                    airlineNo: flights[index].airlineNo,
                    arrivalTime: flights[index].arrivalTime,
                    departureTime: flights[index].departureTime,
                  );
                }),
          )),
    );
  }

  Widget airportTile(
      {String airlineName,
      String airlineNo,
      String arrivalTime,
      String departureTime}) {
    return GestureDetector(
      onTap: () async {
        await DatabaseMethods()
            .uploadTriptoDB(
              widget.date.toString(),
              widget.departureAirport.toString(),
              widget.arrivalAirport.toString(),
              widget.bookingNo.toString(),
              airlineName.toString(),
              airlineNo.toString(),
              arrivalTime.toString(),
              departureTime.toString(),
            )
            .then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Trip()),
                (route) => false));
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$airlineName -- $airlineNo",
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  arrivalTime,
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
