import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PhotosApi {

  String imageUrl;
  NetworkImage img;
  String refkey;

  String apikey = "AIzaSyAWpD13FVr-fXe27uje9p2V-fpbea7r_G0";

  Future<String> getImgUrl(String cityName) async {
    String apiurl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$cityName&key=$apikey&inputtype=textquery&fields=name,photos";

    

    var response = await http.get(apiurl);
    var jsonData = jsonDecode(response.body);

    print(jsonData);

    if(jsonData["status"]=="OK") {

          jsonData['candidates'].forEach((element1) {
            element1["photos"].forEach((element2) {
              refkey = element2["photo_reference"];
            });
    });
      
      //print(refkey);
    }

    imageUrl = "https://maps.googleapis.com/maps/api/place/photo?photoreference=$refkey&key=$apikey&maxwidth=800&maxheight=800";

    img = NetworkImage("$imageUrl");

    return imageUrl;
  }
}