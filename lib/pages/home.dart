import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/authentication.dart';
import 'package:weather_app/components/weatherCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  String _currentLocation = '';
  List<dynamic> _weatherList = [];
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await AuthService().isAuthenticated();
    if (isAuthenticated) {
      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Future<void> _initLocation() async {
    // Check for location permission
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = '${position.latitude}, ${position.longitude}';
      });
      await _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _currentLocation = 'Could not fetch location';
      });
      print(e);
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final apiKey = '9cbac07e793cf8f4ca4bd6c6fbe50071';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);
        setState(() {
          _weatherList = weatherData['list'];
        });
      } else {
        setState(() {
          _weatherList = [];
        });
      }
    } catch (e) {
      setState(() {
        _weatherList = [];
      });
      print(e);
    }
  }

  void _logout(BuildContext context) async {
    await AuthService().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App - $_currentLocation'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Web Layout
            return _buildWebLayout();
          } else {
            // Mobile Layout
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return _weatherList.isNotEmpty
        ? ListView.builder(
            itemCount: _weatherList.length,
            itemBuilder: (context, index) {
              return WeatherCard(weather: _weatherList[index]);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildWebLayout() {
    return _weatherList.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
            ),
            itemCount: _weatherList.length,
            itemBuilder: (context, index) {
              return WeatherCard(weather: _weatherList[index]);
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
