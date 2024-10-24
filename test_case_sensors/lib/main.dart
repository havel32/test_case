import 'dart:convert';
import 'package:flutter/material.dart';
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
      name: json['name'] ?? '',
      status: json['status'] ?? null,
      temperature: (json['temperature']as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );
  }
}

Future<List<Sensor>> fetchSensorsFromAssets() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  final List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.map((json) => Sensor.fromJson(json)).toList();
}

class SensorListScreen extends StatefulWidget {
  final List<Sensor> sensors;

  SensorListScreen({required this.sensors});


  @override
  SensorListScreenState createState() => SensorListScreenState();
  
}


class SensorDetailScreen extends StatefulWidget {
  final Sensor sensor;

  SensorDetailScreen ({required this.sensor});


  @override
  SensorDetailScreenState createState() => SensorDetailScreenState();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorHomePage(),
    );
  }
}

class SensorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Monitor App'),
      ),
      body: FutureBuilder<List<Sensor>>(
        future: fetchSensorsFromAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sensors available'));
          } else {
            return SensorListScreen(sensors: snapshot.data!);
          }
        },
      ),
    );
  }
}




class SensorListScreenState extends State<SensorListScreen>{


  String _searchQuery = '';


  void _updateSensorName(int sensorId, String newName){
    setState(() {
      final sensor = widget.sensors.firstWhere((s) => s.sensorId == sensorId);
      sensor.name = newName;
    });
  }

  // Function for getting a color by status
  Color _getStatusColor(int status) {
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

  // Function for getting an icon by status
  IconData _getStatusIcon(int status) {
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

  @override
  Widget build(BuildContext context) {
    final int count = widget.sensors.length;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sensors'),
              const SizedBox(height: 5),
              Text('Count: $count'),
            ],
          ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.sensors.where((sensor) => sensor.name.toLowerCase().contains(_searchQuery)).length,
        itemBuilder: (context, index) {
          final sensor = widget.sensors.where((sensor) => sensor.name.toLowerCase().contains(_searchQuery)).toList()[index];
          return Card(
            child: ListTile(
              leading: Icon(
                _getStatusIcon(sensor.status),
                color: _getStatusColor(sensor.status),
              ),
              title: Text(sensor.name != '' ? sensor.name : 'N/A'),
              subtitle: Text('Status: ${sensor.status}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {
                final newName = await Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => SensorDetailScreen(sensor: sensor),
                  ),
                );

                if (newName != null){
                  _updateSensorName(sensor.sensorId, newName);
                }
              },
            ),
          );
        },
      ),
    );
  }

}

class SensorDetailScreenState extends State<SensorDetailScreen>{

  late TextEditingController _nameController;

  final formKey = GlobalKey<FormState>();

  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sensor.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool containsSpecialSymbol(String input){
    final specialCharRegExp = RegExp(r'^[A-Za-zА-яЁё0-9-_\s]+$');
    return !specialCharRegExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed sensor information'),
      ),
      body: Padding(padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sensor info',
                  style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  
                ),

                const SizedBox(height: 16),
                Center(
                      child:  DataTable(columns: 
                          const [DataColumn(label: Text('ID', style: TextStyle(fontSize: 20))),
                                DataColumn(label: Text('Name', style: TextStyle(fontSize: 20))),
                                DataColumn(label: Text('Status', style: TextStyle(fontSize: 20))),
                                DataColumn(label: Text('Temperature', style: TextStyle(fontSize: 20))),
                                DataColumn(label: Text('Humidity', style: TextStyle(fontSize: 20)))],
                                
                                  rows: [
                                DataRow(cells: [
                                DataCell(Text(widget.sensor.sensorId.toString(), style: const TextStyle(fontSize: 20))),
                                DataCell(Text(widget.sensor.name, style: const TextStyle(fontSize: 20))),
                                DataCell(Text(widget.sensor.status.toString(), style: const TextStyle(fontSize: 20))),
                                DataCell(Text(widget.sensor.temperature != null ? widget.sensor.temperature.toString() : 'N/A', style: const TextStyle(fontSize: 20))),
                                DataCell(Text(widget.sensor.humidity != null ? widget.sensor.humidity.toString() : 'N/A', style: const TextStyle(fontSize: 20))),
                            ]),
                        ],
                      ),      
                ),

                const Text(
                  'Change sensor name',
                  style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Sensor name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please enter a sensor name';
                    }
                    if (containsSpecialSymbol(value)){
                      return 'Special symbols are not allowed in the name of sensor, exept "-", "_"';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                    if (formKey.currentState!.validate()){
                      Navigator.pop(context, _nameController.text);
                    }
                  }, 
                  child: const Text('Save')
                ),
              ],
            ),
            ),  
          ),
      ),
    );
  }
}