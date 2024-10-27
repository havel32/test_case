// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sensor _$SensorFromJson(Map<String, dynamic> json) => Sensor(
      sensorId: (json['sensor_id'] as num?)?.toInt() ?? 0,
      //name: json['name'] as String? ?? 'N/A',
      name: ((json['name'] as String?)?.isEmpty == true || (json['name']  == "N/A")) ? 'Nameless' : json['name'] as String,
      status: (json['status'] as num).toInt(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SensorToJson(Sensor instance) => <String, dynamic>{
      'sensorId': instance.sensorId,
      'name': instance.name,
      'status': instance.status,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
    };
