import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


//Сlass representing sensors
class Sensor {
  final int sensorId;         // Sensor's unique ID
  String name;                // Sensor's name (changeable)
  final int status;           // Sensor's status
  final double? temperature;  // Sensor's temperature (nullable)
  final double? humidity;     // Sensor's humidity (nullable)
  
  // Constructor to initialize a sensor object
  Sensor({
    required this.sensorId,
    required this.name,
    required this.status,
    this.temperature,
    this.humidity,
  });

  // Factory constructor to create a sensor from a JSON object
  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      sensorId: json['sensor_id'] ?? null,
      name: json['name'] != '' ? json['name'] : 'N/A',
      status: json['status'] ?? null,
      temperature: (json['temperature']as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );
  }
}


// Class that handles loading sensor data
class SensorModel{
  // Method to fetch sensor data from a JSON file stored in the app's assets
  Future<List<Sensor>> fetchSensorsFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Sensor.fromJson(json)).toList();
  }
}