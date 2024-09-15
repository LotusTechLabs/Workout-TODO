import 'package:flutter/material.dart';
import 'package:workoutapp/models/exercise_model.dart';
import 'package:workoutapp/models/workout_model.dart';
import 'package:workoutapp/utils/date_time/date_time_formate.dart';

class WorkOutTile extends StatefulWidget {
  final WorkoutModel workout;
  const WorkOutTile({
    super.key,
    required this.workout,
  });

  @override
  State<WorkOutTile> createState() => _WorkOutTileState();
}

class _WorkOutTileState extends State<WorkOutTile> {
  final ExpansionTileController controller = ExpansionTileController();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      controller: controller,
      title: Text(
        DateTimeFormate.dateFormat.format(widget.workout.day),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Total exercise: ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.workout.exercise.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      // visualDensity: VisualDensity.comfortable,
      childrenPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white10,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
            itemCount: widget.workout.exercise.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ExerciseModel exercise = widget.workout.exercise[index];
              return ListTile(
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                minVerticalPadding: 0,
                title: Text(
                  exercise.name.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Weight: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: '${exercise.weight}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Repetitions: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: '${exercise.repetitions}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => WorkoutModel.deleteWorkout(
                              widget.workout.copyWith(exercise: [exercise])),
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.deepPurple[200],
              );
            },
          ),
        ),
      ],
    );
  }
}
