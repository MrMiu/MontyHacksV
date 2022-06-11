import 'dart:convert';

import "package:http/http.dart" as http;

class Api {
  Future<Map<String, dynamic>> fireApi({required String latitude, required String longitude}) async {
    Map<String, dynamic> weatherData = {};
    var weatherResponse = await http.get(Uri.parse('https://api.ambeedata.com/weather/latest/by-lat-lng?lat=$latitude&lng=$longitude'),
        headers: {"x-api-key": "99254931d677f7a426eb9f291ee62abce3b1c8340c5ed2e58cc750675e77495a"});
    weatherData = json.decode(weatherResponse.body.toString());
    print(weatherData);

    Map<String, dynamic> soilData = {};
    var soilResponse = await http.get(Uri.parse('https://api.ambeedata.com/soil/latest/by-lat-lng?lat=$latitude&lng=$longitude'),
        headers: {"x-api-key": "99254931d677f7a426eb9f291ee62abce3b1c8340c5ed2e58cc750675e77495a"});
    soilData = json.decode(soilResponse.body.toString());
    print(soilData);

    Map<String, dynamic> fireData = {};
    fireData["Soil Temperature"] = soilData["soil_temperature"];
    fireData["Wind Speed"] = weatherData["windSpeed"];
    fireData["Dew Point"] = weatherData["dewPoint"];
    fireData["Rel Humidity"] = weatherData["humidity"];
    fireData["Temperature"] = weatherData["temperature"];
    fireData["Precipitation"] = double.parse(weatherData["precipIntensity"]) / 25.4;

    return fireData;
  }


  

}
