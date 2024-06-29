import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  String _formatDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));

    String formattedTime = DateFormat('HH:mm').format(dateTime);

    if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(today)) {
      return 'Today, $formattedTime';
    } else if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(tomorrow)) {
      return 'Tomorrow, $formattedTime';
    } else {
      return '${DateFormat('EEEE').format(dateTime)}, $formattedTime'; // Day of the week and time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: _buildWeatherIcon(weather['weather'][0]['main']),
        title: Text(
          '${weather['main']['temp'].round()}°C - ${weather['weather'][0]['description']}',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          _formatDate(weather['dt']),
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String weatherMain) {
    IconData iconData;
    switch (weatherMain) {
      case 'Clear':
        iconData = Icons.wb_sunny;
        break;
      case 'Clouds':
        iconData = Icons.cloud;
        break;
      case 'Rain':
        iconData = Icons.beach_access;
        break;
      case 'Snow':
        iconData = Icons.ac_unit;
        break;
      default:
        iconData = Icons.wb_cloudy;
        break;
    }
    return Icon(iconData, color: Colors.white, size: 40);
  }
}
