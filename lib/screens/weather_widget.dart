import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String weatherDescription = '';
  String temperature = '';
  String iconCode = '';
  String humidity = '';
  String windSpeed = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    const apiKey =
        '60d7b980f7da638967fed7f0aaf80f84'; // Replace with your OpenWeatherMap API key
    const city = 'kottayam'; // Replace with your desired city
    const url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);

      setState(() {
        weatherDescription = weatherData['weather'][0]['description'];
        temperature = (weatherData['main']['temp'] - 273.15).toStringAsFixed(1);
        iconCode = weatherData['weather'][0]['icon'];
        humidity = weatherData['main']['humidity'].toString();
        windSpeed = weatherData['wind']['speed'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Image.network(
                'http://openweathermap.org/img/wn/$iconCode.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$temperature°C',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Humidity: $humidity%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Wind Speed: $windSpeed m/s',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
