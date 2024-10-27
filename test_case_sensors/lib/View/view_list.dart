import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_sensors/View/view_details.dart';
import 'view_provider.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';


// Main screen displaying thee list of sensors
class SensorListScreen extends StatefulWidget {
  final List<Sensor> sensors;

  const SensorListScreen({super.key, required this.sensors});

  @override
  SensorListScreenState createState() => SensorListScreenState();
}


class SensorListScreenState extends State<SensorListScreen>{

  // ViewModel for changing sensor's name and setting color and color according to status
  SensorViewModel logicViewModel = SensorViewModel(model: SensorModel());

  // To store search query entered by the user
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final int count = widget.sensors.length;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        // Display the title and sensor count in the AppBar
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sensors'),      // Main title
              const SizedBox(height: 5),
              Text('Count: $count'),      // Display the count of sensors
            ],
          ),
        actions: [
          // IconButton to toggle between light and dark themes
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: (){
              Provider.of<ThemeProvider>(context, listen: false).switchTheme();
            })
        ],
        // Search bar at the bottom of the AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
               // Update the search query as the user types
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
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
      // Display the list of sensors using ListView.builder
      body: ListView.builder(
        itemCount: widget.sensors.where((sensor) => sensor.name.toLowerCase().contains(searchQuery)).length,
        itemBuilder: (context, index) {
          // Filter the sensors based on the search query
          final sensor = widget.sensors.where((sensor) => sensor.name.toLowerCase().contains(searchQuery)).toList()[index];
          // Build each sensor item as a Card with a ListTile
          return Card(
            child: ListTile(
              leading: Icon(
                logicViewModel.getStatusIcon(sensor.status),
                color: logicViewModel.getStatusColor(sensor.status),
              ),
              title: Text(sensor.name),
              subtitle: Text('Status: ${logicViewModel.getStatusTXT(sensor.status)}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {

                // Navigate to the SensorDetailScreen when a sensor is tapped
                final newName = await Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => SensorDetailScreen(sensor: sensor),
                  ),
                );
                
                // Update the sensor name if a new one was entered
                if (newName != null){
                  setState(() {
                    logicViewModel.updateSensorName(widget.sensors, sensor.sensorId, newName);
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
