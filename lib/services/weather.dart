import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherModel {
  static const openWeatherMapURL =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<String> getApiKey() async {
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    return apiKey;
  }

  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    var apiKey = await getApiKey();

    if (apiKey != 'default_api_key') {
      NetworkHelper networkHelper = NetworkHelper(
          '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');
      return await networkHelper.getData();
    } else {
      print('API key not found in environment variables.');
      return {};
    }
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    var apiKey = await getApiKey();

    Location location = Location();
    await location.getCurrentLocation();

    if (apiKey != 'default_api_key') {
      NetworkHelper networkHelper = NetworkHelper(
          '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric&units=metric');
      return await networkHelper.getData();
    } else {
      print('API key not found in environment variables.');
      return {};
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
