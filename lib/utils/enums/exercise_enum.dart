enum ExerciseEnum {
  benchPress("Bench press"),
  barbellRow("Barbell row"),
  shoulderPress("Shoulder press"),
  deadLift("Dead lift"),
  squat("Squat");

  const ExerciseEnum(this.name);
  final String name;

  static ExerciseEnum fromString(String name) {
    return ExerciseEnum.values.firstWhere((e) => e.name == name, orElse: () {
      throw Exception('Invalid enum value: $name');
    });
  }
}
