import 'package:flutter/material.dart';
import 'package:workoutapp/controller/work_out_controller.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/models/workout_model.dart';
import 'package:workoutapp/view/work_out/work_out_listing/work_out_tile.dart';

class WorkOutListingScreen extends StatefulWidget {
  const WorkOutListingScreen({super.key});

  @override
  State<WorkOutListingScreen> createState() => _WorkOutListingScreenState();
}

class _WorkOutListingScreenState extends State<WorkOutListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

          await WorkOutController.instance
              .createOrEditData(context, selectedDate, null);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: WorkoutModel.readData().isNotEmpty
          ? ListView.separated(
              itemCount: WorkoutModel.readData().length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final WorkoutModel workout = WorkoutModel.readData()[index];
                return WorkOutTile(
                  workout: workout,
                  onDeleteExercise: (ExerciseModel exercise) async {
                    await WorkOutController.instance.deleteExerciseData(
                        workout.copyWith(exercise: [exercise]));
                    setState(() {});
                  },
                  onDeleteWorkout: () async {
                    await WorkOutController.instance.deleteWorkoutData(workout);
                    setState(() {});
                  },
                  onEdit: (ExerciseModel exercise) async {
                    await WorkOutController.instance
                        .createOrEditData(context, workout.day, exercise);
                    setState(() {});
                  },
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
