import 'package:flutter/material.dart';

import '../Models/model.dart';


class SensorViewModel extends ChangeNotifier{
  final SensorModel model;
  SensorViewModel({required this.model });

  Future<List<Sensor>> loadSensors() async {
    return await model.fetchSensorsFromAssets();
  }

  void updateSensorName(List<Sensor> sensors, int sensorId, String newName){
    final sensor = sensors.firstWhere((s) => s.sensorId == sensorId);
    sensor.name = newName;
  }
}