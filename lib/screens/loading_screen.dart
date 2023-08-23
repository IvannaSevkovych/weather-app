import 'package:flutter/material.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<Map<String, dynamic>> getLocationData() async {
    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';

    Location location = Location();

    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;

    if (apiKey != 'default_api_key') {
      NetworkHelper networkHelper = NetworkHelper(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&units=metric');
      return await networkHelper.getData();
    } else {
      print('API key not found in environment variables.');
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await dotenv.load(fileName: ".env");
    var weatherData = await getLocationData();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      )),
    );
  }
}
