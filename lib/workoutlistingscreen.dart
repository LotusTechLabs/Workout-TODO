import 'package:flutter/material.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/models/workout_model.dart';
import 'package:workoutapp/utils/date_time/date_time_formate.dart';
import 'CreateWorkOutScreen.dart';
import 'DataBase/SqlHelper.dart';

class WorkOutListingScreen extends StatefulWidget {
  const WorkOutListingScreen({super.key});

  @override
  State<WorkOutListingScreen> createState() => _WorkOutListingScreenState();
}

class _WorkOutListingScreenState extends State<WorkOutListingScreen> {
  final _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  _loadWorkouts() async {
    final data = await _dbHelper.getAllWorkouts();
    setState(() {
      workouts = data;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: workouts.isNotEmpty
            ? ListView.separated(
                itemCount: WorkoutModel.readData().length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final WorkoutModel workout = WorkoutModel.readData()[index];
                  return Column(
                    children: [
                      Text(DateTimeFormate.dateFormat.format(workout.day)),
                      ListView.separated(
                          itemCount: workout.exercise.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            final ExerciseModel exercise =
                                workout.exercise[index];
                            return InkWell(
                              onTap: () async {
                                _navigateToCreateWorkout(workout.day, exercise);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${exercise.name.name} - ${exercise.weight}kg, ${exercise.repetitions} reps',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                    onPressed: () async {
                                      await WorkoutModel.deleteExercise(workout
                                          .copyWith(exercise: [exercise]));
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
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
