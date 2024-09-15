import 'package:intl/intl.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/storage/storage.dart';
import 'package:workoutapp/utils/date_time/date_time_formate.dart';

class WorkoutModel {
  final List<ExerciseModel> exercise;
  final DateTime day;

  WorkoutModel({
    required this.day,
    required this.exercise,
  });

  WorkoutModel copyWith({
    List<ExerciseModel>? exercise,
    DateTime? day,
  }) {
    return WorkoutModel(
      day: day ?? this.day,
      exercise: exercise ?? this.exercise,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': DateTimeFormate.dateFormat.format(day),
      'exercise': exercise.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    final List<ExerciseModel> exercise = ((map['exercise'] ?? []) as List)
        .map((e) => ExerciseModel.fromMap(e))
        .toList();
    return WorkoutModel(
      exercise: exercise,
      day: DateTimeFormate.dateFormat.parse(map['day']),
    );
  }

  static Future<List<WorkoutModel>> createOrUpdateWorkout(
      WorkoutModel workoutModel) async {
    final List<WorkoutModel> data = readData();
    final newData = _findAndReplaceOrAdd(data, workoutModel);
    await Storage.instance
        .write(StorageKey.workouts, newData.map((e) => e.toMap()).toList());
    final savedData = readData();
    return savedData;
  }

  static List<WorkoutModel> readData() {
    final rawData = (Storage.instance.read(StorageKey.workouts) ?? []) as List;
    List<WorkoutModel> workouts =
        rawData.map((e) => WorkoutModel.fromMap(e)).toList();
    workouts.sort((a, b) => b.day.compareTo(a.day));
    return workouts;
  }

  static _findAndReplaceOrAdd(List<WorkoutModel> data, WorkoutModel model) {
    bool found = false;
    // Iterate through the list to find a matching workout by day
    for (int i = 0; i < data.length; i++) {
      if (data[i].day == model.day) {
        for (int j = 0; j < data[i].exercise.length; j++) {
          if (data[i]
              .exercise[j]
              .createdAt
              .isAtSameMomentAs(model.exercise.first.createdAt)) {
            data[i].exercise[j] = model.exercise.first;
            found = true;
            break;
          }
        }
        if (!found) {
          data[i].exercise.add(model.exercise.first);
          found = true;
          break;
        }
      }
    }

    // If no matching workout was found, add it to the list
    if (!found) {
      data.add(model);
    }
    return data;
  }

  static deleteWorkout(WorkoutModel model) async {
    final List<WorkoutModel> data = readData();

    data.removeWhere((workout) => workout.day.isAtSameMomentAs(model.day));

    await Storage.instance
        .write(StorageKey.workouts, data.map((e) => e.toMap()).toList());
  }

  static deleteExercise(WorkoutModel model) async {
    final List<WorkoutModel> data = readData();

    for (int i = 0; i < data.length; i++) {
      if (data[i].day == model.day) {
        data[i].exercise.removeWhere((exercise) => model
            .exercise.first.createdAt
            .isAtSameMomentAs(exercise.createdAt));

        break;
      }
    }

    await Storage.instance
        .write(StorageKey.workouts, data.map((e) => e.toMap()).toList());
  }
}
