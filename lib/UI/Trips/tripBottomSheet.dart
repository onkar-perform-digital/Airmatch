import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/Services/analytics_service.dart';
import 'package:am_debug/UI/Flights/FlightsList.dart';
import 'package:am_debug/UI/Trips/AirportSearch.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:flutter/material.dart';

class TripBottomSheet extends StatefulWidget {
  const TripBottomSheet({Key key}) : super(key: key);

  @override
  _TripBottomSheetState createState() => _TripBottomSheetState();
}

class _TripBottomSheetState extends State<TripBottomSheet> {
  TextEditingController travelDateController = TextEditingController();
  TextEditingController travellingFromController = TextEditingController();
  TextEditingController travellingToController = TextEditingController();
  TextEditingController bookingNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start by adding a trip",
                style: TextStyle(fontSize: 23, color: Color(0xFF358EE8)),
              ),
              SizedBox(
                height: 10,
              ),
              Text("(Past or Upcoming)",
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              SizedBox(
                height: 20,
              ),
              Text("Travel Date",
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: travelDateController,
                      decoration: InputDecoration(
                        enabled: false,
                        filled: true,
                        hintText: "yyyy-mm-dd",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: InkWell(
                        onTap: () async {
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          // dateCtl.text = date.toIso8601String();
                          travelDateController.text =
                              date.toIso8601String().substring(0, 10);
                        },
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF358EE8),
                          size: 24,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Travelling",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  String fromCity = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AirportSearch()));
                  setState(() {
                    travellingFromController.text = fromCity;
                  });
                },
                child: TextField(
                  enabled: false,
                  controller: travellingFromController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    hintText: "From",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  String toCity = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AirportSearch()));
                  setState(() {
                    travellingToController.text = toCity;
                  });
                },
                child: TextField(
                  enabled: false,
                  controller: travellingToController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "To",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Mode of Travel",
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(
                height: 15,
              ),
              TextField(
                // controller: ,
                //TODO
                decoration: InputDecoration(
                  enabled: false,
                  filled: true,
                  hintText: "Airplane",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: bookingNoController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Booking reference / PNR",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        await AnalyticsService().buttonClicked("New flight Form btn", Constants.uid);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlightsList(
                                arrivalAirport:
                                    travellingToController.text.toString(),
                                departureAirport:
                                    travellingFromController.text.toString(),
                                date: travelDateController.text.toString(),
                              ),
                            ));
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
