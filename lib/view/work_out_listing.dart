import 'package:flutter/material.dart';
import 'package:workoutapp/createworkoutscreen.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/models/workout_model.dart';
import 'package:workoutapp/utils/date_time/date_time_formate.dart';
import 'package:workoutapp/view/work_out_listing/work_out_tile.dart';

class WorkOutListingScreen extends StatefulWidget {
  const WorkOutListingScreen({super.key});

  @override
  State<WorkOutListingScreen> createState() => _WorkOutListingScreenState();
}

class _WorkOutListingScreenState extends State<WorkOutListingScreen> {
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  _loadWorkouts() async {
    setState(() {});
  }

  Future<void> _navigateToCreateWorkout(
      DateTime workOutDay, ExerciseModel? exerciseModel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkOutScreen(
          workOutDay: workOutDay,
          exercise: exerciseModel,
        ),
      ),
    );
    if (result == true) {
      _loadWorkouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text(
          'Workout',
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final DateTime? selectedDate = await _selectDate(this.context);
          if (selectedDate == null) return;

          await _navigateToCreateWorkout(selectedDate, null);
          setState(() {});
        },
        // backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body: WorkoutModel.readData().isNotEmpty
          ? ListView.separated(
              itemCount: WorkoutModel.readData().length,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final WorkoutModel workout = WorkoutModel.readData()[index];
                return WorkOutTile(
                  workout: workout,
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.deepPurple[300],
                );
              },
              padding: const EdgeInsets.all(0),
            )
          : const Center(
              child: Text(
                'No Data Found',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }
}
