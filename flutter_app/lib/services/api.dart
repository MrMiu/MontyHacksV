import 'dart:convert';

import "package:http/http.dart" as http;

class Api {
  Future<Map<String, dynamic>> fireApi({required String latitude, required String longitude}) async {
    Map<String, dynamic> weatherData = {};
    var weatherResponse = await http.get(Uri.parse('https://api.ambeedata.com/weather/latest/by-lat-lng?lat=$latitude&lng=$longitude'),
        headers: {"x-api-key": "e7a8b369605f1c3f5896e17272a17c4b9cd25b1e232cf497159029c4866ae338"});
    weatherData = json.decode(weatherResponse.body.toString());

    Map<String, dynamic> soilData = {};
    var soilResponse = await http.get(Uri.parse('https://api.ambeedata.com/soil/latest/by-lat-lng?lat=$latitude&lng=$longitude'),
        headers: {"x-api-key": "e7a8b369605f1c3f5896e17272a17c4b9cd25b1e232cf497159029c4866ae338"});
    soilData = json.decode(soilResponse.body.toString());

    Map<String, dynamic> fireData = {};
    fireData["Soil Temperature"] = soilData["soil_temperature"];
    fireData["Wind Speed"] = weatherData["windSpeed"];
    fireData["Dew Point"] = weatherData["dewPoint"];
    fireData["Rel Humidity"] = weatherData["humidity"];
    fireData["Temperature"] = weatherData["temperature"];
    double precipIntensity = weatherData["precipIntensity"] ?? 0.0;
    fireData["Precipitation"] = precipIntensity / 25.4;

    return fireData["data"];
  }

  Future<Map<String, dynamic>> flaskFireApi({required String latitude, required String longitude}) async {
    Map<String, dynamic> data = {};

    fireApi(latitude: latitude, longitude: longitude).then((value) async {
      Map<String, dynamic> fireData = value;
      var weatherResponse = await http.get(
        Uri.parse(
            'http://10.0.2.2:5000/fireprediction?humidity=${fireData["humidity"]}&temperature=${fireData["temperature"]}&dewPoint=${fireData["dewPoint"]}&windSpeed=${fireData["windSpeed"]}&soil_temperature=${fireData["soiltemeprature"]}&precipitation=${fireData["precipIntensity"]}'),
      );
      data = json.decode(weatherResponse.body.toString());
    });
    print(data);
    return data;
  }

  
}
