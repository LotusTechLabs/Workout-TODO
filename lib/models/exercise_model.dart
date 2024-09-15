import 'package:workoutapp/utils/enums/exercise_enum.dart';

class ExerciseModel {
  final ExerciseEnum name;

  /// weight in KG
  final int weight;

  final int repetitions;

  final DateTime createdAt;

  final DateTime updatedAt;

  ExerciseModel({
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.createdAt,
    required this.updatedAt,
  });

  ExerciseModel copyWith({
    ExerciseEnum? name,
    int? weight,
    int? repetitions,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      name: ExerciseEnum.fromString(map['name']), // Convert index to enum
      weight: map['weight'],
      repetitions: map['repetitions'],
      createdAt: DateTime.parse(map['createdAt']), // Convert string to DateTime
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.name, // Convert enum to its index
      'weight': weight,
      'repetitions': repetitions,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to string
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
