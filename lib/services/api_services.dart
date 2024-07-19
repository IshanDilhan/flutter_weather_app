import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  final String apiKey = "&appid=2cc5277f8552cabc98443f7b96343453";

  Future<Map<String, dynamic>> getWeatherData(String location) async {
    final String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$location";
    try {
      http.Response response = await http.get(Uri.parse("$weatherUrl$apiKey"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception occurred while fetching weather data: $e");
    }
  }
}

class ApiServicesforzip {
  final String apiKey = "&appid=2cc5277f8552cabc98443f7b96343453";

  Future<Map<String, dynamic>> getWeatherData(
      String location, String countrycode) async {
    final String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?zip=$location,$countrycode";
    try {
      http.Response response = await http.get(Uri.parse("$weatherUrl$apiKey"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception occurred while fetching weather data: $e");
    }
  }
}

class ApiServicesforlocation {
  final String apiKey = "&appid=2cc5277f8552cabc98443f7b96343453";

  Future<Map<String, dynamic>> getWeatherData(
      String latitude, String longitude) async {
    final String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude";
    try {
      http.Response response = await http.get(Uri.parse("$weatherUrl$apiKey"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception occurred while fetching weather data: $e");
    }
  }
}
