import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';
import 'view_provider.dart';


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


// Screen to display detailed information about a specific sensor
class SensorDetailScreen extends StatefulWidget {
  final Sensor sensor;

  const SensorDetailScreen ({super.key, required this.sensor});

  @override
  SensorDetailScreenState createState() => SensorDetailScreenState();
}


class SensorDetailScreenState extends State<SensorDetailScreen>{
  // Controller for the text field used to update the sensor name
  late TextEditingController _nameController;

  // ViewModel for setting color and color according to status
  SensorViewModel logicViewModel = SensorViewModel(model: SensorModel()); 

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the sensor's current name, if sensor got 'N/A' name it's replaced by ''
    _nameController = TextEditingController(text: widget.sensor.name != 'Nameless' ? widget.sensor.name : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Function to check if the input contains any special characters except space, "-", "_"
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            // Attach form key for validation
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text(
                    'Sensor info',
                    style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(width: 8), // Add some space between the icon and text

                  Icon(
                    logicViewModel.getStatusIcon(widget.sensor.status),
                    color: logicViewModel.getStatusColor(widget.sensor.status),
                    size: 24,
                  )
                ],
                ),

                const SizedBox(height: 16),
                // Display detailed sensor info in a table
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints){
                      // Calculate text size based on screen width
                      double textSize = constraints.maxWidth < 400 ? 12 : 18;
                      return SingleChildScrollView(
                        // Enables horizontal scroll if needed
                        scrollDirection: Axis.horizontal,
                        child:  DataTable(
                                columns: [
                                DataColumn(label: Text('ID', style: TextStyle(fontSize: textSize))),
                                DataColumn(label: Text('Name', style: TextStyle(fontSize: textSize))),
                                DataColumn(label: Text('Status', style: TextStyle(fontSize: textSize))),
                                DataColumn(label: Text('Temperature', style: TextStyle(fontSize: textSize))),
                                DataColumn(label: Text('Humidity', style: TextStyle(fontSize: textSize)))],
                                
                                rows: [
                                DataRow(cells: [
                                DataCell(Text(widget.sensor.sensorId.toString(), style: TextStyle(fontSize: textSize))),
                                DataCell(Text(widget.sensor.name, style: TextStyle(fontSize: textSize))),
                                DataCell(Text(logicViewModel.getStatusTXT(widget.sensor.status), style: TextStyle(fontSize: textSize))),
                                DataCell(Text(widget.sensor.temperature != null ? widget.sensor.temperature.toString() : 'N/A', style: TextStyle(fontSize: textSize))),
                                DataCell(Text(widget.sensor.humidity != null ? widget.sensor.humidity.toString() : 'N/A', style: TextStyle(fontSize: textSize))),
                            ]),
                          ],
                        ),
                      );
                    }
                  ),      
                ),

                const SizedBox(height: 10),
                const Text(
                  'Change sensor name',
                  style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),
                // Text field to change the sensor name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Sensor name',
                    border: OutlineInputBorder(),
                  ),
                  // Validator to ensure the name is valid and has no special characters
                  validator: (value){
                    if (value == null || logicViewModel.cleanUpSpaces(value).isEmpty == true){
                      return 'Invalid input! Please enter a sensor name';
                    }
                    if (containsSpecialSymbol(value)){
                      return 'Invalid input! Special symbols are not allowed in the name of sensor, exept "-", "_"';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                // Button to save the updated name and navigate back
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



