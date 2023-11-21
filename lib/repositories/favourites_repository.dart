//get your API Key here: https://weatherstack.com/

import 'dart:convert';
import 'package:app_wheater/models/response_geocoding.dart' hide Location;
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../models/response_api_wheater.dart' hide Location;

class AppRepository extends ChangeNotifier {
  bool isLoading = true;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late ResponseApiWheater responseApiWheater;
  late ResponseGeocoding responseGeocoding;
  late String query = "";

  AppRepository() {
    //get location
    getLocation();
  }

  toggleLoading() async {
    isLoading = !isLoading;
    notifyListeners();
  }

  saveQuery(text) {
    query = text;
    notifyListeners();
  }

  getLocation() async {
    isLoading = true;
    notifyListeners();
    Location location = Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 1
    );

    _locationData = await location.getLocation();
    getGeocoding();
  }

  getDataWheater(String lat, String lng) async {
    try {
      var response = await http.get(Uri.parse(
          "http://api.weatherstack.com/current?access_key=<YOUR_API_KEY_HERE>&query=$lat,$lng"));
      if (response.statusCode == 200) {
        var dados = jsonDecode(response.body);
        responseApiWheater = ResponseApiWheater.fromJson(dados);
        isLoading = false;
        query = responseApiWheater.location.name;
        notifyListeners();
      } else {
        print("Erro");
      }
    } catch (e) {
      print("Erro");
    }
  }

  getGeocoding() async {
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=<YOUR_API_KEY_HERE>"));
      if (response.statusCode == 200) {
        var dados = json.decode(response.body);
        print(dados['status']);
        if (dados['status'] == "OK") {
          responseGeocoding = ResponseGeocoding.fromJson(dados["results"][0]);
          var lat = responseGeocoding.geometry.location.lat.toString();
          var lng = responseGeocoding.geometry.location.lng.toString();
          getDataWheater(lat, lng);
        } else {
          print("Erro: ${dados.toString()}\nQuery: $query");
        }
      } else {
        print("Erro 2");
      }
    } catch (e) {
      print("Erro 3");
    }
  }
}
