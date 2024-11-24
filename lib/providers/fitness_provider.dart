import 'package:flutter/foundation.dart';

class FitnessProvider with ChangeNotifier {
  List<Workout> workouts = [];
  List<Meal> meals = [];
  Goal currentGoal = Goal(
    targetWeight: 0,
    targetCalories: 2000,
    weeklyWorkouts: 3,
  );

  void addWorkout(Workout workout) {
    workouts.add(workout);
    notifyListeners();
  }

  void addMeal(Meal meal) {
    meals.add(meal);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    currentGoal = goal;
    notifyListeners();
  }
}

class Workout {
  final String type;
  final int duration;
  final int caloriesBurned;
  final DateTime date;

  Workout({
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
  });
}

class Meal {
  final String name;
  final int calories;
  final DateTime date;
  final String type; // breakfast, lunch, dinner, snack

  Meal({
    required this.name,
    required this.calories,
    required this.date,
    required this.type,
  });
}

class Goal {
  final double targetWeight;
  final int targetCalories;
  final int weeklyWorkouts;

  Goal({
    required this.targetWeight,
    required this.targetCalories,
    required this.weeklyWorkouts,
  });
}