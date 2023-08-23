import 'dart:convert';

import 'package:Weather/const/app_const.dart';
import 'package:Weather/models/weather.dart';
// import 'package:flutter_bloc_weather_example/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  Future<WeatherModel> getWeather({double? lat, double? long}) async {
    double latitude = lat == null ? 19.076090 : lat;
    double longitude = long == null ? 72.877426 : long;

    final response = await http.get(
      Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?units=metric&lat=$latitude&lon=$longitude&appid=$apiKey"),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<WeatherModel> searchWeather(
    String locationName,
  ) async {
    final response = await http.get(
      Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=$apiKey&units=metric"),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
