import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_sensors/View/view_list.dart';
import '../Models/model.dart';
import '../ViewModel/viewmodel.dart';


// Main screen of the app displaying a list of sensors
class SensorHomePage extends StatelessWidget {
  const SensorHomePage({super.key});
  //Viewmodel tool for loading sensors to list
  //final SensorViewModel logicViewModel = SensorViewModel(model: SensorModel()); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Monitor App'),
      ),
      
      body: FutureBuilder<List<Sensor>>(
        future: Provider.of<SensorViewModel>(context).loadSensors(),
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



