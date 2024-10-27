import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//FILE that made by commnand build_runner (dart run build_runner build)
//file contains methods for working with json
part 'model.g.dart';
@JsonSerializable()

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
  // factory Sensor.fromJson(Map<String, dynamic> json) {
  //   return Sensor(
  //     sensorId: json['sensor_id'] ?? null,
  //     name: json['name'] != '' ? json['name'] : 'N/A',
  //     status: json['status'] ?? null,
  //     temperature: (json['temperature']as num?)?.toDouble(),
  //     humidity: (json['humidity'] as num?)?.toDouble(),
  //   );
  // }

  // From json to Sensor
  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);

  // From Sensor to json
  Map<String, dynamic> toJson() => _$SensorToJson(this);
}


// Class that handles loading sensor data
class SensorModel{
  //Method to fetch sensor data from a JSON file stored in the app's assets
  Future<List<Sensor>> fetchSensorsFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final sensors =  jsonData.map((json) => Sensor.fromJson(json)).toList();

    await loadSavedSensors(sensors);
    return sensors;
  }

  Future<void> loadSavedSensors(List<Sensor> sensors) async {
    final prefs = await SharedPreferences.getInstance();

    for (var sensor in sensors){
      String? savedName = prefs.getString('sensor_name_${sensor.sensorId}');
      if (savedName != null){
        sensor.name = savedName;
      }
    }
  }


  Future<void> saveSensorName(int sensorId, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sensor_name_$sensorId', newName);
    //print('Saved name for sensor $sensorId: $newName');
  }
}