import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../Models/model.dart';

/*
*   ViewModel class that interacts with the SensorModel and provides data 
*   to View.
*/
class SensorViewModel extends ChangeNotifier {
  final SensorModel model;
  SensorViewModel({required this.model});

  String searchQuery = '';
  List<Sensor> sensors = []; // Internal sensor list cache
  List<Sensor> get filteredSensors => getFilteredSensors();

  /*
  * Setter for sensors
  */
  void setSensors(List<Sensor> sensorsList) {
    sensors = sensorsList;
  }

  /*
  *   Method for deleting extra spaces from input
  */
  String cleanUpSpaces(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /* 
  *   Updates the name of a sensor based on its [sensorId] and [newName].
  *   Locates the sensor in the provided list and modifies its name.
  */
  void updateSensorName(int sensorId, String newName) {
    
    final cleanedName = cleanUpSpaces(newName);
    final sensor = sensors.firstWhere((s) => s.sensorId == sensorId);
    sensor.name = cleanedName;

    model.saveSensorName(sensorId, cleanedName);

    notifyListeners();
  }

  /*
  *  Method for loading updated names from shared_preferences
  */
  Future<void> loadUpdatedNames(List<Sensor> sensors) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var sensor in sensors) {
      String? updatedName = prefs.getString('sensor_name_${sensor.sensorId}');
      if (updatedName != null) {
        sensor.name = updatedName;
      }
    }

    notifyListeners();
  }

  /*
  *   Loads the list of sensors asynchronously using the model's data-fetching method.
  *   Returns a future that resolves to a list of sensors.
  */
  Future<List<Sensor>> loadSensors() async {
    List<Sensor> sensors = await model.fetchSensorsFromAssets();
    return sensors;
  }

  /*
  * Method for updating searchQuery with notify
  */
  void updateSearchQuery(String value) {
    searchQuery = value.trim().toLowerCase();

    notifyListeners();
  }

  /*
  * Method for realizing search 
  */
  void performSearch(BuildContext context, TextEditingController controller) {
    Provider.of<SensorViewModel>(context, listen:  false).updateSearchQuery(controller.text);
  }

  /*
  * Method for reset search 
  */
  void clearSearch(BuildContext context, TextEditingController controller) {
    Provider.of<SensorViewModel>(context, listen:  false).updateSearchQuery('');
  }

  /*
  * Method for getting filtered sensors according to searchQuery
  */
  List<Sensor> getFilteredSensors() {
    if (searchQuery.isEmpty) {
      return sensors;
    }

    return sensors
        .where((sensor) => sensor.name.toLowerCase().contains(searchQuery))
        .toList();
  }

  /*
  * Method to check if the input contains any special characters except space, "-", "_"
  */
  String? containsSpecialSymbol(String input) {
    final specialCharRegExp = RegExp(r'^[A-Za-zА-яЁё0-9-_\s]+$');
    if (!specialCharRegExp.hasMatch(input)) {
      return 'Invalid input! Special symbols are not allowed in the name of sensor, exept "-", "_"';
    } else {
      return null;
    }
  }

  /*
  * Method to check if input is empty
  */
  String? isEmpty(String? value) {
    if (value == null || cleanUpSpaces(value).isEmpty == true) {
      return 'Invalid input! Please enter a sensor name.';
    } else {
      return null;
    }
  }

  /*
  * Method for name validation
  */
  String? validateName(String? value) {
    final emptyCheck = isEmpty(value);
    if (emptyCheck != null) return emptyCheck;

    final specialSymbolCheck = containsSpecialSymbol(value!);
    if (specialSymbolCheck != null) return specialSymbolCheck;

    return null;
  }

  /*
  * Function to get a color by status
  */
  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.red;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.green;
      case 6:
        return Colors.grey;
      case 7:
        return Colors.yellow;
      case 8:
        return Colors.yellow;
      case 9:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  /*
  * Function to get an icon by status
  */
  IconData getStatusIcon(int status) {
    switch (status) {
      case 1:
        return Icons.check_circle;
      case 2:
        return Icons.warning_outlined;
      case 3:
        return Icons.fireplace;
      case 4:
        return Icons.lock_open;
      case 5:
        return Icons.lock;
      case 6:
        return Icons.nearby_error_outlined;
      case 7:
        return Icons.battery_alert;
      case 8:
        return Icons.thermostat;
      case 9:
        return Icons.water;
      default:
        return Icons.help;
    }
  }

  /*
  * Function to get an icon by status
  */
  String getStatusTXT(int status) {
    switch (status) {
      case 1:
        return "Готов";
      case 2:
        return "Тревога";
      case 3:
        return "Пожар";
      case 4:
        return "Корпус открыт";
      case 5:
        return "Корпус закрыт";
      case 6:
        return "Потерян";
      case 7:
        return "Низкий заряд батареи";
      case 8:
        return "Событие по температуре";
      case 9:
        return "Событие по влажности";
      default:
        return "Неизвестно";
    }
  }
}
