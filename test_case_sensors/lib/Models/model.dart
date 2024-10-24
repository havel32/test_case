import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class Sensor {
  final int sensorId;
  String name;
  final int status;
  final double? temperature;
  final double? humidity;

  Sensor({
    required this.sensorId,
    required this.name,
    required this.status,
    this.temperature,
    this.humidity,
  });

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

class SensorModel{
  Future<List<Sensor>> fetchSensorsFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Sensor.fromJson(json)).toList();
  }
}