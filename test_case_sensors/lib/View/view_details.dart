import 'package:flutter/material.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';


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
                    final emptyCheck = logicViewModel.isEmpty(value);
                    if (emptyCheck != null) return logicViewModel.isEmpty(value);

                    final specialSymbolCheck = logicViewModel.containsSpecialSymbol(value!);
                    if (specialSymbolCheck != null) return specialSymbolCheck;

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



