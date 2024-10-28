import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';


// Screen to display detailed information about a specific sensor
class SensorDetailScreen extends StatelessWidget {
  final Sensor sensor;

  const SensorDetailScreen ({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Sensor Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(sensor: sensor),
              const SizedBox(height: 16),
              SensorTable(sensor: sensor),
              const SizedBox(height: 20),
              ChangeNameField(sensor: sensor),
            ],
          ),
        ),
      ),
    );
  }
}

/*
* Display header of sensor deatils
*/
class Header extends StatelessWidget {
  final Sensor sensor;
  const Header({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Sensor Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(width: 8),

        Consumer<SensorViewModel>(
          builder: (context, logicViewModel, _) => Icon(
            logicViewModel.getStatusIcon(sensor.status),
            color: logicViewModel.getStatusColor(sensor.status),
            size: 24,
          ),
        ),
      ],
    );
  }
}


/*
* Display detailed sensor info in a table
*/
class SensorTable extends StatelessWidget{
  final Sensor sensor;

  const SensorTable({super.key, required this.sensor});

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constrains){
        double textSize = constrains.maxWidth < 400 ? 12 : 18;
        // Enables horizontal scroll if needed
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: buildCloumns(textSize), 
            rows: buildRows(context, textSize),
            ),
        );
      }
      );
  }

  List<DataColumn> buildCloumns(double textSize){
    return [
      'ID', 'Name', 'Status', 'Temperature', 'Humidity'
    ].map((title) => DataColumn(
      label: Text(title, style: TextStyle(fontSize: textSize)),
        )
    ).toList();
  }

    List<DataRow> buildRows(BuildContext context, double textSize) {
    return [
      DataRow(cells: [
        DataCell(Text(sensor.sensorId.toString(), style: TextStyle(fontSize: textSize))),
        DataCell(Text(sensor.name, style: TextStyle(fontSize: textSize))),
        DataCell(
          Consumer<SensorViewModel>(
            builder: (context, logicViewModel, _) => Text(
              logicViewModel.getStatusTXT(sensor.status),
              style: TextStyle(fontSize: textSize),
            ),
          ),
        ),
        DataCell(Text(sensor.temperature?.toString() ?? 'N/A', style: TextStyle(fontSize: textSize))),
        DataCell(Text(sensor.humidity?.toString() ?? 'N/A', style: TextStyle(fontSize: textSize))),
      ]),
    ];
  }
}

/* 
* Text field to change the sensor name
*/
class ChangeNameField extends StatefulWidget {
  final Sensor sensor;

  const ChangeNameField({super.key, required this.sensor});

  @override
  ChangeNameFieldState createState() => ChangeNameFieldState();
}

class ChangeNameFieldState extends State<ChangeNameField> {
  // Controller for the text field used to update the sensor name
  late TextEditingController _nameController;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the sensor's current name, if sensor got 'N/A' name it's replaced by ''
    _nameController = TextEditingController(
      text: widget.sensor.name != 'Nameless' ? widget.sensor.name : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // Attach form key for validation
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Sensor Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),
          // Text field to change the sensor name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Sensor Name',
              border: OutlineInputBorder(),
            ),
            // Validator to ensure the name is valid and has no special characters
            validator: (value) => Provider.of<SensorViewModel>(context, listen: false)
                .validateName(value),
          ),

          const SizedBox(height: 16),
          // Button to save the updated name and navigate back
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                Navigator.pop(context, _nameController.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}