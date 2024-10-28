import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_sensors/View/view_details.dart';
import 'view_provider.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';

// Main screen displaying thee list of sensors
class SensorListScreen extends StatelessWidget {
  final List<Sensor> sensors;

  const SensorListScreen({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    context.read<SensorViewModel>().setSensors(sensors);
    return Scaffold(
      appBar: buildAppBar(context, sensors.length),
      body: SensorList(sensors: sensors),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, int sensorCount) {
    return AppBar(
      toolbarHeight: 70,
      // Display the title and sensor count in the AppBar
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sensors'), // Main title
          const SizedBox(height: 5),
          Text('Count: $sensorCount'), // Display the count of sensors
        ],
      ),
      actions: [
        // IconButton to toggle between light and dark themes
        IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).switchTheme();
            })
      ],
      // Search bar at the bottom of the AppBar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: SearchBar(),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<SensorViewModel>(builder: (context, logicViewModel, _){
        return Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              //  Search when Enter is pressed
              onSubmitted: (_) => logicViewModel.performSearch(context, nameController),
            ),
          ),

          const SizedBox(width: 8),

          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => logicViewModel.performSearch(context, nameController),
          ),

          // Reset button
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => logicViewModel.clearSearch(context, nameController),
          ),
        ],
      );
      })
      
    );
  }
}


class SensorList extends StatelessWidget {
  final List<Sensor> sensors;

  const SensorList({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorViewModel>(builder: (context, logicViewModel, _) {
      final fliteredSensors = logicViewModel.filteredSensors;
      return ListView.builder(
        itemCount: fliteredSensors.length,
        itemBuilder: (context, index) {
          // Filter the sensors based on the search query
          final sensor = fliteredSensors[index];
          // Build each sensor item as a Card with a ListTile
          return SensorCard(sensor: sensor);
        },
      );
    });
  }
}

class SensorCard extends StatelessWidget {
  final Sensor sensor;

  const SensorCard({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorViewModel>(
      builder: (context, logicViewModel, _) {
        return Card(
          child: ListTile(
            leading: Icon(
              logicViewModel.getStatusIcon(sensor.status),
              color: logicViewModel.getStatusColor(sensor.status),
            ),
            title: Text(sensor.name),
            subtitle:
                Text('Status: ${logicViewModel.getStatusTXT(sensor.status)}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              // Переход на экран деталей сенсора
              final newName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorDetailScreen(sensor: sensor),
                ),
              );

              // Обновляем имя сенсора, если было введено новое
              if (newName != null) {
                logicViewModel.updateSensorName(sensor.sensorId, newName);
              }
            },
          ),
        );
      },
    );
  }
}
