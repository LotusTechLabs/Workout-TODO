import 'package:flutter/material.dart';
import 'package:workoutapp/createworkoutscreen.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/models/workout_model.dart';

class WorkOutController {
  static final WorkOutController _singleton = WorkOutController._internal();

  static WorkOutController get instance => _singleton;

  WorkOutController._internal();

  static WorkOutController getInstance() {
    return _singleton;
  }

  Future<void> saveData(WorkoutModel workoutModel) async => await 
      WorkoutModel.createOrUpdateWorkout(workoutModel);

  Future<void> createOrEditData(
    BuildContext context,
    DateTime workOutDay,
    ExerciseModel? exerciseModel,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkOutScreen(
          workOutDay: workOutDay,
          exercise: exerciseModel,
        ),
      ),
    );
  }

  Future<void> deleteExerciseData(WorkoutModel model) =>
      WorkoutModel.deleteExercise(model);

  Future<void> deleteWorkoutData(WorkoutModel model) =>
      WorkoutModel.deleteWorkout(model);
}
