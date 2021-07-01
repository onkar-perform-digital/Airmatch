import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PhotosApi {

  String imageUrl;
  NetworkImage img;
  String refkey;

  String apikey = "AIzaSyAWpD13FVr-fXe27uje9p2V-fpbea7r_G0";


  Future<String> getImgUrl(String cityName) async {

    // This request gives us the PhotoKey
    String apiurl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$cityName&key=$apikey&inputtype=textquery&fields=name,photos";

    

    var response = await http.get(Uri.parse(apiurl));
    var jsonData = jsonDecode(response.body);

    print(jsonData);

    if(jsonData["status"]=="OK") {
          // child API was there inside Parent API. Hence wrote the function to get result in this way
          jsonData['candidates'].forEach((element1) {
            element1["photos"].forEach((element2) {
              refkey = element2["photo_reference"];
            });
    });
      
      //print(refkey);
    }

    // ImageUrl is Obtained from this request
    imageUrl = "https://maps.googleapis.com/maps/api/place/photo?photoreference=$refkey&key=$apikey&maxwidth=800&maxheight=800";

    img = NetworkImage("$imageUrl");

    return imageUrl;
  }
}